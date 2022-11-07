// SPDX-License-Identifier: MIT

// Graphing prices???

pragma solidity 0.6.6;

import "./GovtMock.sol";

contract LandContract {
    string public surveyNumber;
    string public taluk;
    string public district;
    address verifier;
    uint256 public gasReserve;

    enum CONTRACT_STATE {
        open,
        closed
    }

    CONTRACT_STATE public ctr_state;

    address payable public owner;
    address[] public prev_owners;
    uint256[] public prev_prices;
    address[] public bidders;

    mapping(address => uint256) bidderToWei;
    uint256 minWei;

    constructor(
        string memory _snum,
        string memory _taluk,
        string memory _district,
        address _ver,
        uint256 _gasreserve
    ) public {
        taluk = _taluk;
        surveyNumber = _snum;
        district = _district;
        ctr_state = CONTRACT_STATE.closed;
        owner = payable(msg.sender);
        verifier = _ver;
        gasReserve = _gasreserve;
    }

    function get_current_owner() public view returns (address) {
        return owner;
    }

    function sale(uint256 _minwei) public {
        require(msg.sender == owner, "Only the owner can call this function");
        require(
            ctr_state == CONTRACT_STATE.closed,
            "Auction is already ongoing"
        );
        ctr_state = CONTRACT_STATE.open;
        minWei = _minwei;
    }

    function end_sale() public {
        address max_bidder = find_max_bidder();
        uint256 max_wei = bidderToWei[max_bidder];
        if (!(max_wei >= minWei)) {
            ctr_state = CONTRACT_STATE.closed;
            for (uint256 i = 0; i < bidders.length; i++) {
                address payable bidder = payable(bidders[i]);
                uint256 amount = bidderToWei[bidders[i]];
                bidder.transfer(amount - gasReserve);
            }

            // Delete bidders
            for (uint256 i = 0; i < bidders.length; i++) {
                bidderToWei[bidders[i]] = 0;
            }
            bidders = new address[](0);
            ctr_state = CONTRACT_STATE.closed;
        } else {
            owner.transfer(max_wei - gasReserve);
            prev_owners.push(owner);
            owner = payable(max_bidder);
            for (uint256 i = 0; i < bidders.length; i++) {
                address payable bidder = payable(bidders[i]);
                uint256 amount = bidderToWei[bidders[i]];
                bidder.transfer(amount - gasReserve);
            }

            // Delete bidders
            for (uint256 i = 0; i < bidders.length; i++) {
                bidderToWei[bidders[i]] = 0;
            }
            bidders = new address[](0);
            ctr_state = CONTRACT_STATE.closed;

            prev_prices.push(max_wei);
        }
    }

    function find_max_bidder() public view returns (address) {
        require(bidders.length > 0);
        address max_bidder = bidders[0];
        uint256 max_wei = bidderToWei[max_bidder];
        for (uint256 i = 0; i < bidders.length; i++) {
            address bidder = bidders[i];
            uint256 weiNum = bidderToWei[bidder];
            if (weiNum > max_wei) {
                max_bidder = bidder;
                max_wei = weiNum;
            }
        }
        return max_bidder;
    }

    function bidder_exists(address _check_val) public view returns (bool) {
        for (uint256 i = 0; i < bidders.length; i++) {
            if (bidders[i] == _check_val) {
                return true;
            }
        }

        return false;
    }

    function cancel_bid() public {
        require(bidder_exists(msg.sender));
        uint256 amount = bidderToWei[msg.sender];
        bidderToWei[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
        removeBidder(msg.sender);
    }

    function removeBidder(address bidder) public {
        delete bidders[findIndex(bidder)];
    }

    function findIndex(address bidder) public view returns (uint256) {
        for (uint256 i = 0; i < bidders.length; i++) {
            if (bidders[i] == bidder) {
                return i;
            }
        }
    }

    function enter() public payable {
        GovtMock govtmock = GovtMock(verifier);
        require(govtmock.verify_address(msg.sender));
        require(msg.value > gasReserve);
        if (bidder_exists(msg.sender)) {
            uint256 amount = bidderToWei[msg.sender];
            payable(msg.sender).transfer(amount - gasReserve);
            removeBidder(msg.sender);
        }
        bidders.push(msg.sender);
        bidderToWei[msg.sender] = msg.value;
    }
}

// SPDX-License-Identifier: MIT

// Live Bidding???
// Graphing prices???

pragma solidity 0.6.6;

contract LandContract {
    string public surveyNumber;
    string public taluk;
    string public district;

    enum CONTRACT_STATE {
        open,
        closed
    }

    CONTRACT_STATE public ctr_state;

    address payable public owner;
    address[] public prev_owners;
    address[] public bidders;

    mapping(address => uint256) bidderToWei;
    uint256 minWei;

    constructor(
        string memory _snum,
        string memory _taluk,
        string memory _district
    ) public {
        taluk = _taluk;
        surveyNumber = _snum;
        district = _district;
        ctr_state = CONTRACT_STATE.closed;
        owner = payable(msg.sender);
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
                bidder.transfer(amount - 430500000000000);
            }
        } else {
            owner.transfer(max_wei - 430500000000000);
            prev_owners.push(owner);
            owner = payable(max_bidder);
            for (uint256 i = 0; i < bidders.length; i++) {
                address payable bidder = payable(bidders[i]);
                uint256 amount = bidderToWei[bidders[i]];
                bidder.transfer(amount - 430500000000000);
            }

            // Delete bidders
            for (uint256 i = 0; i < bidders.length; i++) {
                bidderToWei[bidders[i]] = 0;
            }
            bidders = new address[](0);
            ctr_state = CONTRACT_STATE.closed;
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
        require(!bidder_exists(msg.sender));
        require(msg.value > 430500000000000);
        bidders.push(msg.sender);
        bidderToWei[msg.sender] = msg.value;
    }
}

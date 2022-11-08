// SPDX-License-Identifier: MIT

pragma solidity 0.6.6;

import "./NFTMinter.sol";
import "./LandContract.sol";

contract GovtMock {
    NFTMinter minter;
    uint256 public gasreserve;
    address[] landcontracts;
    address[] available;
    address[] landowns;

    function owns(address addr) public returns (address[] memory) {
        uint256 len = landcontracts.length;

        for (uint256 i = 0; i < len; i++) {
            landcontracts.pop();
        }

        for (uint256 i = 0; i < landcontracts.length; i++) {
            LandContract ctrct = LandContract(address(landcontracts[i]));
            if (address(addr) == address(ctrct.owner())) {
                landowns.push(address(ctrct));
            }
        }
    }

    constructor(uint256 _gasreserve) public {
        minter = new NFTMinter();
        gasreserve = _gasreserve;
    }

    function create_land(
        string memory _snum,
        string memory _taluk,
        string memory _district
    ) public {
        LandContract ctrct = new LandContract(
            _snum,
            _taluk,
            _district,
            msg.sender,
            gasreserve
        );
        landcontracts.push(address(ctrct));
    }

    function get_verified() public {
        NFTMinter(address(minter)).mintNFT(msg.sender);
    }

    function auctionable() public returns (address[] memory) {
        uint256 len = available.length;

        for (uint256 i = 0; i < len; i++) {
            available.pop();
        }

        for (uint256 i = 0; i < landcontracts.length; i++) {
            LandContract ctrct = LandContract(landcontracts[i]);
            available.push(address(ctrct));
        }

        return available;
    }

    function verify_address(address addr) public returns (bool) {
        uint256[] memory assets;
        assets = NFTMinter(address(minter)).assetsOf(addr);
        for (uint256 i = 0; i < assets.length; i++) {
            if (verify_owner(addr, assets[i])) {
                return true;
            }
        }

        return false;
    }

    function verify_owner(address addr_to_verify, uint256 tokenID)
        public
        view
        returns (bool)
    {
        return
            NFTMinter(address(minter)).original_owner(tokenID) ==
            addr_to_verify;
    }
}

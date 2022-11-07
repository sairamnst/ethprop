// SPDX-License-Identifier: MIT

pragma solidity 0.6.6;

import "./NFTMinter.sol";

contract GovtMock {
    NFTMinter minter;

    constructor() public {
        minter = new NFTMinter();
    }

    function get_verified() public {
        NFTMinter(address(minter)).mintNFT(msg.sender);
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

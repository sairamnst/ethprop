// SPDX-License-Identifier: MIT

pragma solidity 0.6.6;

import "./NFTMinter.sol";
import "./LandContract.sol";

contract GovtMock {
    NFTMinter minter;
    uint256 public gasreserve;

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

// SPDX-License-Identifier: MIT

pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMinter is ERC721, Ownable {
    uint256 tokenCounter;
    mapping(uint256 => address) idtooriginalowner;

    // used by assetsof
    uint256[] tokens;

    constructor() public ERC721("Identity", "DID") {
        tokenCounter = 0;
    }

    function mintNFT(address owner) public onlyOwner returns (uint256) {
        uint256 tokenID = tokenCounter;
        tokenCounter += 1;
        _safeMint(owner, tokenID);
        idtooriginalowner[tokenID] = msg.sender;
        return tokenID;
    }

    function original_owner(uint256 id) public view returns (address) {
        return idtooriginalowner[id];
    }

    function assetsOf(address owner) public returns (uint256[] memory) {
        uint256 times = tokens.length;
        for (uint256 i = 0; i < times; i++) {
            tokens.pop();
        }

        for (uint256 i = 0; i < tokenCounter; i += 1) {
            if (ownerOf(i) == owner) {
                tokens.push(i);
            }
        }

        return tokens;
    }
}

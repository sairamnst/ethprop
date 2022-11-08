// SPDX-License-Identifier: MIT

pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMinter is ERC721 {
    uint256 tokenCounter;
    mapping(uint256 => address) idtooriginalowner;

    // used by assetsof
    uint256[] tokens;
    address owner;

    constructor() public ERC721("Identity", "DID") {
        tokenCounter = 0;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function mintNFT(address owner_to) public onlyOwner returns (uint256) {
        uint256 tokenID = tokenCounter;
        tokenCounter += 1;
        _safeMint(owner_to, tokenID);
        idtooriginalowner[tokenID] = msg.sender;
        return tokenID;
    }

    function original_owner(uint256 id) public view returns (address) {
        return idtooriginalowner[id];
    }

    function assetsOf(address owns_addr) public returns (uint256[] memory) {
        uint256 times = tokens.length;
        for (uint256 i = 0; i < times; i++) {
            tokens.pop();
        }

        for (uint256 i = 0; i < tokenCounter; i += 1) {
            if (ownerOf(i) == owns_addr) {
                tokens.push(i);
            }
        }

        return tokens;
    }
}

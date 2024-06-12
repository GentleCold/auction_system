// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyNFT is ERC721 {
    uint256 private _tokenIdCounter;

    constructor() ERC721("MyNFT", "MNFT") {}

    function safeMint(address to) public {
        _safeMint(to, _tokenIdCounter);
        _tokenIdCounter += 1;
    }

    function getOwnedNFTs(
        address owner
    ) external view returns (uint256[] memory) {
        uint256 totalSupply = _tokenIdCounter;
        uint256[] memory ownedNFTs = new uint256[](totalSupply);
        uint256 ownedNFTsCount = 0;

        for (uint256 i = 0; i < totalSupply; i++) {
            if (_exists(i) && ownerOf(i) == owner) {
                ownedNFTs[ownedNFTsCount] = i;
                ownedNFTsCount++;
            }
        }

        uint256[] memory result = new uint256[](ownedNFTsCount);
        for (uint256 i = 0; i < ownedNFTsCount; i++) {
            result[i] = ownedNFTs[i];
        }

        return result;
    }

    function transferNFT(address from, address to, uint256 tokenId) public {
        require(ownerOf(tokenId) == from, "You don't own this NFT");
        _transfer(from, to, tokenId);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721 {
    uint private count;

    constructor() ERC721("NFT", "N") {}

    function safeMint(address to) public {
        _safeMint(to, count);
        count += 1;
    }

    function getAll(address owner) external view returns (uint[] memory) {
        uint[] memory all = new uint[](count);
        uint index = 0;

        for (uint i = 0; i < count; i++) {
            if (_exists(i) && ownerOf(i) == owner) {
                all[index] = i;
                index++;
            }
        }

        uint[] memory result = new uint[](index);
        for (uint i = 0; i < index; i++) {
            result[i] = all[i];
        }

        return result;
    }

    function transferNFT(address from, address to, uint id) public {
        require(ownerOf(id) == from, "You don't own this NFT");
        _transfer(from, to, id);
    }
}

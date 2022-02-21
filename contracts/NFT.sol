//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
 
 contract NFT is ERC721URIStorage {
     using Counters for Counters.Counter;
     Counters.Counter private _tokenIds;
     address marketplaceAddress;

    //We need address of the marketplace when deploying this contract to assign the full approval rights
    constructor(address _marketplaceAddress) ERC721("Metaverse Tokens","METT"){
        marketplaceAddress = _marketplaceAddress;
    }

    function createToken(string memory tokenURI) public returns (uint256){
        _tokenIds.increment();
        uint256 newTokenId = _tokenIds.current();
        _mint(msg.sender,newTokenId);
        _setTokenURI(newTokenId,tokenURI);
        setApprovalForAll(marketplaceAddress,true);
        return newTokenId;
    }
 }
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarketplace is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    
    address payable owner;
    uint256 listingPrice = 0.025 ether;

    constructor(){
        owner = payable( msg.sender);
        
    }

    struct MarketItem {
        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    mapping (uint256 => MarketItem) private idToMarketItem;

    event MarketItemCreated (
        uint itemId,
        address nftContract,
        uint256 tokenId,
        address  seller,
        address owner,
        uint256 price,
        bool sold
        );

    function createMarketItem(
        address nftContract,
        uint256 tokenId,
        uint price
    ) public payable nonReentrant {
        require(price > 0, "Price must be atleast 1 wei");
        require(msg.value >= listingPrice, "Transfer must be equal or greater than listing price");

        _itemIds.increment();
        uint itemId = _itemIds.current();
        
        idToMarketItem[itemId] = MarketItem({
            itemId: itemId,
            nftContract: nftContract,
            tokenId: tokenId,
            seller: payable(msg.sender),
            owner: payable(address(0)),
            price: price,
            sold: false
        });
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        emit MarketItemCreated({
            itemId: itemId,
            nftContract: nftContract,
            tokenId: tokenId,
            seller: payable(msg.sender),
            owner: payable(address(0)),
            price: price,
            sold: false
        });
    }

}
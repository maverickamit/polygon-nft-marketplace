//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarketplace is ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;
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
    //creates an item to be sold on the marketplace
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

    //buys an item on the marketplace
    function buyMarketItem(
        uint itemId
    ) public payable nonReentrant{
        //Here storage points to the same data location instead of creating a copy 
        MarketItem storage sellingItem = idToMarketItem[itemId];
        require(msg.value>= sellingItem.price,"Please submit the asking price in order to complete the purchase");
        sellingItem.seller.transfer(msg.value);
        IERC721(sellingItem.nftContract).transferFrom(address(this), msg.sender, sellingItem.tokenId);
        sellingItem.owner= payable(msg.sender);
        sellingItem.sold= true;
        _itemsSold.increment();
        payable(owner).transfer(listingPrice);
    }

    //Returns all unsold items currently at the marketplace
    function fetchMarketItems() public view returns (MarketItem[] memory){
        uint itemCount = _itemIds.current(); 
        uint unsoldItemCount = _itemIds.current() - _itemsSold.current();
        uint currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);

        for(uint i=0;i<itemCount;i++){
            
            if(idToMarketItem[i+1].owner == address(0)){ //owner is empty
                uint currentItemId = idToMarketItem[i+1].itemId;
                MarketItem memory currentItem = idToMarketItem[currentItemId];
                items[currentIndex]= currentItem;
                currentIndex++;
            }
        }
        return items;
    }
    
     //Returns all the items currently owned by the user
    function fetchMyNFTs() public view returns (MarketItem[] memory){
        uint itemCount = _itemIds.current(); 
        uint userItemOwnedCount = 0;
        uint currentIndex = 0;
        
        //calculates total number of items owned by the user
        for(uint i=0;i<itemCount; i++){
            if(idToMarketItem[i+1].owner == msg.sender){
               userItemOwnedCount++;
            }
        }

        MarketItem[] memory userItemsOwned = new MarketItem[](userItemOwnedCount);


        for(uint i=0; i<itemCount; i++){
            if(idToMarketItem[i+1].owner == msg.sender){
                uint currentItemId = idToMarketItem[i+1].itemId;
               userItemsOwned[currentIndex]= idToMarketItem[currentItemId];
               currentIndex++;
            }
        }
        return userItemsOwned;
    }

}
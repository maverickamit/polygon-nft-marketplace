let market;
let marketAddress;
let nft;
let nftContractAddress;
let accounts;

describe("NFT Market", () => {
  beforeEach(async () => {
    accounts = await ethers.getSigners();

    //Deploying NFT Marketplace
    const Market = await ethers.getContractFactory("NFTMarketplace");
    market = await Market.deploy();
    await market.deployed;
    marketAddress = market.address;

    //Deploying NFT contract
    const NFT = await ethers.getContractFactory("NFT");
    nft = await NFT.deploy(marketAddress);
    await nft.deployed;
    nftContractAddress = nft.address;
  });

  it("should create and execute market sales", async () => {
    let listingPrice = await market.getListingPrice();
    listingPrice = listingPrice.toString();
    const auctionPrice = ethers.utils.parseUnits("100", "ether");
    await nft.createToken("https://www.mytokenlocation.com");
    await nft.createToken("https://www.mytokenlocation2.com");

    await market.createMarketItem(nftContractAddress, 1, auctionPrice, {
      value: listingPrice,
    });
    await market.createMarketItem(nftContractAddress, 2, auctionPrice, {
      value: listingPrice,
    });

    const buyerAddress = accounts[1];
    await market
      .connect(buyerAddress)
      .buyMarketItem(1, { value: auctionPrice });

    let items = await market.fetchMarketItems();
    //returning required informatin in an easily readable form
    items = await Promise.all(
      items.map(async (i) => {
        const tokenUri = await nft.tokenURI(i.tokenId);
        let item = {
          price: ethers.utils.formatEther(i.price) + " eth",
          tokenId: i.tokenId.toString(),
          seller: i.seller,
          owner: i.owner,
          tokenUri,
        };
        return item;
      })
    );
    console.log("items", items);
  });
});

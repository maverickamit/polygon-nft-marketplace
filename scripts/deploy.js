async function main() {
  //Deploying NFT Marketplace
  const Market = await ethers.getContractFactory("NFTMarketplace");
  const market = await Market.deploy();
  console.log("Marketplace deployed to:", market.address);

  //Deploying NFT contract
  const NFT = await ethers.getContractFactory("NFT");
  const nft = await NFT.deploy(market.address);

  console.log("NFT deployed to:", nft.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

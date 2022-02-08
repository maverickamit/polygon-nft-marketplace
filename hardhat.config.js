import "@nomiclabs/hardhat-waffle";
import "dotenv/config";

export const networks = {
  hardhat: {
    chainId: 1337,
  },
  mumbai: {
    url: process.env.PROD_ALCHEMY_KEY,
    accounts: [process.env.PRIVATE_KEY],
  },
};
export const solidity = "0.8.4";

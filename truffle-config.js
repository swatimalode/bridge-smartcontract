const HDWalletProvider = require('@truffle/hdwallet-provider');
let privateKey = process.env.privateKey;
const IPFS = require("ipfs");
const ipfs = new IPFS();

module.exports = {
  networks: {
    networks: {
      development: {
        provider: IPFS,
        host: "localhost",
        port: 5001,
        gas: 5000000,
        gasPrice: 5e9,
        network_id: "*"
      }
    },
    georli_testnet: {
      provider: () => new HDWalletProvider(privateKey,process.env.ETHEREUM_RPC_URL),
      network_id: 5,
      skipDryRun: true
    },
    matic_testnet: {
      provider: () => new HDWalletProvider(privateKey, process.env.POLYGON_RPC_URL), // wss://speedy-nodes-nyc.moralis.io/af271fa0290d1b4fdf0a5b35/polygon/mumbai/ws
      network_id: 80001,
      skipDryRun: true
    }
  },
  compilers: {
    solc: {
      version: '0.8.16',
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        },
      evmVersion: "petersburg"  
      }
    }
  },
  api_keys:{
    polygonscan: process.env.API_MATIC_KEY,
    etherscan: process.env.API_ETH_KEY
  },
  plugins : [
    'truffle-plugin-verify'
  ]
}
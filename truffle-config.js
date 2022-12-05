const HDWalletProvider = require('@truffle/hdwallet-provider');
let privateKey = process.env.privateKey;

module.exports = {
  networks: {
    georli_testnet: {
      provider: () => new HDWalletProvider(privateKey,'https://eth-goerli.g.alchemy.com/v2/mP5M97XSz2PH983Y9DKuGTcKwytpzHuk'),
      network_id: 5,
      skipDryRun: true
    },
    matic_testnet: {
      provider: () => new HDWalletProvider(privateKey, 'https://polygon-mumbai.g.alchemy.com/v2/dpDZ_v-uHpEHo2ENTR-KT5SnVmJw3h4X'), // wss://speedy-nodes-nyc.moralis.io/af271fa0290d1b4fdf0a5b35/polygon/mumbai/ws
      network_id: 80001,
      skipDryRun: true
    }
  },
  compilers: {
    solc: {
      version: '0.8.7',
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
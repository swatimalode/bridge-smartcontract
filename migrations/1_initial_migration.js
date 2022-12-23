const { upgradeProxy, deployProxy } = require('@openzeppelin/truffle-upgrades');

// // ############# 1st deployment  ####################


// const myContract = artifacts.require("BridgeEthereumV1");

// module.exports = async function (deployer) {
//   const instance = await deployProxy(myContract, { deployer });
//   console.log('Deployed', instance.address);
// };

// ############# upgrade deployment  ####################

// const oldContract = artifacts.require('BridgeEthereumV1');
// const newContract = artifacts.require('BridgeEthereumV1');

// module.exports = async function (deployer) {
//   const existing = await oldContract.deployed();
//   const instance = await upgradeProxy(existing.address, newContract, { deployer});
//   console.log("Upgraded", instance.address);
// };


//// Polygon

const myContract = artifacts.require("BridgePolygonV1");

module.exports = async function (deployer) {
  const instance = await deployProxy(myContract, { deployer });
  console.log('Deployed', instance.address);
};

// ############# upgrade deployment  ####################

// const oldContract = artifacts.require('BridgePolygonV1');
// const newContract = artifacts.require('BridgePolygonV2');

// module.exports = async function (deployer) {
//   const existing = await oldContract.deployed();
//   const instance = await upgradeProxy(existing.address, newContract, { deployer});
//   console.log("Upgraded", instance.address);
// };
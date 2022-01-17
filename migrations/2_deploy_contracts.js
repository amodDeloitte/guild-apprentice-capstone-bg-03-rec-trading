var GridEnergyPool = artifacts.require("./contracts/GridEnergyPool.sol");

module.exports = function(deployer) {
  deployer.deploy(GridEnergyPool);
};
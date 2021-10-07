import { run, ethers, network } from "hardhat";

async function main() {
  await run("compile");

  const [deployer] = await ethers.getSigners();

  if (deployer) {
    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());
  }

  const Contract = await ethers.getContractFactory("ExtendedAsciiPlot");
  const contract = await Contract.deploy(
    // OpenSea proxy registry addresses
    network.name === "rinkeby"
      ? "0xf57b2c51ded3a29e6891aba85459d600256cf317"
      : network.name === "polygon"
      ? "0x58807baD0B376efc12F5AD86aAc70E78ed67deaE"
      : "0xa5409ec958c83c3f309868babaca7c86dcb077c1"
  );

  console.log("Contract address:", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

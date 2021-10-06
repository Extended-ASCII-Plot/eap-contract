import { run, ethers } from "hardhat";

async function main() {
  await run("compile");

  const [deployer] = await ethers.getSigners();

  if (deployer) {
    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());
  }

  const Contract = await ethers.getContractFactory("ExtendedAsciiPlot");
  const contract = await Contract.deploy(
    // OpenSea proxy registry addresses for mainnet.
    "0xa5409ec958c83c3f309868babaca7c86dcb077c1"
  );

  console.log("Contract address:", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

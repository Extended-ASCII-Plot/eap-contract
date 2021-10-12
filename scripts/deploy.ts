import { run, ethers, network } from "hardhat";

const networks = ["mainnet", "rinkeby", "polygon", "mumbai"];

async function main() {
  if (!networks.includes(network.name)) {
    console.error(network.name, "not supported.");
    return;
  }

  await run("compile");

  const [deployer] = await ethers.getSigners();

  if (deployer) {
    console.log("Deploying contracts with the account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());
  }

  const Contract = await ethers.getContractFactory(
    network.name === "polygon" || network.name === "mumbai"
      ? "ExtendedAsciiPlotPloygon"
      : "ExtendedAsciiPlot"
  );
  const contract = await Contract.deploy(
    // OpenSea proxy registry addresses
    {
      mainnet: "0xa5409ec958c83c3f309868babaca7c86dcb077c1",
      rinkeby: "0xf57b2c51ded3a29e6891aba85459d600256cf317",
      polygon: "0x58807baD0B376efc12F5AD86aAc70E78ed67deaE",
      mumbai: "",
    }[network.name]
  );

  console.log("Contract address:", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

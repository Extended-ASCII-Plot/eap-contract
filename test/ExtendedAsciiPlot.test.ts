import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";

import { $ExtendedAsciiPlot } from "../typechain-types/$ExtendedAsciiPlot";
import { Data } from "../typechain-types/Data";

describe("ExtendedAsciiPlot", function () {
  let signers: SignerWithAddress[];
  let contract: $ExtendedAsciiPlot;

  this.beforeAll(async () => {
    const Library = await ethers.getContractFactory("Data");
    const library = (await Library.deploy()) as Data;
    const Contract = await ethers.getContractFactory("$ExtendedAsciiPlot", {
      libraries: { Data: library.address },
    });
    contract = (await Contract.deploy()) as $ExtendedAsciiPlot;
    await contract.deployed();
    signers = await ethers.getSigners();
  });

  it("char", async () => {
    expect(await contract.$char(0, 0, 0)).to.eq(
      "<rect x='0' y='0' width='8' height='8' fill='rgb(0,0,0)'></rect>"
    );
  });
});

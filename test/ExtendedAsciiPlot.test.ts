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
    expect(await contract.$char(0x1234, 0, 0)).to.eq(
      "<rect x='0' y='0' width='8' height='8' fill='rgb(171,82,54)' /><rect x='7' y='6' fill='rgb(0,135,81)' width='1' height='1' /><rect x='7' y='4' fill='rgb(0,135,81)' width='1' height='1' /><rect x='7' y='2' fill='rgb(0,135,81)' width='1' height='1' /><rect x='7' y='0' fill='rgb(0,135,81)' width='1' height='1' /><rect x='6' y='6' fill='rgb(0,135,81)' width='1' height='1' /><rect x='6' y='4' fill='rgb(0,135,81)' width='1' height='1' /><rect x='6' y='2' fill='rgb(0,135,81)' width='1' height='1' /><rect x='6' y='0' fill='rgb(0,135,81)' width='1' height='1' /><rect x='5' y='6' fill='rgb(0,135,81)' width='1' height='1' /><rect x='5' y='4' fill='rgb(0,135,81)' width='1' height='1' /><rect x='5' y='2' fill='rgb(0,135,81)' width='1' height='1' /><rect x='5' y='0' fill='rgb(0,135,81)' width='1' height='1' /><rect x='4' y='6' fill='rgb(0,135,81)' width='1' height='1' /><rect x='4' y='4' fill='rgb(0,135,81)' width='1' height='1' /><rect x='4' y='2' fill='rgb(0,135,81)' width='1' height='1' /><rect x='4' y='0' fill='rgb(0,135,81)' width='1' height='1' />"
    );
  });
});

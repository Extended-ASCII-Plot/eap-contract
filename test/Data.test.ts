import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";

import { $Data } from "../typechain-types/$Data";

describe("Data", function () {
  let signers: SignerWithAddress[];
  let library: $Data;

  this.beforeAll(async () => {
    const Library = await ethers.getContractFactory("$Data");
    library = (await Library.deploy()) as $Data;
    await library.deployed();
    signers = await ethers.getSigners();
  });

  it("getFontAt", async () => {
    expect(await library.$getFontAt(0)).to.eq(
      ethers.BigNumber.from("0x8142241818244281")
    );
    expect(await library.$getFontAt(0xff)).to.eq(
      ethers.BigNumber.from("0xFFFFC0C0C0C0C0C0")
    );
  });

  it("getColorAt", async () => {
    expect(await library.$getColorAt(0)).to.deep.eq([0, 0, 0]);
    expect(await library.$getColorAt(15)).to.deep.eq([0xff, 0xcc, 0xaa]);
  });
});

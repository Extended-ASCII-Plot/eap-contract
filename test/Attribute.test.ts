import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";

import { $Attribute } from "../typechain-types/$Attribute";

describe("Attribute", function () {
  let signers: SignerWithAddress[];
  let library: $Attribute;

  this.beforeAll(async () => {
    const Library = await ethers.getContractFactory("$Attribute");
    library = (await Library.deploy()) as $Attribute;
    await library.deployed();
    signers = await ethers.getSigners();
  });

  it("countSetBits", async () => {
    expect(await library.$countSetBits(0b0)).to.eq(ethers.BigNumber.from(0));
    expect(await library.$countSetBits(0b111100001001)).to.eq(
      ethers.BigNumber.from(6)
    );
    expect(
      await library.$countSetBits(
        ethers.BigNumber.from("0xffffffffffffffffffffffffffffffff")
      )
    ).to.eq(ethers.BigNumber.from(128));
  });
});

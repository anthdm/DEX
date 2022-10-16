const { expect } = require("chai");

describe("Dex", () => {
  it("should work", async () => {
    const [owner, otherAccount] = await ethers.getSigners();
    const Dex = await ethers.getContractFactory("Dex");
    const dex = await Dex.deploy();

    const UsdcToken = await ethers.getContractFactory("Usdc");
    const usdcToken = await UsdcToken.deploy(ethers.utils.parseUnits("100", 8));

    const RandomToken = await ethers.getContractFactory("RandomToken");
    const randomToken = await RandomToken.deploy(
      ethers.utils.parseUnits("100", 8)
    );

    // RANDUSDC
    await dex.registerTradingPair(randomToken.address, usdcToken.address, 1);

    const depositAmount = ethers.utils.parseUnits("1", 8);
    await randomToken.approve(dex.address, depositAmount);
    await dex.deposit(randomToken.address, depositAmount);

    expect(await dex.poolTokenSupplies(randomToken.address)).to.equal(
      depositAmount
    );

    await usdcToken.approve(dex.address, depositAmount);
    await dex.deposit(usdcToken.address, depositAmount);

    expect(await dex.poolTokenSupplies(usdcToken.address)).to.equal(
      depositAmount
    );

    const buyAmount = ethers.utils.parseUnits("0.5", 8);
    const tradingPair = "RANDUSDC";
    await usdcToken.approve(dex.address, depositAmount);
    await dex.buy(tradingPair, buyAmount);

    console.log(await dex.poolTokenSupplies(usdcToken.address));
    console.log(await dex.poolTokenSupplies(randomToken.address));

    // expect(await dex.poolTokenSupplies(usdcToken.address)).to.equal(
    //   depositAmount + buyAmount
    // );
  });
});

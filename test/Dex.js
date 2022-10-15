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

    await dex.registerTradingPair(usdcToken.address, randomToken.address, 1);

    const amount_ = ethers.utils.parseUnits("1", 8);
    await randomToken.approve(dex.address, amount_);
    await dex.deposit(randomToken.address, amount_);

    const amount = ethers.utils.parseUnits("1", 8);
    await usdcToken.approve(dex.address, amount);
    await randomToken.approve(owner.address, amount);

    await dex.buy("USDCRAND", amount);

    console.log(await randomToken.balanceOf(dex.address));
  });
});

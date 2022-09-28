import { loadFixture } from '@nomicfoundation/hardhat-network-helpers'
import { expect } from 'chai'
import { ethers } from 'hardhat'

describe('MockERC20', function () {
  async function deployERC20() {
    const [owner, otherAccount] = await ethers.getSigners()

    const Erc20 = await ethers.getContractFactory('MockERC20')
    const erc20 = await Erc20.deploy()

    return { erc20, owner, otherAccount }
  }

  describe('Deployment', function () {
    it('Should check deployment by confirming token symbol', async function () {
      const { erc20 } = await loadFixture(deployERC20)

      expect(await erc20.symbol()).to.equal("MERC20")
    })
  })

  describe('Mint', function () {
    it('Should mint 100 MERC20 tokens to the owner', async function () {
      const { erc20, owner } = await loadFixture(deployERC20)

      const tx = await erc20.mint(ethers.utils.parseUnits('100', 18))
      await tx.wait()

      expect(await erc20.balanceOf(owner.address)).to.equal(
        ethers.utils.parseUnits('100', 18)
      )
    })

    it('Should mint 50 MERC20 tokens to the otherAccount', async function () {
      const { erc20, otherAccount } = await loadFixture(deployERC20)

      const tx = await erc20
        .connect(otherAccount)
        .mint(ethers.utils.parseUnits('50', 18))
      await tx.wait()

      expect(await erc20.balanceOf(otherAccount.address)).to.equal(
        ethers.utils.parseUnits('50', 18)
      )
    })
  })
})

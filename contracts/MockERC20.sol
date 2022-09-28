// SPDX-License-Identifier: None
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
  constructor() ERC20("Mock ERC20", "MERC20") {}

  function mint(uint256 amount) external {
    _mint(_msgSender(), amount);
  }
}
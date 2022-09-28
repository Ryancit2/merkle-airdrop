/// SPDX-License-Identifier: None
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract MerkleDrop is Ownable {
  IERC20 public baseToken;
  uint256 public unitRelease;
  bytes32 public merkleRoot;
  mapping(address => bool) public claimed;

  constructor(IERC20 _baseToken, uint256 _unitRelease, bytes32 _merkleRoot) {
    baseToken = _baseToken;
    unitRelease = _unitRelease;
    merkleRoot = _merkleRoot;
  }

  function updateRoot(bytes32 _newRoot) external onlyOwner {
    merkleRoot = _newRoot;
  }

  function updateUnitRelease(uint256 _newAmount) external onlyOwner {
    unitRelease = _newAmount;
  }

  function claim(bytes32[] memory _merkleProof) external {
    require(!claimed[_msgSender()], "MerkleDrop: Already claimed");
    require(MerkleProof.verify(_merkleProof, merkleRoot, keccak256(abi.encodePacked(_msgSender()))), "MerkleDrop: Not whitelisted");

    claimed[_msgSender()] = true;
    baseToken.transferFrom(owner(), _msgSender(), unitRelease);
  }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vault {
    IERC20 public immutable token;

    mapping(address => uint256) public balances;

    constructor(address _tokenAdress) {
        token = IERC20 (_tokenAdress);
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(
            token.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        bool success = token.transferFrom(msg.sender, address(this), amount);
        require(success, "Transfer failed");
        balances[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        bool success = token.transfer(msg.sender, amount);
        require(success, "Transfer failed");
    }
}
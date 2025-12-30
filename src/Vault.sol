// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol"; // Importing IERC20 interface from OpenZeppelin


// Vault contract to handle deposits and withdrawals of an ERC20 token
contract Vault {
    IERC20 public immutable token;

    mapping(address => uint256) public balances;

    constructor(address _tokenAdress) {
        token = IERC20 (_tokenAdress);
    }
    // Deposit function to allow users to deposit tokens into the vault
    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(
            token.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );

        balances[msg.sender] += amount;
    }

    // Withdraw function to allow users to withdraw their tokens from the vault
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        bool success = token.transfer(msg.sender, amount);
        require(success, "Transfer failed");
    }
}
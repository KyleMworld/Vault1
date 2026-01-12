// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


contract SkywalkerToken {
    string public name = "Skywalker Token";
    string public symbol = "SKY";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor (uint256 _initialSupply) {
        totalSupply = _initialSupply *10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address recipient, uint256 amount) public returns (bool success) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool success) {
        allowance[msg.sender][spender] = amount; 
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool success) {
        require(balanceOf[sender] >= amount, "Insufficient balance");
        require(allowance[sender][msg.sender] >= amount, "Allowance exceeded");
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        allowance[sender][msg.sender] -= amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}


// Vault contract to handle deposits and withdrawals of an ERC20 token
contract Vault {
    IERC20 public immutable token;

    mapping(address => uint256) public balances;

    constructor(address _tokenAddress) {
        token = IERC20 (_tokenAddress);
    }
    // Deposit function to allow users to deposit tokens into the vault
    // Updated for CEI compliance- Checks(requir amount), Effects(update balance), Interactions(transfer tokens)
    function deposit(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        balances[msg.sender] += amount;
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
    }

    // Withdraw function to allow users to withdraw their tokens from the vault
    function withdraw(uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        bool success = token.transfer(msg.sender, amount);
        require(success, "Transfer failed");
    }
}
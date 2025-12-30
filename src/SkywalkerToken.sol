// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; 

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol"; // Importing ERC20 from OpenZeppelin

// SkywalkerToken contract inheriting from OpenZeppelin's ERC20 implementation
contract SkywalkerToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Skywalker", "SKYW") {
        _mint(msg.sender, initialSupply);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Vault} from "../src/Vault.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract VaderERC20 is ERC20 {
    constructor() ERC20("Vader", "VADER") {}
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}

contract VaultTest is Test {
    Vault public vault;
    VaderERC20 public vaderToken;
    address public user = makeAddr("user");
    uint256 public initialUserBalance = 100 ether;

    function setUp() public {
        vaderToken = new VaderERC20();
        vault = new Vault(address(vaderToken));
        vaderToken.mint(user, initialUserBalance);
    }

    function testDeposit() public {
        uint256 depositAmount = 10 ether;

        vm.startPrank(user);
        vaderToken.approve(address(vault), depositAmount);
        vault.deposit(depositAmount);
        vm.stopPrank();

        // FIX: Declare vaultBalance before using it
        uint256 vaultBalance = vault.balances(user);
        assertEq(vaultBalance, depositAmount);
        assertEq(vaderToken.balanceOf(address(vault)), depositAmount);
    }

    function testWithdraw() public {
        // FIX: Declare these variables inside this function scope
        uint256 depositAmount = 10 ether;
        uint256 withdrawAmount = 5 ether;

        vm.startPrank(user);
        vaderToken.approve(address(vault), depositAmount);
        vault.deposit(depositAmount);

        // Action: Withdraw
        vault.withdraw(withdrawAmount);
        vm.stopPrank();

        // Check balances: 10 deposited - 5 withdrawn = 5 remaining
        assertEq(vault.balances(user), 5 ether);
        // Total should be (Initial 100 - 10 deposited + 5 withdrawn) = 95
        assertEq(vaderToken.balanceOf(user), initialUserBalance - 5 ether);
    }

    function test_RevertWhen_InsufficientBalance() public {
        vm.prank(user);
        vm.expectRevert("Insufficient balance");
        vault.withdraw(1 ether);
    }

    function testFuzz_Deposit(uint256 amount) public {
        vm.assume(amount > 0 && amount <= initialUserBalance);

        vm.startPrank(user);
        vaderToken.approve(address(vault), amount);
        vault.deposit(amount);
        vm.stopPrank();

        assertEq(vault.balances(user), amount);
    }
}
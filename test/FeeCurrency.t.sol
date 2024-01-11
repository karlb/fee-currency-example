pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {FeeCurrency} from "../src/FeeCurrency.sol";

contract FeeCurrencyTest is Test {
    FeeCurrency public fc;
    address user = vm.addr(1);
    address baseFeeRecipient = vm.addr(2);
    address tipRecipient = vm.addr(3);

    function setUp() public {
        fc = new FeeCurrency(200);
        fc.transfer(user, 100);
    }

    function test_debit() public {
        vm.prank(address(0));
        fc.debitGasFees(user, 100);

        assertEq(fc.balanceOf(user), 0);
        assertEq(fc.totalSupply(), 100);
    }

    function test_creditArray() public {
        address[] memory recipients = new address[](3);
        uint256[] memory amounts = new uint256[](3);

        recipients[0] = user;
        recipients[1] = baseFeeRecipient;
        recipients[2] = tipRecipient;

        amounts[0] = 20;
        amounts[1] = 70;
        amounts[2] = 10;

        vm.prank(address(0));
        fc.creditGasFees(recipients, amounts);

        assertEq(fc.balanceOf(user), 100 + 20);
        assertEq(fc.balanceOf(baseFeeRecipient), 70);
        assertEq(fc.balanceOf(tipRecipient), 10);
        assertEq(fc.totalSupply(), 300);
    }

    function test_creditBackwardsCompatible() public {
        vm.prank(address(0));
        fc.creditGasFees(user, tipRecipient, address(0), baseFeeRecipient, 20, 10, 0, 70);

        assertEq(fc.balanceOf(user), 100 + 20);
        assertEq(fc.balanceOf(baseFeeRecipient), 70);
        assertEq(fc.balanceOf(tipRecipient), 10);
        assertEq(fc.totalSupply(), 300);
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import {W2Ploan} from "../src/W2Ploan.sol";

contract  W2PloanTest is Test {
    W2Ploan public w2pLoan;

    address lender1 = address(0xa1);
    address lender2 = address(0xa2);
    address borrower = address(0xb2);

    function setUp() public {
        w2pLoan = new W2Ploan();
        vm.deal(lender1, 10 ether);
        vm.deal(lender2, 10 ether);
        vm.deal(borrower, 10 ether);
    }

    function testDeposit() public {
        vm.prank(lender1);
        w2pLoan.deposit{value: 1 ether}();
        vm.prank(lender2);
        w2pLoan.deposit{value: 2 ether}();
        assertEq(address(w2pLoan).balance, 3 ether);
    }

    function testWithdraw() public {
        vm.prank(lender1);
        w2pLoan.deposit{value: 1 ether}();
        vm.prank(lender1);
        w2pLoan.withdraw(0.5 ether);
        assertEq(address(w2pLoan).balance, 0.5 ether);
    }

    function testBorrow() public {
        vm.prank(lender1);
        w2pLoan.deposit{value: 2 ether}();
        vm.prank(lender2);
        w2pLoan.deposit{value: 2 ether}();
        vm.prank(borrower);
        w2pLoan.borrow(3 ether, payable(borrower));
        assertEq(address(w2pLoan).balance, 1 ether);
    }

    function testRepay() public {
        vm.prank(lender1);
        w2pLoan.deposit{value: 2 ether}();
        vm.prank(lender2);
        w2pLoan.deposit{value: 2 ether}();
        vm.prank(borrower);
        w2pLoan.borrow(3 ether, payable(borrower));
        vm.prank(borrower);
        w2pLoan.repay{value: 3.15 ether}(0); // Assuming 5% interest
        assertEq(address(w2pLoan).balance, 4.15 ether);
    }
}
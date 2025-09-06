// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "forge-std/console.sol";
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
        console.log("lender1 balance:", lender1.balance);
        console.log("lender2 balance:", lender2.balance);
        console.log("borrower balance:", borrower.balance);
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
        console.log("Contract balance after deposit:", address(w2pLoan).balance);
        console.log("lender1 balance after deposit:", lender1.balance);
        console.log("lender1 lenderDeposits:", w2pLoan.lenderDeposits(lender1));
        vm.prank(lender1);
        w2pLoan.withdraw(0.5 ether);
        assertEq(lender1.balance, 9.5 ether);
        assertEq(address(w2pLoan).balance, 0.5 ether);
    }

    function testBorrow() public {
        vm.prank(lender1);
        w2pLoan.deposit{value: 2 ether}();
        vm.prank(lender2);
        w2pLoan.deposit{value: 2 ether}();
        console.log("Contract balance before borrow:", address(w2pLoan).balance);
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
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {OurToken} from "src/OurToken.sol";
import {DeployOurToken} from "script/DeployOurToken.s.sol";

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address tim = makeAddr("Tim");
    address hazel = makeAddr("hazel");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(tim, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(tim));
    }

    function testAllowance() public {
        uint256 initialAllowance = 1000;

        vm.prank(tim);
        ourToken.approve(hazel, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(hazel);
        ourToken.transferFrom(tim, hazel, transferAmount);

        assertEq(ourToken.balanceOf(hazel), transferAmount);
        assertEq(ourToken.balanceOf(tim), STARTING_BALANCE - transferAmount);
    }
}

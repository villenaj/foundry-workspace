// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.31;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() public {
        // 0x72AFAECF99C9d9C8215fF44C77B94B99C28741e8
        // fundMe = new FundMe(0x72AFAECF99C9d9C8215fF44C77B94B99C28741e8);
        DeployFundMe deployer = new DeployFundMe();
        fundMe = deployer.run();
    }

    function testMinimumUsd() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.I_OWNER(), msg.sender);
    }

    function testPriceFeedVersion() public view {
        uint256 version = fundMe.getVersion();
        console.log(version);

        assertEq(version, 4);
    }
}

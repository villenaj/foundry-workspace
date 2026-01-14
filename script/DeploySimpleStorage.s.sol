// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.31;

import "forge-std/Script.sol";
import "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    function run() public returns (SimpleStorage) {
        vm.startBroadcast();
        SimpleStorage simpleStorage = new SimpleStorage();
        vm.stopBroadcast();

        return simpleStorage;
    }
}

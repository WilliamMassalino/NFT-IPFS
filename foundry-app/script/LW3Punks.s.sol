// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {LW3Punks} from "../src/LW3Punks.sol";

contract LW3PunksScript is Script {
    LW3Punks public lw3punks;

    function setUp() public {}

    function run() public {
        // Read the CID_METADATA environment variable
        string memory cid = vm.envString("CID_METADATA");

        vm.startBroadcast();

        // Use the environment variable in the contract deployment
        lw3punks = new LW3Punks(cid);

        vm.stopBroadcast();
    }
}

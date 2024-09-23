// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "forge-std/StdUtils.sol";
import "../script/LW3Punks.s.sol"; // Import the script file

contract LW3PunksScriptTest is Test {
    LW3PunksScript lw3PunksScript;
    LW3Punks lw3Punks;

    string baseCID = "ipfs://baseCID/";

    // Set up the test environment before each test
    function setUp() public {
        lw3PunksScript = new LW3PunksScript();
    }

    // Test the deployment of the LW3Punks contract using the script
    function testDeployment() public {
        // Set the environment variable that the script relies on
        vm.setEnv("CID_METADATA", baseCID);

        // Run the script to deploy the LW3Punks contract
        lw3PunksScript.run();

        // Retrieve the deployed contract instance
        lw3Punks = lw3PunksScript.lw3punks();

        // Simulate minting a token to generate a tokenURI
        address user = address(2);
        vm.deal(user, 1 ether); // Fund the user with some Ether
        vm.prank(user); // Simulate a transaction from the user
        lw3Punks.mint{value: 0.01 ether}();

        // Check that the tokenURI is as expected
        string memory expectedTokenURI = string(abi.encodePacked(baseCID, "1.json"));
        assertEq(lw3Punks.tokenURI(1), expectedTokenURI);
    }
}

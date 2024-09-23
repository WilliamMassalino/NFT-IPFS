// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../src/LW3Punks.sol";

contract LW3PunksTest is Test {
    LW3Punks lw3Punks;
    address owner = address(1); // Owner of the contract
    address user = address(2);  // A non-owner user

    // Set up initial state before running each test
    function setUp() public {
        vm.startPrank(owner);
        lw3Punks = new LW3Punks("ipfs://baseURI/");
        vm.stopPrank();
    }

    // Test successful minting
    function testMintSuccess() public {
        vm.deal(user, 1 ether); // Give the user some Ether to pay for minting

        // Prank as user to simulate them sending the mint transaction
        vm.startPrank(user);
        lw3Punks.mint{value: 0.01 ether}();
        vm.stopPrank();

        // Check the state changes
        assertEq(lw3Punks.tokenIds(), 1);
        assertEq(lw3Punks.ownerOf(1), user); // The first minted token should belong to the user
    }

    // Test mint with insufficient funds
    function testMintInsufficientFunds() public {
        vm.deal(user, 1 ether); // Give user Ether

        vm.startPrank(user);
        vm.expectRevert("Ether sent is not correct");
        lw3Punks.mint{value: 0.005 ether}(); // Sending less than the price
        vm.stopPrank();
    }

    // Test minting when the contract is paused
    function testMintWhenPaused() public {
        vm.prank(owner);
        lw3Punks.setPaused(true);

        vm.deal(user, 1 ether);

        vm.startPrank(user);
        vm.expectRevert("Contract currently paused");
        lw3Punks.mint{value: 0.01 ether}();
        vm.stopPrank();
    }

    // Test that only the owner can pause the contract
    function testOnlyOwnerCanPause() public {
        vm.startPrank(user); // Non-owner user
        vm.expectRevert();
        lw3Punks.setPaused(true);
        vm.stopPrank();

        vm.startPrank(owner);
        lw3Punks.setPaused(true); // Owner can pause the contract
        assertTrue(lw3Punks._paused());
        vm.stopPrank();
    }

    // Test that the contract cannot mint more than maxTokenIds
    function testMintMaxSupplyReached() public {
        vm.deal(user, 1 ether);

        vm.startPrank(user);
        for (uint256 i = 0; i < lw3Punks.maxTokenIds(); i++) {
            lw3Punks.mint{value: 0.01 ether}(); // Mint maxTokenIds NFTs
        }
        vm.expectRevert("Exceed maximum LW3Punks supply");
        lw3Punks.mint{value: 0.01 ether}(); // Exceed the supply
        vm.stopPrank();
    }

    // Test if the owner can withdraw the funds
    function testWithdraw() public {
        vm.deal(user, 1 ether);

        // User mints a token
        vm.startPrank(user);
        lw3Punks.mint{value: 0.01 ether}();
        vm.stopPrank();

        // Check contract balance before withdrawal
        assertEq(address(lw3Punks).balance, 0.01 ether);

        // Withdraw by owner
        vm.prank(owner);
        lw3Punks.withdraw();

        // Ensure contract balance is 0 after withdrawal
        assertEq(address(lw3Punks).balance, 0 ether);

        // Ensure owner's balance is updated correctly (including original balance)
        assertEq(owner.balance, 0.01 ether);
    }

    // Test non-owner cannot withdraw the funds
    function testNonOwnerCannotWithdraw() public {
        vm.deal(user, 1 ether);

        // User mints a token
        vm.startPrank(user);
        lw3Punks.mint{value: 0.01 ether}();
        vm.stopPrank();

        // Non-owner trying to withdraw should fail
        vm.prank(user);
        vm.expectRevert();
        lw3Punks.withdraw();
    }

    // Test token URI generation for a valid token
    function testTokenURI() public {
        vm.deal(user, 1 ether);

        vm.startPrank(user);
        lw3Punks.mint{value: 0.01 ether}();
        vm.stopPrank();

        // Verify token URI
        assertEq(lw3Punks.tokenURI(1), "ipfs://baseURI/1.json");
    }

    // Test tokenURI reverts for non-existent token
    function testTokenURINonExistent() public {
        vm.expectRevert("ERC721Metadata: URI query for nonexistent token");
        lw3Punks.tokenURI(1); // No token minted, should revert
    }
}

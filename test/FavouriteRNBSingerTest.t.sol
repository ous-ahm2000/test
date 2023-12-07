pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/FavouriteRNBSinger.sol";
contract FavouriteRNBSingerTest is Test {
    FavouriteRNBSinger public favoriteSingerContract;

    function setUp() public {
        string[] memory initialSingers = new string[](3);
        initialSingers[0] = "Michael Jackson";
        initialSingers[1] = "Usher";
        initialSingers[2] = "Chris Brown";

        favoriteSingerContract = new FavouriteRNBSinger(initialSingers);
    }

    function testVote() public {
        favoriteSingerContract.vote("Michael Jackson");
        favoriteSingerContract.vote("Michael Jackson");
        favoriteSingerContract.vote("Usher");

        assertEq(favoriteSingerContract.getVotes("Michael Jackson"), 2);
        assertEq(favoriteSingerContract.getVotes("Usher"), 1);
        assertEq(favoriteSingerContract.getLeadingSinger(), "Michael Jackson");
    }

    function testAddSinger() public {
        // Only owner can add a new singer
        try favoriteSingerContract.addSinger("Justin Timberlake") {
            // Check if the new singer is added successfully
            assertTrue(favoriteSingerContract.isValidSinger("Justin Timberlake"));
        } catch Error(string memory /*reason*/) {
            // Handle the error (if any)
            assertTrue(false, "Adding singer failed");
        }
    }

    function testAddExistingSinger() public {
        // Try adding an existing singer, should fail
        try favoriteSingerContract.addSinger("Michael Jackson") {
            // If it doesn't fail, it's an error
            assertTrue(false, "Adding existing singer should fail");
        } catch Error(string memory /*reason*/) {
            // Handle the expected error
            assertTrue(true, "Expected error for adding existing singer");
        }
    }

    // Additional test cases for other functionalities...
}
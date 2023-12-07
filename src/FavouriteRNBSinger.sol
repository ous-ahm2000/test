pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract FavouriteRNBSinger {
    // Array of singer names
    string[] public singers;

    // Mapping to store votes for each singer
    mapping(string => uint256) public votes;

    // Address of the contract owner
    address public owner;

    // Events
    event Vote(string singer, address voter);

    constructor(string[] memory _singers) {
        singers = _singers;
        owner = msg.sender;
    }

    // Function to vote for a singer
    function vote(string memory singer) public {
        require(isValidSinger(singer), "Invalid singer name!");

        votes[singer]++;
        emit Vote(singer, msg.sender);
    }

    // Function to check if a singer name is valid
    function isValidSinger(string memory singer) public view returns (bool) {
        for (uint256 i = 0; i < singers.length; i++) {
            if (keccak256(abi.encodePacked(singers[i])) == keccak256(abi.encodePacked(singer))) {
                return true;
            }
        }
        return false;
    }

    // Function to get the total votes for a singer
    function getVotes(string memory singer) public view returns (uint256) {
        return votes[singer];
    }

    // Function to get the leading singer
    function getLeadingSinger() public view returns (string memory) {
        string memory leadingSinger = "";
        uint256 highestVotes = 0;

        for (uint256 i = 0; i < singers.length; i++) {
            if (votes[singers[i]] > highestVotes) {
                leadingSinger = singers[i];
                highestVotes = votes[singers[i]];
            }
        }

        return leadingSinger;
    }

    // Restrict function calls only to owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function!");
        _; // Continue execution if the condition is met
    }

    // Function to add new singers only by owner
    function addSinger(string memory singer) public onlyOwner {
        require(!isValidSinger(singer), "Singer already exists!");
        singers.push(singer);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.7.0;

contract Election {
    address public host;
    mapping (address=>bytes32) public votes;
    mapping (bytes32=>uint) public voteTally;
    mapping (bytes32=>bool) public candidates;
    mapping (address=>bool) public admins;

    constructor() public {
      host = msg.sender;
    }

    function vote(bytes32 name) public returns(bool success){
      if (!candidates[name]) {
        return false;
      }
      if (!candidates[votes[msg.sender]]) {
        voteTally[votes[msg.sender]]--;
      }
      votes[msg.sender] = name;
      voteTally[name]++;
      return true;
    }

    function addAdmin(address a) public {
      require(host == msg.sender);
      admins[a] = true;
    }

    function addCandidate(bytes32 candidate) public {
      require(host == msg.sender || admins[msg.sender]);
      candidates[candidate] = true;
    }


    /*
    function checkVoteByVoter(address voter) public returns (bytes32 candidate){
      require(host == msg.sender || admins[msg.sender]);
      if (!candidates[votes[voter]]) {
        return bytes32("none");
      } else {
        return votes[voter];
      }
    }
    function checkTally(bytes32 candidate) public returns (uint tally){
      require(candidates[candidate]);
      return voteTally[candidate];
    }
    */
}

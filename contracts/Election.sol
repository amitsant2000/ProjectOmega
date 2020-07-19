// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.7.0;

contract Election {
    address private host;
    uint private nextID;
    mapping (address=>bytes32) public votes;
    mapping (bytes32=>uint) public voteTally;
    mapping (bytes32=>bool) public candidates;
    mapping (address=>bool) private admins;
    mapping (uint=>bytes32) public candidateIDs;

    constructor() public {
      host = msg.sender;
      nextID = 0;
    }

    //https://ethereum.stackexchange.com/a/4177
    function toBytes(uint x) public pure returns (bytes32) {
        bytes32 b = 0;
        assembly { mstore(add(b, 32), x) }
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
      candidateIDs[nextID] = candidate;
      nextID++;
    }
    function getCandidateNextID() public view returns(bytes32) {
      return toBytes(nextID);
    }

    function checkVoteByVoter(address voter) public view returns (bytes32 candidate){
      require(host == msg.sender || admins[msg.sender] || msg.sender == voter);
      if (!candidates[votes[voter]]) {
        return bytes32("none");
      } else {
        return votes[voter];
      }
    }

    function checkTally(bytes32 candidate) public view returns (bytes32){
      require(candidates[candidate]);
      return toBytes(voteTally[candidate]);
    }

    function getCandidateByID(uint id) public view returns (bytes32) {
      return candidateIDs[id];
    }
}

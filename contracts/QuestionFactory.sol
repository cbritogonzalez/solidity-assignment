// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./2_Owner.sol";

contract QuestionFactory is Owner {

    event NewQuestion(string body);
    event QuestionResults(string body, uint positiveResults, uint negativeResults);


    struct Voter {
        uint weight; // weight is accumulated by delegation =0 cant vote, =1 can vote
        bool voted;  // if true, that person already voted
        uint vote;   // index of the voted proposal, 0=false,1=true
        uint viewResults; // weight assigned to see if the voter can see the results =0 cant, =1 can
    }

    struct Question {
        // If you can limit the length to a certain number of bytes, 
        // always use one of bytes1 to bytes32 because they are much cheaper
        string body;   // short name (up to 32 bytes)
        uint positiveVoteCount; // number of accumulated votes +
        uint negativeVoteCount; // number of accumulated votes -
        bool active; // if the question is still active
    }

    Question[] public questions;

    address public director;

    // mapping (uint => address) public questionToOwner; // not sure
    // mapping (address => uint) ownerQuestionCount; // not sure

    mapping(address => Voter) public voters;

    constructor() {
        director = msg.sender;
        voters[director].weight = 1;
    }

    function _createQuestion(string memory _body) internal isOwner {
        // require(msg.sender == director, "Only the director can create questions");
        questions.push(Question(_body, 0, 0, true));
        // uint id = questions.length - 1;
        emit NewQuestion(_body);
    }



}

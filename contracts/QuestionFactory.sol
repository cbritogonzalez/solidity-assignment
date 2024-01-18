// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./Director.sol";

contract QuestionFactory is Director {

    event NewQuestion(string body);
    event QuestionResults(string body, uint positiveResults, uint negativeResults);


    struct Shareholder {
        uint32 weight; // weight is accumulated by delegation 0 = can't vote, 1 = can vote
        uint32 vote;   // index of the voted proposal, 0=false,1=true
        uint32 viewResults; // weight assigned to see if the Shareholder can see the results =0 cant, =1 can
        address shareholderAddress;
    }

    struct Question {
        string body;   // short name (up to 32 bytes)
        uint32 positiveVoteCount; // number of accumulated votes +
        uint32 negativeVoteCount; // number of accumulated votes -
        bool active; // if the question is still active
    }

    Question[] public questions;

    address public director;

    mapping(address => Shareholder) public shareholders;
    mapping(address => Question) public shareholderToQuestion;

    //Emoty Constructor where we set up the director and his properties. 
    constructor() {
        director = msg.sender;
        shareholders[director].weight = 1;
        shareholders[director].viewResults = 1;
    }

    /*
    param @_body the text body of the question
    function to create a question 
    */
    function createQuestion(string memory _body) public isDirector {
        questions.push(Question(_body, 0, 0, true)); 
        emit NewQuestion(_body);
    }

    /*
    param @_address the address of the shareholder
    function to create a shareholder
    used for testing purposes
    */
    function createShareholder(address _address) public isDirector {
        shareholders[_address].weight = 1;
        shareholders[_address].viewResults = 1;
        shareholders[_address].shareholderAddress = _address;
    }

    /*
    param @_questionId the id of the question that is being voted
    param @_vote the vote of the shareholder (0 for false 1 for true)
    */
    function vote(uint _questionId, uint _vote) public {
       require(questions[_questionId].active == true);  //check if director did not close the voting process of the question
       require(shareholders[msg.sender].weight > 0); //check if shareholder can vote
       Question storage questionVoted = shareholderToQuestion[msg.sender]; //question that is mapped to the voter
       Question storage questionCurrentlyVoting = questions[_questionId]; //question that is currently being voted 
       //compare the two questions (structs) to see if the shareholder voted this question
       require(keccak256(abi.encode(questionVoted)) != keccak256(abi.encode(questionCurrentlyVoting)));
       if (_vote > 0){ //add vote to VoteCount
        questions[_questionId].positiveVoteCount++;
       } else {
        questions[_questionId].negativeVoteCount++;
       }
       shareholderToQuestion[msg.sender] = questions[_questionId]; //map shareholder to question
    }

}

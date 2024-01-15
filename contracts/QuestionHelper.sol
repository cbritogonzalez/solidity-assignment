// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./QuestionFactory.sol";
import "contracts/Director.sol";

contract QuestionHelper is QuestionFactory {

  modifier checkViewPriveledges(address _shareholder, uint _level){
    require(shareholders[_shareholder].viewResults > _level);
    _;
  }


  function changeRightToVote(address _voterId, uint _rightValue) external isDirector {
    shareholders[_voterId].weight = _rightValue;
  }

  function changeRightToView(address _voterId, uint _rightValue) external isDirector {
    shareholders[_voterId].viewResults = _rightValue;
  }

  function closeQuestionVoting(uint _questionId) external isDirector {
    // require(msg.sender == questionToOwner[_questionId]);
    questions[_questionId].active = false;
    emit QuestionResults(questions[_questionId].body, questions[_questionId].positiveVoteCount, questions[_questionId].negativeVoteCount);
  }

  function viewResults(uint _questionId) external checkViewPriveledges(msg.sender, 0) view returns (string memory){
    require(questions[_questionId].active == false);
    if(questions[_questionId].positiveVoteCount > questions[_questionId].negativeVoteCount ) {
        return "Question has passed";
    } else {
        return "Question has not passed";
    }
  }

}

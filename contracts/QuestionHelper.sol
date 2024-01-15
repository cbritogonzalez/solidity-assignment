// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./QuestionFactory.sol";
import "contracts/Director.sol";

contract QuestionHelper is QuestionFactory {


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

}

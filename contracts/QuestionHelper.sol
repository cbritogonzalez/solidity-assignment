// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./QuestionFactory.sol";
import "contracts/Director.sol";

contract QuestionHelper is QuestionFactory {

  /*
  @param _shareholder the shareholder
  @param _level the level of being able to see the results
  Modifier to check the view the results priviledge of the shareholder
  */
  modifier checkViewPriveledges(address _shareholder, uint _level){
    require(shareholders[_shareholder].viewResults > _level);
    _;
  }

  /*
  param @_shareholderId the id of the shareholder
  param @_rightValue the value of the shareholder that shows right to vote (0 = can't vote, 1 = can vote)
  function where the director can change the right to vote of a shareholder
  */
  function changeRightToVote(address _shareholderId, uint _rightValue) external isDirector {
    shareholders[_shareholderId].weight = uint32(_rightValue);
  }

  /*
  param @_shareholderId the id of the shareholder
  param @_rightValue the value of the shareholder that shows right to vote (0 = can't vote, 1 = can vote)
  function where the director can change the right to view the results of a question of a shareholder
  */
  function changeRightToView(address _shareholderId, uint _rightValue) external isDirector {
    shareholders[_shareholderId].viewResults = uint32(_rightValue);
  }

  /*
  @param _questionId the id of the question
  function where the director can close the voting process of a question
  */
  function closeQuestionVoting(uint _questionId) external isDirector {
    questions[_questionId].active = false;
    emit QuestionResults(questions[_questionId].body, questions[_questionId].positiveVoteCount, questions[_questionId].negativeVoteCount);
  }

  /*
  @param _questionId the id of the question
  function where every shareholder with the priviledge to view results can see the results 
  @return string that states whether or not the question passed
  */
  function viewResults(uint _questionId) external checkViewPriveledges(msg.sender, 0) view returns (string memory){
    require(questions[_questionId].active == false); //check if the question is active
    if(questions[_questionId].positiveVoteCount > questions[_questionId].negativeVoteCount ) {
        return "Question has passed";
    } else {
        return "Question has not passed";
    }
  }

}

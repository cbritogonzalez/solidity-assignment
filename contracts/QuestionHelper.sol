// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./QuestionFactory.sol";

contract QuestionHelper is QuestionFactory {

  modifier aboveLevel(uint _level, uint _questionId) {
    require(questions[_questionId].level >= _level);
    _;
  }

  function changeName(uint _questionId, string calldata _newName) external aboveLevel(2, _questionId) {
    require(msg.sender == questionToOwner[_questionId]);
    questions[_questionId].name = _newName;
  }

  function changeDna(uint _questionId, uint _newDna) external aboveLevel(20, _questionId) {
    require(msg.sender == questionToOwner[_questionId]);
    questions[_questionId].dna = _newDna;
  }

  function getQuestionsByOwner(address _owner) external view returns(uint[] memory) {
    uint[] memory result = new uint[](ownerQuestionCount[_owner]);
    // Start here
    return result;
  }

}

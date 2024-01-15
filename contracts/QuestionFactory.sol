// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./2_Owner.sol";

contract QuestionFactory is Owner {

    event NewQuestion(uint questionId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Question {
      string name;
      uint dna;
      uint32 level;
      uint32 readyTime;
    }

    Question[] public questions;

    mapping (uint => address) public questionToOwner;
    mapping (address => uint) ownerQuestionCount;

    function _createQuestion(string memory _name, uint _dna) internal {
        questions.push(Question(_name, _dna, 1, uint32(block.timestamp + cooldownTime)));
        uint id = questions.length - 1;
        questionToOwner[id] = msg.sender;
        ownerQuestionCount[msg.sender]++;
        emit NewQuestion(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomQuestion(string memory _name) public {
        require(ownerQuestionCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createQuestion(_name, randDna);
    }

}

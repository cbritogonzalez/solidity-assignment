// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";

/**
 * @title Owner
 * @dev Set & change owner
 */
contract Director {

    address private director;

    // event for EVM logging
    event DirectorSet(address indexed oldDirector, address indexed newDirector);

    // modifier to check if caller is owner
    modifier isDirector() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.
        require(msg.sender == director, "Caller is not director");
        _;
    }

    /**
     * @dev Set contract deployer as director
     */
    constructor() {
        console.log("Director contract deployed by:", msg.sender);
        director = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit DirectorSet(address(0), director);
    }

    /**
     * @dev Change director
     * @param newDirector address of new director
     */
    function changeDirector(address newDirector) public isDirector {
        emit DirectorSet(director, newDirector);
        director = newDirector;
    }

    /**
     * @dev Return director address 
     * @return address of director
     */
    function getDirector() external view returns (address) {
        return director;
    }
} 
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 seed;
    event NewWave(address indexed from, uint256 timestamp, string message);

    // mapping(address => uint256) public addressWaves;
    // address[] wavers;

    struct Wave {
        address wave;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        totalWaves = 0;
        seed = (block.timestamp + block.difficulty) % 100;
        console.log("this is a smart contract");
    }

    function wave(string memory _message) public {
        // addressWaves[msg.sender] += 1;
        // wavers.push(msg.sender);
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Wait you on hold"
        );

        lastWavedAt[msg.sender] = block.timestamp;
        totalWaves += 1;

        console.log(
            "%d.%s has waved at you with %s",
            totalWaves,
            msg.sender,
            _message
        );
        waves.push(Wave(msg.sender, _message, block.timestamp));
        seed = (block.difficulty + block.timestamp + seed) % 100;
        if (seed <= 50) {
            console.log("%s won the prize", msg.sender);
            uint256 prize = 0.0001 ether;
            require(prize <= address(this).balance, "bruh no cash!!");
            (bool success, ) = (msg.sender).call{value: prize}("");
            require(success, "transaction failed!");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have total of %d waves", totalWaves);
        // console.log("Waves by %d are %d", msg.sender, addressWaves[msg.sender]);
        // console.log("No of wavers are %d", wavers.length);
        return totalWaves;
    }
}

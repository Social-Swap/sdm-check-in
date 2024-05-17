// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract CheckIn is Ownable, ReentrancyGuard {

    bool private useCheckToken = false;
    address public checkToken;
    mapping(address => uint256) public lastCheckInTime;
    mapping(address => uint256) public checkInCount;

    event CheckIn(address indexed sender, uint256 time);

    constructor() {
    }

    function setUseCheckToken(bool use) public onlyOwner {
        useCheckToken = use;
    }

    function setCheckToken(address _checkToken) public onlyOwner {
        checkToken = _checkToken;
    }

    function checkIn() public nonReentrant {
        if (useCheckToken) {
            require(checkToken != address(0), "checkToken not set");
            uint256 balance = IERC721(checkToken).balanceOf(_msgSender());
            require(balance > 0, "must have NFT on checking in");
        }

        uint256 time = block.timestamp;
        lastCheckInTime[_msgSender()] = time;
        checkInCount[_msgSender()] += 1;
        emit CheckIn(_msgSender(), time);
    }

}

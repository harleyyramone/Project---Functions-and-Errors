// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ErrorHandlingDemo {
    address public user;
    uint256 public balance;

    constructor() {
        user = msg.sender;
    }

    // Function to deposit 
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balance += msg.value;
    }

    // Function to withdraw 
    function withdraw(uint256 amount) public {
        require(amount <= balance, "Insufficient balance");
        require(msg.sender == user, "Only the owner can withdraw");
        payable(msg.sender).transfer(amount);
        balance -= amount;
    }

    // Function to assert
    function checkOwner() public view {
        assert(user == msg.sender);
    }

    // Function to revert
    function triggerRevert() public view {
        if (msg.sender != user) {
            revert("Caller is not the owner");
        }
    }
}

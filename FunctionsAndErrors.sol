// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Marketplace {
    address public owner;
    uint256 public itemCount;
    uint256 public contractBalance;

    struct Item {
        uint256 id;
        string name;
        uint256 price;
        address payable seller;
        bool sold;
    }

    mapping(uint256 => Item) public items;

    event ItemListed(uint256 id, string name, uint256 price, address seller);
    event ItemPurchased(uint256 id, string name, uint256 price, address buyer, address seller);
    event Deposit(address indexed user, uint256 amount, uint256 balance);

    constructor() {
        owner = msg.sender;
        itemCount = 0;
        contractBalance = 0;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Function to list an item
    function listItem(string memory name, uint256 price) public {
        require(price > 0, "Price must be greater than zero");

        itemCount++;
        items[itemCount] = Item(itemCount, name, price, payable(msg.sender), false);

        emit ItemListed(itemCount, name, price, msg.sender);
    }

    // Function to purchase an item
    function purchaseItem(uint256 id) public payable {
        Item storage item = items[id];
        require(id > 0 && id <= itemCount, "Item does not exist");
        require(msg.value >= item.price, "Not enough Ether to purchase the item");
        require(!item.sold, "Item is already sold");

        item.seller.transfer(msg.value);
        item.sold = true;

        emit ItemPurchased(id, item.name, item.price, msg.sender, item.seller);
    }

    // Function to check if the caller is the owner
    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    // Function to trigger revert
    function triggerRevert() public view {
        if (msg.sender != owner) {
            revert("Caller is not the owner");
        }
    }

    // Function to deposit Ether into the contract
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");

        contractBalance += msg.value;

        emit Deposit(msg.sender, msg.value, contractBalance);
    }

    // Function to withdraw Ether from the contract (only owner)
    function withdraw(uint256 amount) public onlyOwner {
        require(amount <= contractBalance, "Insufficient contract balance");

        payable(owner).transfer(amount);
        contractBalance -= amount;
    }
}

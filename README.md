# Project-Functions-and-Errors

This programs is a straightforward example designed to illustrate the fundamental error handling mechanisms in Solidity. This contract enables users to deposit and withdraw Ether while ensuring that specific conditions are met to prevent errors and unauthorized access. It leverages require and assert statements to enforce these conditions, making it an excellent educational tool for those new to smart contract development.

## Description

This project uses Solidity to construct a decentralized marketplace smart contract that allows users to safely list, buy, and manage products on the Ethereum blockchain. The contract provides features for displaying goods at set pricing, buying goods while making sure to pay for them in full, and adding Ether to the agreement. In order to maintain the contract's dependability and security, it also includes strong error handling techniques that handle exceptions and enforce conditions utilizing the need, assert, and reverse statements. In order to improve accessibility and control, the contract also gives the owner the opportunity to withdraw Ether and includes tools to verify ownership. In addition, important events like as the listing, buying, and depositing of ether are broadcast, which facilitates easy and transparent tracking of marketplace activity. This project shows how smart contracts can be used in creating a decentralized marketplace, showcasing Solidity's capabilities in building secure and efficient decentralized applications.
## Getting Started

### Executing program

To execute this program, you may use Remix, an online Solidity IDE; to get started, go visit https://remix.ethereum.org/.

Once on the Remix website, click the "+" symbol in the left-hand sidebar to create a new file. Save the file as HelloWorld.sol. Copy and paste the code below into the file.

```javascript
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

        uint256 previousBalance = contractBalance;
        contractBalance += msg.value;

        // Assert that the new balance is correct
        assert(contractBalance == previousBalance + msg.value);

        emit Deposit(msg.sender, msg.value, contractBalance);
    }

    // Function to withdraw Ether from the contract (only owner)
    function withdraw(uint256 amount) public onlyOwner {
        require(amount <= contractBalance, "Insufficient contract balance");

        payable(owner).transfer(amount);
        contractBalance -= amount;
    }
}




```


To compile the code, select the "Solidity Compiler" tab from the left sidebar. Set the "Compiler" option to "0.8.18" (or any suitable version), then click the "Compile HelloWorld.sol" button.

Once the code has been built, you can deploy the contract by selecting the "Deploy & Run Transactions" tab in the left-hand sidebar. Choose the "HelloWorld" contract from the dropdown menu, and then click the "Deploy" button.

Once the contract has been deployed, you can interact with it by using the sayHello method. Click the "HelloWorld" contract in the left-hand sidebar, followed by the "sayHello" function. Finally, click the "transact" button to call the function and get the "Hello World!" message.
## Authors

Metacrafter Student Harley Ramone Tesorero
[@harleyramonee](https://twitter.com/harleyramonee)


## License

This project is licensed under the Harley Ramone Tesorero License - see the LICENSE.md file for details

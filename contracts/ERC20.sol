// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract JOETOKEN {
    string tokenName;
    string tokenSymbol;
    uint decimals = 18;
    uint total_supply;
    address owner;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner");
        _;
    }

    constructor(string memory _tokenName, string memory _tokenSymbol) {
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        owner = msg.sender;
    }

    function totalSupply() public view returns (uint256) {
        return total_supply;
    }

    function balanceOf(address tokenOwner) public view returns (uint) {
        uint bal = balances[tokenOwner];
        return bal;
    }

    function transfer(address recipient, uint amount) external returns (bool) {
        require(balances[msg.sender] >= amount, "Insufficient Funds");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool) {
        allowances[sender][msg.sender] -= amount;
        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint amount, address earner) external onlyOwner {
        balances[earner] += amount;
        total_supply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        require(balances[msg.sender] >= amount, "Insufficient Funds");
        balances[msg.sender] -= amount;
        total_supply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}

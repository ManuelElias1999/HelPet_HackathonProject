// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./registerUsers.sol";
import "./tokenHelPet.sol";

/**
 * @dev Contract deployed on Taiko Hekla
 * @notice You can view the deployed contract at:
 * https://hekla.taikoscan.io/address/0x504113E71463E73e516013FBe37EC05aa472B7B3
*/


contract FindPet is Ownable {
    
    // Counter for post IDs
    uint256 private postIdCounter = 0;

    // Taiko USDC contract address
    //address constant public USDC = 0x07d83526730c7438048D55A4fc0b850e2aaB6f0b;

    // USDCPet contract address
    address constant public USDC = 0xFfBe90233da12086F7E410142Fd22185A5f84e13;

    // Struct to store post information
    struct Post {
        address creator;
        uint256 amount;
        bool isOpen;
    }

    // Mapping from post ID to Post struct
    mapping(uint256 => Post) public posts;
    // Mapping to track authorized agents
    mapping(address => bool) private agents;

    // Events
    event PostCreated(uint256 indexed postId, address indexed creator, uint256 amount);
    event PostClosed(uint256 indexed postId, address indexed beneficiary, uint256 amount);
    
    // Reference to other contracts
    RegisterUsers public registerUsers;
    TokenHelPet public tokenHelPet;
    IERC20 public usdc;

    // Events
    event AgentAdded(address indexed agent);
    event AgentRemoved(address indexed agent);
    event DonationReceived(address indexed donor, uint256 amount);
    event DonationProcessed(address indexed donor, uint256 amount, uint256 tokens);

    /**
     * @dev Constructor initializes the contract with references to other contracts
     * @param _registerUsers Address of the RegisterUsers contract
     * @param _tokenHelPet Address of the TokenHelPet contract
     */
    constructor(address _registerUsers, address _tokenHelPet) Ownable(msg.sender) {
        require(_registerUsers != address(0), "Invalid RegisterUsers address");
        require(_tokenHelPet != address(0), "Invalid TokenHelPet address");
        registerUsers = RegisterUsers(_registerUsers);
        tokenHelPet = TokenHelPet(_tokenHelPet);
        usdc = IERC20(USDC);
    }

    /**
     * @dev Modifier to restrict functions to authorized agents only
     */
    modifier onlyAgent() {
        require(agents[msg.sender], "Only agents can perform this action");
        _;
    }

    /**
     * @dev Adds a new agent
     * @param _agent Address of the agent to add
     */
    function addAgent(address _agent) external onlyOwner {
        require(_agent != address(0), "Cannot add zero address as agent");
        require(!agents[_agent], "Address is already an agent");
        agents[_agent] = true;
        emit AgentAdded(_agent);
    }

    /**
     * @dev Removes an agent
     * @param _agent Address of the agent to remove
     */
    function removeAgent(address _agent) external onlyOwner {
        require(agents[_agent], "Address is not an agent");
        agents[_agent] = false;
        emit AgentRemoved(_agent);
    }

    /**
     * @dev Checks if an address is an agent
     * @param _address Address to check
     */
    function isAgent(address _address) external view returns (bool) {
        return agents[_address];
    }

    /**
     * @dev Creates a new post with a reward amount
     * @param _amount Amount of USDC for the reward
     */
    function createPost(uint256 _amount) external {
        // Check if sender is registered user or entity
        require(
            registerUsers.isRegisteredUser(msg.sender) || 
            registerUsers.isRegisteredEntity(msg.sender),
            "Must be registered user or entity"
        );
        require(_amount > 0, "Amount must be greater than 0");

        // Transfer USDC from sender to contract
        require(
            usdc.transferFrom(msg.sender, address(this), _amount),
            "USDC transfer failed"
        );

        // Create new post
        uint256 postId = postIdCounter++;
        posts[postId] = Post({
            creator: msg.sender,
            amount: _amount,
            isOpen: true
        });

        emit PostCreated(postId, msg.sender, _amount);
    }

    /**
     * @dev Closes a post and distributes the reward
     * @param _postId ID of the post to close
     * @param _beneficiary Address to receive the reward
     */
    function closePost(uint256 _postId, address _beneficiary) external {
        require(_postId < postIdCounter, "Post does not exist");
        Post storage post = posts[_postId];
        require(post.isOpen, "Post is already closed");
        require(
            msg.sender == post.creator || agents[msg.sender],
            "Only creator or agent can close post"
        );
        require(_beneficiary != address(0), "Invalid beneficiary address");

        post.isOpen = false;

        // Calculate amounts
        uint256 beneficiaryAmount = (post.amount * 97) / 100;
        uint256 ownerAmount = post.amount - beneficiaryAmount;

        // Transfer rewards in USDC from this contract
        require(
            usdc.transferFrom(address(this), _beneficiary, beneficiaryAmount),
            "Beneficiary USDC transfer failed"
        );
        require(
            usdc.transferFrom(address(this), owner(), ownerAmount),
            "Owner USDC transfer failed"
        );

        // Mint HelPet tokens to beneficiary
        tokenHelPet.mint(_beneficiary, 50);

        emit PostClosed(_postId, _beneficiary, post.amount);
    }

    /**
     * @dev Returns post information
     * @param _postId ID of the post
     */
    function getPost(uint256 _postId) external view returns (
        address creator,
        uint256 amount,
        bool isOpen
    ) {
        require(_postId < postIdCounter, "Post does not exist");
        Post storage post = posts[_postId];
        return (post.creator, post.amount, post.isOpen);
    }

}


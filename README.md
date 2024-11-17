# HelPet Platform

HelPet is a decentralized platform that connects animal shelters with donors through blockchain technology, enabling transparent and efficient donations while rewarding contributors with tokens.

## Smart Contracts

The platform consists of six main smart contracts deployed on Taiko Hekla testnet:

### TokenHelPet Contract
- ERC20 token used as reward for donations
- Minted when users donate to causes
- Can be redeemed for items/services

### USDCPet Contract
- Test USDC token implementation
- Used for testing donations functionality
- Created due to lack of USDC on Hekla testnet

### RegisterUsers Contract
**Address**: [0xd28eb2D29964127D102cD0047A1fee319B328Bca](https://hekla.taikoscan.io/address/0xd28eb2D29964127D102cD0047A1fee319B328Bca)
- Manages user and entity registration
- Only owner can register new users/entities
- Maintains registry of verified users and animal shelters

### FindPet Contract
- Allows entities to post lost pets
- Users can report found pets
- Manages lost and found pet listings

### Donate Contract  
**Address**: [0xB909aF950B7cd7abcDFebd2f7Ec9133E141d55A5](https://hekla.taikoscan.io/address/0xB909aF950B7cd7abcDFebd2f7Ec9133E141d55A5)
- Allows registered entities to create donation posts
- Enables registered users to donate USDCPet tokens
- Automatically mints HelPet tokens as rewards
- Takes 1% platform fee from donations
- Posts can be closed by creators or agents

### Redeem Contract
**Address**: [0xcB0f68Cb1E6F4466F6970De9a3a70489Ee7D3a7A](https://hekla.taikoscan.io/address/0xcB0f68Cb1E6F4466F6970De9a3a70489Ee7D3a7A)
- Allows entities to create redemption posts for items/services
- Users can redeem items using their HelPet tokens
- Manages inventory and token transfers
- Posts can be closed by creators or agents

## Technologies Used

- **Solidity**: Smart contract development
- **Foundry**: Testing framework and development environment
- **Taiko**: Layer 2 scaling solution
- **OpenZeppelin**: Smart contract security standards

## Testing

Each contract has its own test file with comprehensive test coverage. The tests verify all main functionalities including:

- User and entity registration
- Donation post creation and management
- Token minting and transfers
- Redemption post creation and claiming
- Access control and permissions
- Error handling and edge cases

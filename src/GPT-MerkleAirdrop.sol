// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./SimToken.sol";

contract MerkleAirdrop is Ownable, ReentrancyGuard {
    SimToken public token;
    bytes32 public merkleRoot;
    mapping(address => bool) public hasClaimed;

    event Claimed(address indexed claimant, uint256 amount);

    constructor(address _token) Ownable(msg.sender) {
        token = SimToken(_token);
    }

    /**
     * @notice Sets the Merkle Root of the airdrop.
     * @dev Only the owner can set the Merkle Root.
     * @param _merkleRoot The Merkle Root of the eligible recipients.
     */
    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
    }

    /**
     * @notice Allows users to claim their airdropped tokens.
     * @param amount The amount of tokens to claim.
     * @param merkleProof The Merkle Proof to verify the claim.
     */
    function claim(uint256 amount, bytes32[] calldata merkleProof) external nonReentrant {
        require(!hasClaimed[msg.sender], "MerkleAirdrop: Tokens already claimed");
        require(amount > 0, "MerkleAirdrop: Amount must be greater than zero");

        // Verify the Merkle Proof
        bytes32 leaf = keccak256(abi.encodePacked(msg.sender, amount));
        require(
            MerkleProof.verify(merkleProof, merkleRoot, leaf),
            "MerkleAirdrop: Invalid Merkle Proof"
        );

        hasClaimed[msg.sender] = true;

        // Transfer tokens to the claimant
        require(token.transfer(msg.sender, amount), "MerkleAirdrop: Token transfer failed");

        emit Claimed(msg.sender, amount);
    }

    /**
     * @notice Allows the owner to fund the airdrop contract with tokens.
     * @param amount The amount of tokens to deposit.
     */
    function fundAirdrop(uint256 amount) external onlyOwner {
        require(token.transferFrom(msg.sender, address(this), amount), "MerkleAirdrop: Funding failed");
    }

    /**
     * @notice Allows the owner to withdraw unclaimed tokens after the airdrop ends.
     * @param to The address to send the remaining tokens to.
     */
    function withdrawRemainingTokens(address to) external onlyOwner {
        uint256 remainingBalance = token.balanceOf(address(this));
        require(token.transfer(to, remainingBalance), "MerkleAirdrop: Withdrawal failed");
    }
}

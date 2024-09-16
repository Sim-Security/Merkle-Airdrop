// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { MerkleAirdrop, IERC20 } from "../src/MerkleAirdrop.sol";
import { Script } from "forge-std/Script.sol";
import { SimToken } from "../src/SimToken.sol";
import { console } from "forge-std/console.sol";

contract DeployMerkleAirdrop is Script {
    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    // 4 users, 25 Sim tokens each
    uint256 public AMOUNT_TO_TRANSFER = 4 * (25 * 1e18);

    // Deploy the airdrop contract and bagel token contract
    function deployMerkleAirdrop() public returns (MerkleAirdrop, SimToken) {
        vm.startBroadcast();
        SimToken simToken = new SimToken();
        MerkleAirdrop airdrop = new MerkleAirdrop(ROOT, IERC20(simToken));
        // Send Sim tokens -> Merkle Air Drop contract
        simToken.mint(simToken.owner(), AMOUNT_TO_TRANSFER);
        IERC20(simToken).transfer(address(airdrop), AMOUNT_TO_TRANSFER);
        vm.stopBroadcast();
        return (airdrop, simToken);
    }

    function run() external returns (MerkleAirdrop, SimToken) {
        return deployMerkleAirdrop();
    }
}
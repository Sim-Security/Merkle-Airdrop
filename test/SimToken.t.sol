// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.24;

// import "forge-std/Test.sol";
// import "../src/SimToken.sol";

// contract SimTokenTest is Test {
//     SimToken simToken;
//     address owner;
//     address user1 = address(0x1);
//     address user2 = address(0x2);

//     function setUp() public {
//         owner = address(this); // The test contract is the owner
//         simToken = new SimToken();
//     }

//     function testInitialSupplyIsZero() public {
//         uint256 totalSupply = simToken.totalSupply();
//         assertEq(totalSupply, 0, "Initial total supply should be zero");
//     }

//     function testMintByOwner() public {
//         uint256 mintAmount = 1000 * 1e18;
//         simToken.mint(user1, mintAmount);
//         uint256 userBalance = simToken.balanceOf(user1);
//         assertEq(userBalance, mintAmount, "User1 balance should match mint amount");
//     }

//     function testMintByNonOwnerReverts() public {
//         vm.prank(user1);
//         uint256 mintAmount = 1000 * 1e18;
//         vm.expectRevert("Ownable: caller is not the owner");
//         simToken.mint(user1, mintAmount);
//     }

//     function testTransferTokens() public {
//         uint256 mintAmount = 1000 * 1e18;
//         simToken.mint(owner, mintAmount);
//         simToken.transfer(user1, 500 * 1e18);
//         uint256 ownerBalance = simToken.balanceOf(owner);
//         uint256 userBalance = simToken.balanceOf(user1);
//         assertEq(ownerBalance, 500 * 1e18, "Owner balance should be 500 SIM");
//         assertEq(userBalance, 500 * 1e18, "User1 balance should be 500 SIM");
//     }

//     function testTransferExceedsBalanceReverts() public {
//         uint256 mintAmount = 500 * 1e18;
//         simToken.mint(owner, mintAmount);
//         vm.expectRevert("ERC20: transfer amount exceeds balance");
//         simToken.transfer(user1, 1000 * 1e18);
//     }

//     function testApproveAndTransferFrom() public {
//         uint256 mintAmount = 1000 * 1e18;
//         simToken.mint(owner, mintAmount);
//         simToken.approve(user1, 500 * 1e18);

//         vm.prank(user1);
//         simToken.transferFrom(owner, user2, 500 * 1e18);

//         uint256 ownerBalance = simToken.balanceOf(owner);
//         uint256 user2Balance = simToken.balanceOf(user2);
//         assertEq(ownerBalance, 500 * 1e18, "Owner balance should be 500 SIM");
//         assertEq(user2Balance, 500 * 1e18, "User2 balance should be 500 SIM");
//     }

//     function testTransferFromExceedsAllowanceReverts() public {
//         uint256 mintAmount = 1000 * 1e18;
//         simToken.mint(owner, mintAmount);
//         simToken.approve(user1, 500 * 1e18);

//         vm.prank(user1);
//         vm.expectRevert("ERC20: insufficient allowance");
//         simToken.transferFrom(owner, user2, 600 * 1e18);
//     }
// }

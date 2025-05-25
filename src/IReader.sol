// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IReader {
    function getBatchNftInfo(address, uint256, uint256) external view returns (NftInfo[] memory);
    function aggregateTokenBalsForUser(address[] memory, address) external view returns (TokenBalance[] memory);
    function aggregateSingleTokenBals(address[] memory, address) external view returns (TokenBalance[] memory);
    function aggregateBalances(TokenBalanceQuery[] memory) external view returns(TokenBalance[] memory);
}

struct TokenBalanceQuery {
    address contract_addr;
    address user;
}

struct TokenBalance {
    address contract_addr;
    uint256 amount;
    address user;
    uint8 decimals;
}

struct NftInfo {
    address owner;
    uint256 token_num;
}

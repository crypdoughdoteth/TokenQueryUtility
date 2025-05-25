// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13;

import "../../lib/utils/VyperDeployer.sol";
import {Test} from "../../lib/forge-std/src/Test.sol";
import {console2} from "../../lib/forge-std/src/console2.sol";
import {TokenBalanceQuery, TokenBalance, NftInfo, IReader} from "../IReader.sol";

contract ReaderTest is Test {
    VyperDeployer vyperDeployer = new VyperDeployer();
    IReader reader;
    address[] tokens = [0xcf0C122c6b73ff809C693DB761e7BaeBe62b6a2E, 0x15874d65e649880c2614e7a480cb7c9A55787FF6];
    address[] users = [0x39A4f8cB2dF247dB403E2A468e2Fb786452A0616, 0x39A4f8cB2dF247dB403E2A468e2Fb786452A0616];
    address token2 = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    TokenBalanceQuery[] query = [
        TokenBalanceQuery(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, 0x7BDb61d76aB2237102a7203dA24816eF0A6408F6), 
        TokenBalanceQuery(0xcf0C122c6b73ff809C693DB761e7BaeBe62b6a2E, 0x940ACd9375b46EC2FA7C0E8aAd9D7241fb01e205)
    ];

    function setUp() public {
        ///@notice deploy a new instance of ISimplestore by passing in the address of the deployed Vyper contract
        reader = IReader(vyperDeployer.deployContract("Reader", abi.encode()));
    }

    function test_milady() public view {
         address milady = 0x7011EE079F579EB313012BDdb92fd6F06FA43335;
         NftInfo[] memory res = reader.getBatchNftInfo(milady, 1, 2);
         assertTrue(res.length > 0, "Empty response"); 
     }
    //
    // function test_tokens_multi_agg() public view {
    //    TokenBalance[] memory bals = reader.aggregateTokenBalsForUser(tokens, 0x940ACd9375b46EC2FA7C0E8aAd9D7241fb01e205);
    //    assertTrue(bals.length > 0, "Empty Response");
    // }
    //
    // function test_tokens_single_agg() public view {
    //     TokenBalance[] memory bals = reader.aggregateSingleTokenBals(users, token2);
    //     assertTrue(bals.length > 0, "Empty Response");
    // }
    //
    // function test_multi() public view {
    //     TokenBalance[] memory bals = reader.aggregateBalances(query);
    //     assertTrue(bals.length > 0, "Empty Response");
    // }
}

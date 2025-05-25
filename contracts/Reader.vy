# pragma version 0.4.1

struct TokenBalance:
    contract: address
    amount: uint256
    user: address
    decimals: uint8

struct NftInfo: 
    owner: address 
    token_num: uint256 

struct TokenBalanceQuery:
    contract: address
    user: address

@external
@view 
def aggregateBalances(query: DynArray[TokenBalanceQuery, 1000]) -> DynArray[TokenBalance, 1000]:
    bals: DynArray[TokenBalance, 1000] = []
    for q: TokenBalanceQuery in query:
        successb: bool = False
        raw_bal: Bytes[32] = b"" 
        successb, raw_bal = raw_call(
            q.contract, 
            concat(method_id("balanceOf(address)"), convert(q.user, bytes32)),
            max_outsize=32, 
            value=0, 
            revert_on_failure=False,
            is_static_call=True
        )
        success: bool = False
        raw_decimals: Bytes[32] = b"" 
        success, raw_decimals = raw_call(
            q.contract, 
            method_id("decimals()"),
            max_outsize=32, 
            value=0, 
            revert_on_failure=False,
            is_static_call=True
        )

        bals.append(TokenBalance(
            contract=q.contract, 
            amount=convert(raw_bal, uint256), 
            user=q.user,
            decimals=convert(raw_decimals, uint8)
        ))
    return bals
   
@external
@view 
def aggregateSingleTokenBals(users: DynArray[address, 1000], contract: address) -> DynArray[TokenBalance, 1000]: 
    bals: DynArray[TokenBalance, 1000] = []
    for u: address in users:
        successb: bool = False
        raw_bal: Bytes[32] = b"" 
        successb, raw_bal = raw_call(
            contract, 
            concat(method_id("balanceOf(address)"), convert(u, bytes32)),
            max_outsize=32, 
            value=0, 
            revert_on_failure=False,
            is_static_call=True
        )
        success: bool = False
        raw_decimals: Bytes[32] = b"" 
        success, raw_decimals = raw_call(
            contract, 
            method_id("decimals()"),
            max_outsize=32, 
            value=0, 
            revert_on_failure=False,
            is_static_call=True
        )

        bals.append(TokenBalance(
            contract=contract, 
            amount=convert(raw_bal, uint256), 
            user=u,
            decimals=convert(raw_decimals, uint8)
        ))
    return bals
   

@external
@view 
def aggregateTokenBalsForUser(contracts: DynArray[address, 1000], owner: address) -> DynArray[TokenBalance, 1000]:
    bals: DynArray[TokenBalance, 1000] = []
    for c: address in contracts:
        successb: bool = False
        raw_bal: Bytes[32] = b"" 
        successb, raw_bal = raw_call(
            c,
            concat(method_id("balanceOf(address)"), convert(owner, bytes32)),
            max_outsize=32, 
            value=0, 
            revert_on_failure=False,
            is_static_call=True
        )
        success: bool = False
        raw_decimals: Bytes[32] = b"" 
        success, raw_decimals = raw_call(
            c, 
            method_id("decimals()"),
            max_outsize=32, 
            value=0, 
            revert_on_failure=False,
            is_static_call=True
        )

        bals.append(TokenBalance(
            contract=c, 
            amount=convert(raw_bal, uint256), 
            user=owner,
            decimals=convert(raw_decimals, uint8)
        ))
    return bals

@external
@view
def getBatchNftInfo(contract: address, offset: uint256, limit: uint256) -> DynArray[NftInfo, 10000]:
    results: DynArray[NftInfo, 10000] = []
    for i: uint256 in range(offset, limit + 1, bound=10000):
        success: bool = False
        owner: Bytes[32] = b""
        success, owner = raw_call(
            contract, 
            concat(
                method_id("ownerOf(uint256)"),
                convert(i, bytes32)
            ),
            max_outsize=32, 
            value=0, 
            revert_on_failure=False,
            is_static_call=True
        )
        if not success: 
            continue
        results.append(NftInfo( 
            owner=convert(owner, address), 
            token_num=i, 
        ))
    assert len(results) > 0, "Invalid query range"
    return results

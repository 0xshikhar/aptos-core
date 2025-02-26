
<a id="0x1_managed_coin"></a>

# Module `0x1::managed_coin`

ManagedCoin is built to make a simple walkthrough of the Coins module.
It contains scripts you will need to initialize, mint, burn, transfer coins.
By utilizing this current module, a developer can create his own coin and care less about mint and burn capabilities,


-  [Resource `Capabilities`](#0x1_managed_coin_Capabilities)
-  [Constants](#@Constants_0)
-  [Function `burn`](#0x1_managed_coin_burn)
-  [Function `initialize`](#0x1_managed_coin_initialize)
-  [Function `mint`](#0x1_managed_coin_mint)
-  [Function `register`](#0x1_managed_coin_register)
-  [Specification](#@Specification_1)
    -  [Module-level Specification](#@Module-level_Specification_2)
    -  [High-level Requirements](#high-level-req)
    -  [Function `burn`](#@Specification_1_burn)
    -  [Function `initialize`](#@Specification_1_initialize)
    -  [Function `mint`](#@Specification_1_mint)
    -  [Function `register`](#@Specification_1_register)


<pre><code><b>use</b> <a href="coin.md#0x1_coin">0x1::coin</a>;
<b>use</b> <a href="../../aptos-stdlib/../move-stdlib/doc/error.md#0x1_error">0x1::error</a>;
<b>use</b> <a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">0x1::signer</a>;
<b>use</b> <a href="../../aptos-stdlib/../move-stdlib/doc/string.md#0x1_string">0x1::string</a>;
</code></pre>



<a id="0x1_managed_coin_Capabilities"></a>

## Resource `Capabilities`

Capabilities resource storing mint and burn capabilities.
The resource is stored on the account that initialized coin <code>CoinType</code>.


<pre><code><b>struct</b> <a href="managed_coin.md#0x1_managed_coin_Capabilities">Capabilities</a>&lt;CoinType&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>burn_cap: <a href="coin.md#0x1_coin_BurnCapability">coin::BurnCapability</a>&lt;CoinType&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>freeze_cap: <a href="coin.md#0x1_coin_FreezeCapability">coin::FreezeCapability</a>&lt;CoinType&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>mint_cap: <a href="coin.md#0x1_coin_MintCapability">coin::MintCapability</a>&lt;CoinType&gt;</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a id="@Constants_0"></a>

## Constants


<a id="0x1_managed_coin_ENO_CAPABILITIES"></a>

Account has no capabilities (burn/mint).


<pre><code><b>const</b> <a href="managed_coin.md#0x1_managed_coin_ENO_CAPABILITIES">ENO_CAPABILITIES</a>: u64 = 1;
</code></pre>



<a id="0x1_managed_coin_burn"></a>

## Function `burn`

Withdraw an <code>amount</code> of coin <code>CoinType</code> from <code><a href="account.md#0x1_account">account</a></code> and burn it.


<pre><code><b>public</b> entry <b>fun</b> <a href="managed_coin.md#0x1_managed_coin_burn">burn</a>&lt;CoinType&gt;(<a href="account.md#0x1_account">account</a>: &<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">signer</a>, amount: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="managed_coin.md#0x1_managed_coin_burn">burn</a>&lt;CoinType&gt;(
    <a href="account.md#0x1_account">account</a>: &<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">signer</a>,
    amount: u64,
) <b>acquires</b> <a href="managed_coin.md#0x1_managed_coin_Capabilities">Capabilities</a> {
    <b>let</b> account_addr = <a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(<a href="account.md#0x1_account">account</a>);

    <b>assert</b>!(
        <b>exists</b>&lt;<a href="managed_coin.md#0x1_managed_coin_Capabilities">Capabilities</a>&lt;CoinType&gt;&gt;(account_addr),
        <a href="../../aptos-stdlib/../move-stdlib/doc/error.md#0x1_error_not_found">error::not_found</a>(<a href="managed_coin.md#0x1_managed_coin_ENO_CAPABILITIES">ENO_CAPABILITIES</a>),
    );

    <b>let</b> capabilities = <b>borrow_global</b>&lt;<a href="managed_coin.md#0x1_managed_coin_Capabilities">Capabilities</a>&lt;CoinType&gt;&gt;(account_addr);

    <b>let</b> to_burn = <a href="coin.md#0x1_coin_withdraw">coin::withdraw</a>&lt;CoinType&gt;(<a href="account.md#0x1_account">account</a>, amount);
    <a href="coin.md#0x1_coin_burn">coin::burn</a>(to_burn, &capabilities.burn_cap);
}
</code></pre>



</details>

<a id="0x1_managed_coin_initialize"></a>

## Function `initialize`

Initialize new coin <code>CoinType</code> in Aptos Blockchain.
Mint and Burn Capabilities will be stored under <code><a href="account.md#0x1_account">account</a></code> in <code><a href="managed_coin.md#0x1_managed_coin_Capabilities">Capabilities</a></code> resource.


<pre><code><b>public</b> entry <b>fun</b> <a href="managed_coin.md#0x1_managed_coin_initialize">initialize</a>&lt;CoinType&gt;(<a href="account.md#0x1_account">account</a>: &<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">signer</a>, name: <a href="../../aptos-stdlib/../move-stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;, symbol: <a href="../../aptos-stdlib/../move-stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;, decimals: u8, monitor_supply: bool)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="managed_coin.md#0x1_managed_coin_initialize">initialize</a>&lt;CoinType&gt;(
    <a href="account.md#0x1_account">account</a>: &<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">signer</a>,
    name: <a href="../../aptos-stdlib/../move-stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;,
    symbol: <a href="../../aptos-stdlib/../move-stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;,
    decimals: u8,
    monitor_supply: bool,
) {
    <b>let</b> (burn_cap, freeze_cap, mint_cap) = <a href="coin.md#0x1_coin_initialize">coin::initialize</a>&lt;CoinType&gt;(
        <a href="account.md#0x1_account">account</a>,
        <a href="../../aptos-stdlib/../move-stdlib/doc/string.md#0x1_string_utf8">string::utf8</a>(name),
        <a href="../../aptos-stdlib/../move-stdlib/doc/string.md#0x1_string_utf8">string::utf8</a>(symbol),
        decimals,
        monitor_supply,
    );

    <b>move_to</b>(<a href="account.md#0x1_account">account</a>, <a href="managed_coin.md#0x1_managed_coin_Capabilities">Capabilities</a>&lt;CoinType&gt; {
        burn_cap,
        freeze_cap,
        mint_cap,
    });
}
</code></pre>



</details>

<a id="0x1_managed_coin_mint"></a>

## Function `mint`

Create new coins <code>CoinType</code> and deposit them into dst_addr's account.


<pre><code><b>public</b> entry <b>fun</b> <a href="managed_coin.md#0x1_managed_coin_mint">mint</a>&lt;CoinType&gt;(<a href="account.md#0x1_account">account</a>: &<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">signer</a>, dst_addr: <b>address</b>, amount: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="managed_coin.md#0x1_managed_coin_mint">mint</a>&lt;CoinType&gt;(
    <a href="account.md#0x1_account">account</a>: &<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">signer</a>,
    dst_addr: <b>address</b>,
    amount: u64,
) <b>acquires</b> <a href="managed_coin.md#0x1_managed_coin_Capabilities">Capabilities</a> {
    <b>let</b> account_addr = <a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(<a href="account.md#0x1_account">account</a>);

    <b>assert</b>!(
        <b>exists</b>&lt;<a href="managed_coin.md#0x1_managed_coin_Capabilities">Capabilities</a>&lt;CoinType&gt;&gt;(account_addr),
        <a href="../../aptos-stdlib/../move-stdlib/doc/error.md#0x1_error_not_found">error::not_found</a>(<a href="managed_coin.md#0x1_managed_coin_ENO_CAPABILITIES">ENO_CAPABILITIES</a>),
    );

    <b>let</b> capabilities = <b>borrow_global</b>&lt;<a href="managed_coin.md#0x1_managed_coin_Capabilities">Capabilities</a>&lt;CoinType&gt;&gt;(account_addr);
    <b>let</b> coins_minted = <a href="coin.md#0x1_coin_mint">coin::mint</a>(amount, &capabilities.mint_cap);
    <a href="coin.md#0x1_coin_deposit">coin::deposit</a>(dst_addr, coins_minted);
}
</code></pre>



</details>

<a id="0x1_managed_coin_register"></a>

## Function `register`

Creating a resource that stores balance of <code>CoinType</code> on user's account, withdraw and deposit event handlers.
Required if user wants to start accepting deposits of <code>CoinType</code> in his account.


<pre><code><b>public</b> entry <b>fun</b> <a href="managed_coin.md#0x1_managed_coin_register">register</a>&lt;CoinType&gt;(<a href="account.md#0x1_account">account</a>: &<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">signer</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> entry <b>fun</b> <a href="managed_coin.md#0x1_managed_coin_register">register</a>&lt;CoinType&gt;(<a href="account.md#0x1_account">account</a>: &<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">signer</a>) {
    <a href="coin.md#0x1_coin_register">coin::register</a>&lt;CoinType&gt;(<a href="account.md#0x1_account">account</a>);
}
</code></pre>



</details>

<a id="@Specification_1"></a>

## Specification


<a id="@Module-level_Specification_2"></a>

### Module-level Specification




<a id="high-level-req"></a>

### High-level Requirements

<table>
<tr>
<th>No.</th><th>Property</th><th>Criticality</th><th>Implementation</th><th>Enforcement</th>
</tr>

<tr>
<td>1</td>
<td>The initializing account should hold the capabilities to operate the coin.</td>
<td>Critical</td>
<td>The capabilities are stored under the initializing account under the Capabilities resource, which is distinct for a distinct type of coin.</td>
<td>Enforced via: initialize</td>
</tr>

<tr>
<td>2</td>
<td>A new coin should be properly initialized.</td>
<td>High</td>
<td>In the initialize function, a new coin is initialized via the coin module with the specified properties.</td>
<td>Enforced via: initialize_internal</td>
</tr>

<tr>
<td>3</td>
<td>Minting/Burning should only be done by the account who hold the valid capabilities.</td>
<td>High</td>
<td>The mint and burn capabilities are moved under the initializing account and retrieved, while minting/burning</td>
<td>Enforced via: <a href="managed_coin.md#high-level-spec-3.1">initialize</a>, <a href="#high-level-spec-3.2">burn</a>, <a href="#high-level-spec-3.3">mint</a>.</td>
</tr>

<tr>
<td>4</td>
<td>If the total supply of coins is being monitored, burn and mint operations will appropriately adjust the total supply.</td>
<td>High</td>
<td>The coin::burn and coin::mint functions, when tracking the supply, adjusts the total coin supply accordingly.</td>
<td>Formally Verified: TotalSupplyNoChange</td>
</tr>

<tr>
<td>5</td>
<td>Before burning coins, exact amount of coins are withdrawn.</td>
<td>High</td>
<td>After utilizing the coin::withdraw function to withdraw coins, they are then burned, and the function ensures the precise return of the initially specified coin amount.</td>
<td>Enforced via: burn_from</td>
</tr>

</table>

</high-level-req>


<pre><code><b>pragma</b> verify = <b>true</b>;
<b>pragma</b> aborts_if_is_strict;
</code></pre>



<a id="@Specification_1_burn"></a>

### Function `burn`


<pre><code><b>public</b> entry <b>fun</b> <a href="managed_coin.md#0x1_managed_coin_burn">burn</a>&lt;CoinType&gt;(<a href="account.md#0x1_account">account</a>: &<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">signer</a>, amount: u64)
</code></pre>




<pre><code><b>let</b> account_addr = <a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(<a href="account.md#0x1_account">account</a>);
<b>aborts_if</b> !<b>exists</b>&lt;<a href="managed_coin.md#0x1_managed_coin_Capabilities">Capabilities</a>&lt;CoinType&gt;&gt;(account_addr);
<b>let</b> coin_store = <b>global</b>&lt;<a href="coin.md#0x1_coin_CoinStore">coin::CoinStore</a>&lt;CoinType&gt;&gt;(account_addr);
<b>let</b> balance = coin_store.<a href="coin.md#0x1_coin">coin</a>.value;
// This enforces <a id=high-level-spec-3.2 href="#high-level-req">high-level requirement 3</a>:
<b>aborts_if</b> !<b>exists</b>&lt;<a href="coin.md#0x1_coin_CoinStore">coin::CoinStore</a>&lt;CoinType&gt;&gt;(account_addr);
<b>aborts_if</b> coin_store.frozen;
<b>aborts_if</b> balance &lt; amount;
<b>let</b> addr =  <a href="../../aptos-stdlib/doc/type_info.md#0x1_type_info_type_of">type_info::type_of</a>&lt;CoinType&gt;().account_address;
<b>let</b> maybe_supply = <b>global</b>&lt;<a href="coin.md#0x1_coin_CoinInfo">coin::CoinInfo</a>&lt;CoinType&gt;&gt;(addr).supply;
<b>aborts_if</b> amount &lt;= 0;
<b>aborts_if</b> !<b>exists</b>&lt;<a href="coin.md#0x1_coin_CoinInfo">coin::CoinInfo</a>&lt;CoinType&gt;&gt;(addr);
<b>include</b> <a href="coin.md#0x1_coin_CoinSubAbortsIf">coin::CoinSubAbortsIf</a>&lt;CoinType&gt; { amount:amount };
<b>ensures</b> <a href="coin.md#0x1_coin_supply">coin::supply</a>&lt;CoinType&gt; == <b>old</b>(<a href="coin.md#0x1_coin_supply">coin::supply</a>&lt;CoinType&gt;) - amount;
</code></pre>



<a id="@Specification_1_initialize"></a>

### Function `initialize`


<pre><code><b>public</b> entry <b>fun</b> <a href="managed_coin.md#0x1_managed_coin_initialize">initialize</a>&lt;CoinType&gt;(<a href="account.md#0x1_account">account</a>: &<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">signer</a>, name: <a href="../../aptos-stdlib/../move-stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;, symbol: <a href="../../aptos-stdlib/../move-stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;, decimals: u8, monitor_supply: bool)
</code></pre>


Make sure <code>name</code> and <code>symbol</code> are legal length.
Only the creator of <code>CoinType</code> can initialize.
The 'name' and 'symbol' should be valid utf8 bytes
The Capabilities<CoinType> should not be under the signer before creating;
The Capabilities<CoinType> should be under the signer after creating;


<pre><code><b>include</b> <a href="coin.md#0x1_coin_InitializeInternalSchema">coin::InitializeInternalSchema</a>&lt;CoinType&gt;;
<b>aborts_if</b> !<a href="../../aptos-stdlib/../move-stdlib/doc/string.md#0x1_string_spec_internal_check_utf8">string::spec_internal_check_utf8</a>(name);
<b>aborts_if</b> !<a href="../../aptos-stdlib/../move-stdlib/doc/string.md#0x1_string_spec_internal_check_utf8">string::spec_internal_check_utf8</a>(symbol);
<b>aborts_if</b> <b>exists</b>&lt;<a href="managed_coin.md#0x1_managed_coin_Capabilities">Capabilities</a>&lt;CoinType&gt;&gt;(<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(<a href="account.md#0x1_account">account</a>));
// This enforces <a id=managed_coin::high-level-spec-3.1 href="managed_coin.md#high-level-req">high-level requirement 3</a> of the <a href=managed_coin.md>managed_coin</a> module:
<b>ensures</b> <b>exists</b>&lt;<a href="managed_coin.md#0x1_managed_coin_Capabilities">Capabilities</a>&lt;CoinType&gt;&gt;(<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(<a href="account.md#0x1_account">account</a>));
</code></pre>



<a id="@Specification_1_mint"></a>

### Function `mint`


<pre><code><b>public</b> entry <b>fun</b> <a href="managed_coin.md#0x1_managed_coin_mint">mint</a>&lt;CoinType&gt;(<a href="account.md#0x1_account">account</a>: &<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">signer</a>, dst_addr: <b>address</b>, amount: u64)
</code></pre>


The Capabilities<CoinType> should not exist in the signer address.
The <code>dst_addr</code> should not be frozen.


<pre><code><b>let</b> account_addr = <a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(<a href="account.md#0x1_account">account</a>);
// This enforces <a id=high-level-spec-3.3 href="#high-level-req">high-level requirement 3</a>:
<b>aborts_if</b> !<b>exists</b>&lt;<a href="managed_coin.md#0x1_managed_coin_Capabilities">Capabilities</a>&lt;CoinType&gt;&gt;(account_addr);
<b>let</b> addr = <a href="../../aptos-stdlib/doc/type_info.md#0x1_type_info_type_of">type_info::type_of</a>&lt;CoinType&gt;().account_address;
<b>aborts_if</b> (amount != 0) && !<b>exists</b>&lt;<a href="coin.md#0x1_coin_CoinInfo">coin::CoinInfo</a>&lt;CoinType&gt;&gt;(addr);
<b>let</b> coin_store = <b>global</b>&lt;<a href="coin.md#0x1_coin_CoinStore">coin::CoinStore</a>&lt;CoinType&gt;&gt;(dst_addr);
<b>aborts_if</b> !<b>exists</b>&lt;<a href="coin.md#0x1_coin_CoinStore">coin::CoinStore</a>&lt;CoinType&gt;&gt;(dst_addr);
<b>aborts_if</b> coin_store.frozen;
<b>include</b> <a href="coin.md#0x1_coin_CoinAddAbortsIf">coin::CoinAddAbortsIf</a>&lt;CoinType&gt;;
<b>ensures</b> <a href="coin.md#0x1_coin_supply">coin::supply</a>&lt;CoinType&gt; == <b>old</b>(<a href="coin.md#0x1_coin_supply">coin::supply</a>&lt;CoinType&gt;) + amount;
<b>ensures</b> <b>global</b>&lt;<a href="coin.md#0x1_coin_CoinStore">coin::CoinStore</a>&lt;CoinType&gt;&gt;(dst_addr).<a href="coin.md#0x1_coin">coin</a>.value == <b>old</b>(<b>global</b>&lt;<a href="coin.md#0x1_coin_CoinStore">coin::CoinStore</a>&lt;CoinType&gt;&gt;(dst_addr)).<a href="coin.md#0x1_coin">coin</a>.value + amount;
</code></pre>



<a id="@Specification_1_register"></a>

### Function `register`


<pre><code><b>public</b> entry <b>fun</b> <a href="managed_coin.md#0x1_managed_coin_register">register</a>&lt;CoinType&gt;(<a href="account.md#0x1_account">account</a>: &<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">signer</a>)
</code></pre>


An account can only be registered once.
Updating <code>Account.guid_creation_num</code> will not overflow.


<pre><code><b>let</b> account_addr = <a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(<a href="account.md#0x1_account">account</a>);
<b>let</b> acc = <b>global</b>&lt;<a href="account.md#0x1_account_Account">account::Account</a>&gt;(account_addr);
<b>aborts_if</b> !<b>exists</b>&lt;<a href="coin.md#0x1_coin_CoinStore">coin::CoinStore</a>&lt;CoinType&gt;&gt;(account_addr) && acc.guid_creation_num + 2 &gt;= <a href="account.md#0x1_account_MAX_GUID_CREATION_NUM">account::MAX_GUID_CREATION_NUM</a>;
<b>aborts_if</b> !<b>exists</b>&lt;<a href="coin.md#0x1_coin_CoinStore">coin::CoinStore</a>&lt;CoinType&gt;&gt;(account_addr) && acc.guid_creation_num + 2 &gt; MAX_U64;
<b>aborts_if</b> !<b>exists</b>&lt;<a href="coin.md#0x1_coin_CoinStore">coin::CoinStore</a>&lt;CoinType&gt;&gt;(account_addr) && !<b>exists</b>&lt;<a href="account.md#0x1_account_Account">account::Account</a>&gt;(account_addr);
<b>aborts_if</b> !<b>exists</b>&lt;<a href="coin.md#0x1_coin_CoinStore">coin::CoinStore</a>&lt;CoinType&gt;&gt;(account_addr) && !<a href="../../aptos-stdlib/doc/type_info.md#0x1_type_info_spec_is_struct">type_info::spec_is_struct</a>&lt;CoinType&gt;();
<b>ensures</b> <b>exists</b>&lt;<a href="coin.md#0x1_coin_CoinStore">coin::CoinStore</a>&lt;CoinType&gt;&gt;(account_addr);
</code></pre>


[move-book]: https://aptos.dev/move/book/SUMMARY

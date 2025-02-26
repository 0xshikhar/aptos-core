
<a id="0x1_chain_id"></a>

# Module `0x1::chain_id`

The chain id distinguishes between different chains (e.g., testnet and the main network).
One important role is to prevent transactions intended for one chain from being executed on another.
This code provides a container for storing a chain id and functions to initialize and get it.


-  [Resource `ChainId`](#0x1_chain_id_ChainId)
-  [Function `initialize`](#0x1_chain_id_initialize)
-  [Function `get`](#0x1_chain_id_get)
-  [Specification](#@Specification_0)
    -  [Module-level Specification](#@Module-level_Specification_1)
    -  [Function `initialize`](#@Specification_0_initialize)
    -  [Function `get`](#@Specification_0_get)


<pre><code><b>use</b> <a href="system_addresses.md#0x1_system_addresses">0x1::system_addresses</a>;
</code></pre>



<a id="0x1_chain_id_ChainId"></a>

## Resource `ChainId`



<pre><code><b>struct</b> <a href="chain_id.md#0x1_chain_id_ChainId">ChainId</a> <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>id: u8</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a id="0x1_chain_id_initialize"></a>

## Function `initialize`

Only called during genesis.
Publish the chain ID <code>id</code> of this instance under the SystemAddresses address


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="chain_id.md#0x1_chain_id_initialize">initialize</a>(aptos_framework: &<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">signer</a>, id: u8)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="chain_id.md#0x1_chain_id_initialize">initialize</a>(aptos_framework: &<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">signer</a>, id: u8) {
    <a href="system_addresses.md#0x1_system_addresses_assert_aptos_framework">system_addresses::assert_aptos_framework</a>(aptos_framework);
    <b>move_to</b>(aptos_framework, <a href="chain_id.md#0x1_chain_id_ChainId">ChainId</a> { id })
}
</code></pre>



</details>

<a id="0x1_chain_id_get"></a>

## Function `get`

Return the chain ID of this instance.


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="chain_id.md#0x1_chain_id_get">get</a>(): u8
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b> <b>fun</b> <a href="chain_id.md#0x1_chain_id_get">get</a>(): u8 <b>acquires</b> <a href="chain_id.md#0x1_chain_id_ChainId">ChainId</a> {
    <b>borrow_global</b>&lt;<a href="chain_id.md#0x1_chain_id_ChainId">ChainId</a>&gt;(@aptos_framework).id
}
</code></pre>



</details>

<a id="@Specification_0"></a>

## Specification


<a id="@Module-level_Specification_1"></a>

### Module-level Specification



<pre><code><b>pragma</b> verify = <b>true</b>;
<b>pragma</b> aborts_if_is_strict;
</code></pre>



<a id="@Specification_0_initialize"></a>

### Function `initialize`


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="chain_id.md#0x1_chain_id_initialize">initialize</a>(aptos_framework: &<a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer">signer</a>, id: u8)
</code></pre>




<pre><code><b>let</b> addr = <a href="../../aptos-stdlib/../move-stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(aptos_framework);
<b>aborts_if</b> addr != @aptos_framework;
<b>aborts_if</b> <b>exists</b>&lt;<a href="chain_id.md#0x1_chain_id_ChainId">ChainId</a>&gt;(@aptos_framework);
<b>ensures</b> <b>exists</b>&lt;<a href="chain_id.md#0x1_chain_id_ChainId">ChainId</a>&gt;(addr);
<b>ensures</b> <b>global</b>&lt;<a href="chain_id.md#0x1_chain_id_ChainId">ChainId</a>&gt;(addr).id == id;
</code></pre>



<a id="@Specification_0_get"></a>

### Function `get`


<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="chain_id.md#0x1_chain_id_get">get</a>(): u8
</code></pre>




<pre><code><b>aborts_if</b> !<b>exists</b>&lt;<a href="chain_id.md#0x1_chain_id_ChainId">ChainId</a>&gt;(@aptos_framework);
</code></pre>


[move-book]: https://aptos.dev/move/book/SUMMARY

spec aptos_framework::chain_id {
    spec module {
        pragma verify = true;
        pragma aborts_if_is_strict;
    }

    spec initialize {
        use std::signer;
        let addr = signer::address_of(aptos_framework);
        aborts_if addr != @aptos_framework;
        aborts_if exists<ChainId>(@aptos_framework);
        ensures exists<ChainId>(addr);
        ensures global<ChainId>(addr).id == id;
    }

    spec get {
        aborts_if !exists<ChainId>(@aptos_framework);
    }
}

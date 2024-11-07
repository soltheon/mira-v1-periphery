script;

use interfaces::{data_structures::PoolId, mira_amm::MiraAMM};
use math::pool_math::get_amounts_out;
use utils::blockchain_utils::check_deadline;
use std::{
    asset::{transfer},
    context::{
        msg_amount,
        balance_of,
    },
    bytes::Bytes
};


configurable {
    AMM_CONTRACT_ID: ContractId = ContractId::zero(),
}

pub enum SwapError {
    OutputInsufficient: ((u64, u64)),
    Something: ()
}

fn main(
    amount_in: u64,
    amount_out_min: u64,
    pools: Vec<PoolId>,
    path: Vec<AssetId>,
    amounts_out_min_0: Vec<u64>,
    amounts_out_min_1: Vec<u64>,
    recipient: Identity,
    deadline: u32,
) -> Result<u64,SwapError> {


    check_deadline(deadline);

    let token_out = path.get(path.len() - 1).unwrap();
    let balance_before  = balance_of(AMM_CONTRACT_ID, token_out);

    transfer(Identity::ContractId(AMM_CONTRACT_ID), path.get(0).unwrap(), amount_in);
    let amm = abi(MiraAMM, AMM_CONTRACT_ID.into());


    let mut i = 0;
    while i < pools.len() {
        let pool_id = pools.get(i).unwrap();

        let to = if i == pools.len() - 1 {
            recipient
        } else {
            Identity::ContractId(AMM_CONTRACT_ID)
        };

        amm.swap(pool_id, amounts_out_min_0.get(i).unwrap(), amounts_out_min_1.get(i).unwrap(), to, Bytes::new());
        i += 1;
    }

    let balance_after = balance_of(AMM_CONTRACT_ID, token_out);

    // revert if too much of output token is still in contract
    if balance_after > balance_before - amount_out_min {
        return Err(SwapError::OutputInsufficient(
        (balance_after - balance_before, amount_out_min)));
    }

    Ok(balance_before - balance_after)
}

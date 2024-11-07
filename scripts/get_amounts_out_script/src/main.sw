script;

use interfaces::{data_structures::PoolId, mira_amm::MiraAMM};
use math::pool_math::get_amounts_out_multiple_in;

configurable {
    AMM_CONTRACT_ID: ContractId = ContractId::zero(),
}

// TODO: pass in amounts_out to save gas
fn main(
    amounts_in: Vec<u64>,
    assets_in: Vec<AssetId>,
    pools: Vec<PoolId>,
) -> Vec<u64> {
    let amounts_out = get_amounts_out_multiple_in(AMM_CONTRACT_ID, amounts_in, assets_in, pools);
    amounts_out
}

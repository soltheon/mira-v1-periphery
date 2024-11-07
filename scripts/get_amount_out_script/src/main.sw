script;

use interfaces::{data_structures::PoolId, mira_amm::MiraAMM};
use math::pool_math::get_amounts_out;

configurable {
    AMM_CONTRACT_ID: ContractId = ContractId::zero(),
}

fn main(
    amount_in: u64,
    asset_in: AssetId,
    pools: Vec<PoolId>,
) -> Vec<u64> {
    let amounts_out = get_amounts_out(AMM_CONTRACT_ID, amount_in, asset_in, pools);

    let mut amounts_out_u64s = Vec::new();
    for amount in amounts_out.iter() {
        amounts_out_u64s.push(amount.0);
    }
    amounts_out_u64s

}

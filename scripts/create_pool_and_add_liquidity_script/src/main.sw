script;

use interfaces::{data_structures::{Asset, PoolId}, mira_amm::MiraAMM};
use std::asset::transfer;
use utils::blockchain_utils::check_deadline;

configurable {
    AMM_CONTRACT_ID: ContractId = ContractId::from(0x0000000000000000000000000000000000000000000000000000000000000000),
}

fn main(
    pool_id: PoolId,
    amount_0_desired: u64,
    amount_1_desired: u64,
    recipient: Identity,
    deadline: u32,
) -> Asset {
    check_deadline(deadline);
    let amm = abi(MiraAMM, AMM_CONTRACT_ID.into());

    require(amm.pool_metadata(pool_id).is_none(), "Pool already exists");

    transfer(
        Identity::ContractId(AMM_CONTRACT_ID),
        pool_id.0,
        amount_0_desired,
    );
    transfer(
        Identity::ContractId(AMM_CONTRACT_ID),
        pool_id.1,
        amount_1_desired,
    );

    amm.mint(pool_id, recipient)
}

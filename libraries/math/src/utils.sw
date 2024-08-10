library;

// TODO: replace strings with domain errors
pub fn quote(amount_0: u64, reserve_0: u64, reserve_1: u64) -> u64 {
    require(amount_0 > 0, "Insufficient amount");
    require(reserve_0 > 0 && reserve_1 > 0, "Insufficient liquidity");
    u64::try_from(amount_0.as_u256() * reserve_1.as_u256() / reserve_0.as_u256()).unwrap()
}

pub fn get_deposit_amounts(
    amount_0_desired: u64,
    amount_1_desired: u64,
    amount_0_min: u64,
    amount_1_min: u64,
    reserve_0: u64,
    reserve_1: u64,
) -> (u64, u64) {
    if (reserve_0 == 0 && reserve_1 == 0) {
        (amount_0_desired, amount_1_desired)
    } else {
        let amount_1_optimal = quote(amount_0_desired, reserve_0, reserve_1);
        if (amount_1_optimal <= amount_1_desired) {
            require(amount_1_optimal >= amount_1_min, "Insufficient amount");
            (amount_0_desired, amount_1_optimal)
        } else {
            let amount_0_optimal = quote(amount_1_desired, reserve_1, reserve_0);
            require(amount_0_optimal <= amount_0_desired, "Too much");
            require(amount_0_optimal >= amount_0_min, "Insufficient amount");
            (amount_0_optimal, amount_1_desired)
        }
    }
}

library;

use std::block::height;

/// Validates that the provided deadline hasn't passed yet
pub fn check_deadline(deadline: u32) {
    require(deadline > height(), "Deadline passed");
}

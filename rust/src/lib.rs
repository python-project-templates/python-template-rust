use serde::{Deserialize, Serialize};

#[derive(Clone, Debug, Deserialize, Eq, PartialEq, Serialize)]
pub struct Example {
    pub stuff: String,
}

impl Example {
    pub fn new(value: String) -> Self {
        Example { stuff: value }
    }
}

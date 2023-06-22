use pyo3::prelude::*;

mod example;

pub use example::Example;


#[pymodule]
fn rust_template(_py: Python, m: &PyModule) -> PyResult<()> {
    // Example
    m.add_class::<Example>()?;
    Ok(())
}

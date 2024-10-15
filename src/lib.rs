use pyo3::prelude::*;

mod example;

pub use example::Example;


#[pymodule]
fn python_template_rust(_py: Python, m: &Bound<PyModule>) -> PyResult<()> {
    // Example
    m.add_class::<Example>().unwrap();
    Ok(())
}

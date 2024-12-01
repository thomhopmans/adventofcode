pub fn load_data(exercise: usize) -> String {
    let base_path = env!("CARGO_MANIFEST_DIR"); // Root of the project
    let file_path = format!("{}/inputs/exercise{}.txt", base_path, exercise);
    std::fs::read_to_string(file_path).expect("Failed to read input file")
}

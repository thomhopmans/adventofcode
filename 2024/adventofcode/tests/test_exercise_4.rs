use adventofcode::exercises::exercise_4;
use adventofcode::exercises::utils;

const TEST_DATA: &str = "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX";

#[test]
fn test_a_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_4::run_a(TEST_DATA), 18);
}

#[test]
fn test_a_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_4::EXERCISE);
    assert_eq!(exercise_4::run_a(&input_data), 2554);
}

#[test]
fn test_b_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_4::run_b(TEST_DATA), 9);
}

#[test]
fn test_b_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_4::EXERCISE);
    assert_eq!(exercise_4::run_b(&input_data), 1916);
}

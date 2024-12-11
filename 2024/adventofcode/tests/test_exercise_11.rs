use adventofcode::exercises::exercise_11;
use adventofcode::exercises::utils;

const TEST_DATA: &str = "125 17";

#[test]
fn test_a_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_11::run_a(TEST_DATA), 55312);
}

#[test]
fn test_a_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_11::EXERCISE);
    assert_eq!(exercise_11::run_a(&input_data), 185894);
}

#[test]
fn test_b_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_11::EXERCISE);
    assert_eq!(exercise_11::run_b(&input_data), 221632504974231);
}

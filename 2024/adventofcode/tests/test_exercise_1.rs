use adventofcode::exercises::exercise_1;
use adventofcode::exercises::utils;

const TEST_DATA: &str = "3   4
4   3
2   5
1   3
3   9
3   3";

#[test]
fn test_1a_returns_11_for_test_data() {
    assert_eq!(exercise_1::run_a(TEST_DATA), 11);
}

#[test]
fn test_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_1::EXERCISE);
    assert_eq!(exercise_1::run_a(&input_data), 1590491);
}

#[test]
fn test_1b_returns_31_for_test_data() {
    assert_eq!(exercise_1::run_b(TEST_DATA), 31);
}

#[test]
fn test_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_1::EXERCISE);
    assert_eq!(exercise_1::run_b(&input_data), 22588371);
}

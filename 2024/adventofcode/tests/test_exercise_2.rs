use adventofcode::exercises::exercise_2;
use adventofcode::exercises::utils;

const TEST_DATA: &str = "3   4
4   3
2   5
1   3
3   9
3   3";

#[test]
fn test_2a_returns_2_for_test_data() {
    assert_eq!(exercise_2::run_a(TEST_DATA), 2);
}

#[test]
fn test_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_2::EXERCISE);
    assert_eq!(exercise_2::run_a(&input_data), 314);
}

#[test]
fn test_2b_returns_4_for_test_data() {
    assert_eq!(exercise_2::run_b(TEST_DATA), 4);
}

#[test]
fn test_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_2::EXERCISE);
    assert_eq!(exercise_2::run_b(&input_data), 373);
}

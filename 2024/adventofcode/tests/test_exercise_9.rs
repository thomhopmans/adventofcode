use adventofcode::exercises::exercise_9;
use adventofcode::exercises::utils;

const TEST_DATA: &str = "2333133121414131402";

#[test]
fn test_a_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_9::run_a(TEST_DATA), 1928);
}

#[test]
fn test_a_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_9::EXERCISE);
    assert_eq!(exercise_9::run_a(&input_data), 6334655979668);
}

#[test]
fn test_b_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_9::run_b(TEST_DATA), 2858);
}

#[test]
fn test_b_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_9::EXERCISE);
    assert_eq!(exercise_9::run_b(&input_data), 6349492251099);
}

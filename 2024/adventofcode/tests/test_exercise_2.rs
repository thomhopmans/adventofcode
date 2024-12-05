use adventofcode::exercises::exercise_2;
use adventofcode::exercises::utils;

const TEST_DATA: &str = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9";

#[test]
fn test_a_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_2::run_a(TEST_DATA), 2);
}

#[test]
fn test_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_2::EXERCISE);
    assert_eq!(exercise_2::run_a(&input_data), 314);
}

#[test]
fn test_b_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_2::run_b(TEST_DATA), 4);
}

#[test]
fn test_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_2::EXERCISE);
    assert_eq!(exercise_2::run_b(&input_data), 373);
}

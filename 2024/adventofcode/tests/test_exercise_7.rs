use adventofcode::exercises::exercise_7;
use adventofcode::exercises::utils;

const TEST_DATA: &str = "190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20";

#[test]
fn test_a_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_7::run_a(TEST_DATA), 3749);
}

#[test]
fn test_a_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_7::EXERCISE);
    assert_eq!(exercise_7::run_a(&input_data), 14711933466277);
}

#[test]
fn test_b_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_7::run_b(TEST_DATA), 11387);
}

#[test]
fn test_b_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_7::EXERCISE);
    assert_eq!(exercise_7::run_b(&input_data), 286580387663654);
}

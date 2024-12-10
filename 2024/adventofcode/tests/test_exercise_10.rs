use adventofcode::exercises::exercise_10;
use adventofcode::exercises::utils;

const TEST_DATA_SMALL: &str = "0123
1234
8765
9876";
const TEST_DATA_LARGE: &str = "89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732";

#[test]
fn test_a_returns_correct_answer_for_test_data_small() {
    assert_eq!(exercise_10::run_a(TEST_DATA_SMALL), 1);
}

#[test]
fn test_a_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_10::run_a(TEST_DATA_LARGE), 36);
}

#[test]
fn test_a_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_10::EXERCISE);
    assert_eq!(exercise_10::run_a(&input_data), 789);
}

#[test]
fn test_b_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_10::run_b(TEST_DATA_LARGE), 81);
}

#[test]
fn test_b_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_10::EXERCISE);
    assert_eq!(exercise_10::run_b(&input_data), 1735);
}

use adventofcode::exercises::exercise_3;
use adventofcode::exercises::utils;

const TEST_DATA_A: &str = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))";
const TEST_DATA_B: &str =
    "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))";

#[test]
fn test_2a_returns_2_for_test_data() {
    assert_eq!(exercise_3::run_a(TEST_DATA_A), 161);
}

#[test]
fn test_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_3::EXERCISE);
    assert_eq!(exercise_3::run_a(&input_data), 184511516);
}

#[test]
fn test_2b_returns_4_for_test_data() {
    assert_eq!(exercise_3::run_b(TEST_DATA_B), 48);
}

#[test]
fn test_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_3::EXERCISE);
    assert_eq!(exercise_3::run_b(&input_data), 90044227);
}

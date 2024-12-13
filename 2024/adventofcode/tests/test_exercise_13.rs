use adventofcode::exercises::exercise_13;
use adventofcode::exercises::utils;

const TEST_DATA: &str = "Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279";

#[test]
fn test_a_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_13::run_a(TEST_DATA), 480);
}

#[test]
fn test_a_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_13::EXERCISE);
    assert_eq!(exercise_13::run_a(&input_data), 28262);
}

#[test]
fn test_b_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_13::EXERCISE);
    assert_eq!(exercise_13::run_b(&input_data), 101406661266314);
}

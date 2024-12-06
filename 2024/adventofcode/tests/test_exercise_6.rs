use adventofcode::exercises::exercise_6;
use adventofcode::exercises::utils;

const TEST_DATA: &str = "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...";

#[test]
fn test_a_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_6::run_a(TEST_DATA), 41);
}

#[test]
fn test_a_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_6::EXERCISE);
    assert_eq!(exercise_6::run_a(&input_data), 5208);
}

#[test]
fn test_b_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_6::run_b(TEST_DATA), 6);
}

#[test]
fn test_b_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_6::EXERCISE);
    assert_eq!(exercise_6::run_b(&input_data), 1972);
}

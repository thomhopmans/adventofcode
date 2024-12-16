use adventofcode::exercises::exercise_16;
use adventofcode::exercises::utils;

const TEST_DATA_1: &str = "###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############";

#[test]
fn test_a_returns_correct_answer_for_test_data_1() {
    assert_eq!(exercise_16::run_a(TEST_DATA_1), 7036);
}

#[test]
fn test_a_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_16::EXERCISE);
    assert_eq!(exercise_16::run_a(&input_data), 108504);
}

#[test]
fn test_b_returns_correct_answer_for_test_data_1() {
    assert_eq!(exercise_16::run_b(TEST_DATA_1), 45);
}

#[test]
fn test_b_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_16::EXERCISE);
    assert_eq!(exercise_16::run_b(&input_data), 538);
}

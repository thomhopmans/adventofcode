use adventofcode::exercises::exercise_8;
use adventofcode::exercises::utils;

const TEST_DATA: &str = "............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............";

#[test]
fn test_a_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_8::run_a(TEST_DATA), 14);
}

#[test]
fn test_a_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_8::EXERCISE);
    assert_eq!(exercise_8::run_a(&input_data), 278);
}

#[test]
fn test_b_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_8::run_b(TEST_DATA), 34);
}

#[test]
fn test_b_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_8::EXERCISE);
    assert_eq!(exercise_8::run_b(&input_data), 1067);
}

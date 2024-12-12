use adventofcode::exercises::exercise_12;
use adventofcode::exercises::utils;

const TEST_DATA_SMALL: &str = "AAAA
BBCD
BBCC
EEEC";

const TEST_DATA_MEDIUM: &str = "OOOOO
OXOXO
OOOOO
OXOXO
OOOOO";

const TEST_DATA_LARGE: &str = "RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE";

const TEST_DATA_MEDIUM_2: &str = "EEEEE
EXXXX
EEEEE
EXXXX
EEEEE";

const TEST_DATA_MEDIUM_3: &str = "AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA";

#[test]
fn test_a_returns_correct_answer_for_test_data_small() {
    assert_eq!(exercise_12::run_a(TEST_DATA_SMALL), 140);
}

#[test]
fn test_a_returns_correct_answer_for_test_data_medium() {
    assert_eq!(exercise_12::run_a(TEST_DATA_MEDIUM), 772);
}

#[test]
fn test_a_returns_correct_answer_for_test_data_large() {
    assert_eq!(exercise_12::run_a(TEST_DATA_LARGE), 1930);
}

#[test]
fn test_a_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_12::EXERCISE);
    assert_eq!(exercise_12::run_a(&input_data), 1431316);
}

#[test]
fn test_b_returns_correct_answer_for_test_data_small() {
    assert_eq!(exercise_12::run_b(TEST_DATA_SMALL), 80);
}

#[test]
fn test_b_returns_correct_answer_for_test_data_medium() {
    assert_eq!(exercise_12::run_b(TEST_DATA_MEDIUM), 436);
}

#[test]
fn test_b_returns_correct_answer_for_test_data_medium_2() {
    assert_eq!(exercise_12::run_b(TEST_DATA_MEDIUM_2), 236);
}

#[test]
fn test_b_returns_correct_answer_for_test_data_medium_3() {
    assert_eq!(exercise_12::run_b(TEST_DATA_MEDIUM_3), 368);
}
#[test]
fn test_b_returns_correct_answer_for_test_data_large() {
    assert_eq!(exercise_12::run_b(TEST_DATA_LARGE), 1206);
}

#[test]
fn test_b_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_12::EXERCISE);
    assert_eq!(exercise_12::run_b(&input_data), 821428);
}

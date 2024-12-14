use adventofcode::exercises::exercise_14;
use adventofcode::exercises::utils;

const TEST_DATA: &str = "p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3";

#[test]
fn test_a_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_14::run_a(TEST_DATA, 11, 7), 12);
}

#[test]
fn test_a_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_14::EXERCISE);
    assert_eq!(exercise_14::run_a(&input_data, 101, 103), 222208000);
}

#[test]
fn test_b_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_14::EXERCISE);
    assert_eq!(exercise_14::run_b(&input_data), 7623);
}

use adventofcode::exercises::exercise_5;
use adventofcode::exercises::utils;

const TEST_DATA: &str = "47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47";

#[test]
fn test_a_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_5::run_a(TEST_DATA), 143);
}

#[test]
fn test_a_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_5::EXERCISE);
    assert_eq!(exercise_5::run_a(&input_data), 4569);
}

#[test]
fn test_b_returns_correct_answer_for_test_data() {
    assert_eq!(exercise_5::run_b(TEST_DATA), 123);
}

#[test]
fn test_b_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_5::EXERCISE);
    assert_eq!(exercise_5::run_b(&input_data), 6456);
}

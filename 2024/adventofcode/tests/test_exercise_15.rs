use adventofcode::exercises::exercise_15;
use adventofcode::exercises::utils;

const TEST_DATA_SMALL_A: &str = "########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<";

const TEST_DATA_LARGE: &str = "##########
#..O..O.O#
#......O.#
#.OO..O.O#
#..O@..O.#
#O#..O...#
#O..O..O.#
#.OO.O.OO#
#....O...#
##########

<vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
<<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
>^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
<><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^";

const TEST_DATA_SMALL_B: &str = "#######
#...#.#
#.....#
#..OO@#
#..O..#
#.....#
#######

<vv<<^^<<^^";

#[test]
fn test_a_returns_correct_answer_for_test_data_small_a() {
    assert_eq!(exercise_15::run_a(TEST_DATA_SMALL_A), 2028);
}

#[test]
fn test_a_returns_correct_answer_for_test_data_large() {
    assert_eq!(exercise_15::run_a(TEST_DATA_LARGE), 10092);
}

#[test]
fn test_a_returns_correct_answer_on_exercise_a() {
    let input_data = utils::load_data(exercise_15::EXERCISE);
    assert_eq!(exercise_15::run_a(&input_data), 1437174);
}

#[test]
fn test_b_returns_correct_answer_for_test_data_small_b() {
    assert_eq!(exercise_15::run_b(TEST_DATA_SMALL_B), 618);
}

#[test]
fn test_b_returns_correct_answer_for_test_data_large() {
    assert_eq!(exercise_15::run_b(TEST_DATA_LARGE), 9021);
}

#[test]
fn test_b_returns_correct_answer_on_exercise_b() {
    let input_data = utils::load_data(exercise_15::EXERCISE);
    assert_eq!(exercise_15::run_b(&input_data), 1437468);
}

import {run23A, run23B, input23Data} from '../exercises/exercise_23';

const testData = `....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#..`;

describe('part A', () => {
  test('test string should return 110', () => {
    expect(run23A(testData)).toBe(110);
  });

  test('input string should return 3920', () => {
    expect(run23A(input23Data)).toBe(3920);
  });
});

describe('part B', () => {
  test('test string should return 20', () => {
    expect(run23B(testData)).toBe(20);
  });

  test('input string should return 889', () => {
    expect(run23B(input23Data)).toBe(889);
  });
});

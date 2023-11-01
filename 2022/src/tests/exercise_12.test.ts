import {run12A, run12B, input12Data} from '../exercises/exercise_12';

const testData = `Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi`;

describe('part A', () => {
  test('test string should return 31', () => {
    expect(run12A(testData)).toBe(31);
  });

  test('input string should return 339', () => {
    expect(run12A(input12Data)).toBe(339);
  });
});

describe('part B', () => {
  test('test string should return 29', () => {
    expect(run12B(testData)).toBe(29);
  });

  test('input string should return 332', () => {
    expect(run12B(input12Data)).toBe(332);
  });
});

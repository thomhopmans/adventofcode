import {run14A, run14B, input14Data} from '../exercises/exercise_14';

const testData = `498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9`;

describe('part A', () => {
  test('test string should return 24', () => {
    expect(run14A(testData)).toBe(24);
  });

  test('input string should return 1406', () => {
    expect(run14A(input14Data)).toBe(1406);
  });
});

describe('part B', () => {
  test('test string should return 93', () => {
    expect(run14B(testData)).toBe(93);
  });

  test('input string should return 20870', () => {
    expect(run14B(input14Data)).toBe(20870);
  });
});

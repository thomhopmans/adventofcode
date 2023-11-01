import {run1A, run1B, input1Data} from '../exercises/exercise_1';

const testData = `1000
2000
3000

4000

5000
6000

7000
8000
9000

10000`;

describe('part A', () => {
  test('test string should return 24_000', () => {
    expect(run1A(testData)).toBe(24000);
  });

  test('input string should return 69_289', () => {
    expect(run1A(input1Data)).toBe(69289);
  });
});

describe('part B', () => {
  test('test string should return 45_000', () => {
    expect(run1B(testData)).toBe(45000);
  });

  test('test string should return 205_615', () => {
    expect(run1B(input1Data)).toBe(205615);
  });
});

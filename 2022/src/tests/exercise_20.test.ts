import {run20A, run20B, input20Data} from '../exercises/exercise_20';

const testData = `1
2
-3
3
-2
0
4`;

describe('part A', () => {
  test('test string should return 3', () => {
    expect(run20A(testData)).toBe(3);
  });

  test('input string should return 13289', () => {
    expect(run20A(input20Data)).toBe(13289);
  });
});

describe('part B', () => {
  test('test string should return 1623178306', () => {
    expect(run20B(testData)).toBe(1623178306);
  });

  test('input string should return 2865721299243', () => {
    expect(run20B(input20Data)).toBe(2865721299243);
  });
});

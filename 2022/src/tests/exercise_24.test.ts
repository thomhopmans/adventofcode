import {run24A, run24B, input24Data} from '../exercises/exercise_24';

const testData = `#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#`;

describe('part A', () => {
  test('test string should return 18', () => {
    expect(run24A(testData)).toBe(18);
  });

  test('input string should return 332', () => {
    expect(run24A(input24Data)).toBe(332);
  });
});

describe('part B', () => {
  test('test string should return 54', () => {
    expect(run24B(testData)).toBe(54);
  });

  test('input string should return 942', () => {
    expect(run24B(input24Data)).toBe(942);
  });
});

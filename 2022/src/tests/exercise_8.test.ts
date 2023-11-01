import {run8A, run8B, input8Data} from '../exercises/exercise_8';

const testData = `30373
25512
65332
33549
35390`;

describe('part A', () => {
  test('test string should return 21', () => {
    expect(run8A(testData)).toBe(21);
  });

  test('input string should return 1703', () => {
    expect(run8A(input8Data)).toBe(1703);
  });
});

describe('part B', () => {
  test('test string should return 8', () => {
    expect(run8B(testData)).toBe(8);
  });

  test('test string should return 496650', () => {
    expect(run8B(input8Data)).toBe(496650);
  });
});

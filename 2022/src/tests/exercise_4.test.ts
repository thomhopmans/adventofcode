import {run4A, run4B, input4Data} from '../exercises/exercise_4';

const testData = `2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8`;

describe('part A', () => {
  test('test string should return 2', () => {
    expect(run4A(testData)).toBe(2);
  });

  test('input string should return 448', () => {
    expect(run4A(input4Data)).toBe(448);
  });
});

describe('part B', () => {
  test('test string should return 4', () => {
    expect(run4B(testData)).toBe(4);
  });

  test('test string should return 794', () => {
    expect(run4B(input4Data)).toBe(794);
  });
});

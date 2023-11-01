import {run18A, run18B, input18Data} from '../exercises/exercise_18';

const testData = `2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5`;

describe('part A', () => {
  test('test string should return 64', () => {
    expect(run18A(testData)).toBe(64);
  });

  test('input string should return 0', () => {
    expect(run18A(input18Data)).toBe(0);
  });
});

describe('part B', () => {
  test('test string should return 58', () => {
    expect(run18B(testData)).toBe(58);
  });

  test('input string should return 2572', () => {
    expect(run18B(input18Data)).toBe(2572);
  });
});

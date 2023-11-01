import {run17A, run17B, input17Data} from '../exercises/exercise_17';

const testData = `>>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>`;

describe('part A', () => {
  test('test string should return 3068', () => {
    expect(run17A(testData)).toBe(3068);
  });

  test('input string should return 3117', () => {
    expect(run17A(input17Data)).toBe(3117);
  });
});

describe('part B', () => {
  test('test string should return 1514285714288', () => {
    expect(run17B(testData)).toBe(1514285714288);
  });

  test('input string should return 1553314121019', () => {
    expect(run17B(input17Data)).toBe(1553314121019);
  });
});

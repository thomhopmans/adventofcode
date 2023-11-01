import {readFileSync} from 'fs';
import {run22A, run22B, input22Data} from '../exercises/exercise_22';

const testData = readFileSync('./inputs/input_22_test.txt', 'utf-8');

describe('part A', () => {
  test('test string should return 6032', () => {
    expect(run22A(testData)).toBe(6032);
  });

  test('input string should return 20494', () => {
    expect(run22A(input22Data)).toBe(20494);
  });
});

describe('part B', () => {
  test('test string should return 5031', () => {
    expect(run22B(testData)).toBe(5031);
  });

  test('input string should return 55343', () => {
    expect(run22B(input22Data)).toBe(55343);
  });
});

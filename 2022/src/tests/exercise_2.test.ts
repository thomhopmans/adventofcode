import {run2A, run2B, input2Data} from '../exercises/exercise_2';

const testData = `A Y
B X
C Z`;

describe('part A', () => {
  test('test string should return 15', () => {
    expect(run2A(testData)).toBe(15);
  });

  test('input string should return 15523', () => {
    expect(run2A(input2Data)).toBe(15523);
  });
});

describe('part B', () => {
  test('test string should return 12', () => {
    expect(run2B(testData)).toBe(12);
  });

  test('test string should return 15702', () => {
    expect(run2B(input2Data)).toBe(15702);
  });
});

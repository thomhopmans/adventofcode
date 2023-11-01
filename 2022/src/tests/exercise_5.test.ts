import {run5A, run5B, input5Data} from '../exercises/exercise_5';

const testData = `    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2`;

describe('part A', () => {
  test('test string should return CMZ', () => {
    expect(run5A(testData)).toBe('CMZ');
  });

  test('input string should return PSNRGBTFT', () => {
    expect(run5A(input5Data)).toBe('PSNRGBTFT');
  });
});

describe('part B', () => {
  test('test string should return MCD', () => {
    expect(run5B(testData)).toBe('MCD');
  });

  test('test string should return BNTZFPMMW', () => {
    expect(run5B(input5Data)).toBe('BNTZFPMMW');
  });
});

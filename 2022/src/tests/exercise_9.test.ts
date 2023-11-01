import {run9A, run9B, input9Data} from '../exercises/exercise_9';

const testData1 = `R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2`;

const testData2 = `R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20`;

describe('part A', () => {
  test('test string should return 13', () => {
    expect(run9A(testData1)).toBe(13);
  });

  test('input string should return 6044', () => {
    expect(run9A(input9Data)).toBe(6044);
  });
});

describe('part B', () => {
  test('test string 1 should return 1', () => {
    expect(run9B(testData1)).toBe(1);
  });

  test('test string 2 should return 36', () => {
    expect(run9B(testData2)).toBe(36);
  });

  test('test string should return 2384', () => {
    expect(run9B(input9Data)).toBe(2384);
  });
});

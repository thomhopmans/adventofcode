import {run3A, run3B, input3Data} from '../exercises/exercise_3';

const testData = `vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw`;

describe('part A', () => {
  test('test string should return 157', () => {
    expect(run3A(testData)).toBe(157);
  });

  test('input string should return 7817', () => {
    expect(run3A(input3Data)).toBe(7817);
  });
});

describe('part B', () => {
  test('test string should return 70', () => {
    expect(run3B(testData)).toBe(70);
  });

  test('test string should return 2444', () => {
    expect(run3B(input3Data)).toBe(2444);
  });
});

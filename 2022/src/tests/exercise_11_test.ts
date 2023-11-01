import {run11A, run11B, input11Data} from '../exercises/exercise_11';

const testData = `Monkey 0:
Starting items: 79, 98
Operation: new = old * 19
Test: divisible by 23
  If true: throw to monkey 2
  If false: throw to monkey 3

Monkey 1:
Starting items: 54, 65, 75, 74
Operation: new = old + 6
Test: divisible by 19
  If true: throw to monkey 2
  If false: throw to monkey 0

Monkey 2:
Starting items: 79, 60, 97
Operation: new = old * old
Test: divisible by 13
  If true: throw to monkey 1
  If false: throw to monkey 3

Monkey 3:
Starting items: 74
Operation: new = old + 3
Test: divisible by 17
  If true: throw to monkey 0
  If false: throw to monkey 1`;

describe('part A', () => {
  test('test string should return 10605', () => {
    expect(run11A(testData)).toBe(10605);
  });

  test('input string should return 117624', () => {
    expect(run11A(input11Data)).toBe(117624);
  });
});

describe('part B', () => {
  test('test string should return 2713310158', () => {
    expect(run11B(testData)).toBe(2713310158);
  });

  test('input string should return 16792940265', () => {
    expect(run11B(input11Data)).toBe(16792940265);
  });
});

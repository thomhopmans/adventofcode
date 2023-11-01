import {run19A, run19B, input19Data} from '../exercises/exercise_19';

const testData = `Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.`;

describe('part A', () => {
  test('test string should return 33', () => {
    expect(run19A(testData)).toBe(33);
  });

  test('input string should return 2341', () => {
    expect(run19A(input19Data)).toBe(2341);
  });
});

describe('part B', () => {
  test('test string should return 62', () => {
    expect(run19B(testData)).toBe(62);
  });

  test('input string should return 3689', () => {
    expect(run19B(input19Data)).toBe(3689);
  });
});

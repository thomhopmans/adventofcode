import {run16A, run16B, input16Data} from '../exercises/exercise_16';

const testData = `Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II`;

describe('part A', () => {
  test('test string should return 1651', () => {
    expect(run16A(testData)).toBe(1651);
  });

  test('input string should return 2359', () => {
    expect(run16A(input16Data)).toBe(2359);
  });
});

describe('part B', () => {
  test('test string should return 1707', () => {
    expect(run16B(testData)).toBe(1707);
  });

  test('input string should return 2999', () => {
    expect(run16B(input16Data)).toBe(2999);
  });
});

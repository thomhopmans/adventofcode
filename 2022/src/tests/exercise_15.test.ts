import {run15A, run15B, input15Data} from '../exercises/exercise_15';

const testData = `Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3`;

describe('part A', () => {
  test('test string should return 26', () => {
    expect(run15A(testData, 10)).toBe(26);
  });

  test('input string should return 5461729', () => {
    expect(run15A(input15Data, 2000000)).toBe(5461729);
  });
});

describe('part B', () => {
  test('test string should return 56000011', () => {
    expect(run15B(testData, 20)).toBe(56000011);
  });

  test('input string should return 10621647166538', () => {
    expect(run15B(input15Data, 4000000)).toBe(10621647166538);
  });
});

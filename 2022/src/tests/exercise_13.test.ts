import {run13A, run13B, input13Data} from '../exercises/exercise_13';

const testData = `[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]`;

describe('part A', () => {
  test('test string should return 13', () => {
    expect(run13A(testData)).toBe(13);
  });

  test('input string should return 6484', () => {
    expect(run13A(input13Data)).toBe(6484);
  });
});

describe('part B', () => {
  test('test string should return 140', () => {
    expect(run13B(testData)).toBe(140);
  });

  test('input string should return 19305', () => {
    expect(run13B(input13Data)).toBe(19305);
  });
});

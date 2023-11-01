import {run25A, input25Data} from '../exercises/exercise_25';

const testData = `1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122`;

describe('part A', () => {
  test('test string should return "2=-1=0"', () => {
    expect(run25A(testData)).toBe('2=-1=0');
  });

  test('input string should return "2---1010-0=1220-=010', () => {
    expect(run25A(input25Data)).toBe('2---1010-0=1220-=010');
  });
});

import {run21A, run21B, input21Data} from '../exercises/exercise_21';

const testData = `root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32`;

describe('part A', () => {
  test('test string should return 152', () => {
    expect(run21A(testData)).toBe(152);
  });

  test('input string should return 124765768589550', () => {
    expect(run21A(input21Data)).toBe(124765768589550);
  });
});

describe('part B', () => {
  test('test string should return 301', () => {
    expect(run21B(testData)).toBe(301);
  });

  test('input string should return 3059361893920', () => {
    expect(run21B(input21Data)).toBe(3059361893920);
  });
});

import {run6A, run6B, input6Data} from '../exercises/exercise_6';

const testData1 = 'mjqjpqmgbljsphdztnvjfqwrcgsmlb';
const testData2 = 'bvwbjplbgvbhsrlpgdmjqwftvncz';
const testData3 = 'nppdvjthqldpwncqszvftbrmjlhg';
const testData4 = 'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg';
const testData5 = 'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw';

describe('part A', () => {
  test('test string 1 should return ', () => {
    expect(run6A(testData1)).toBe(7);
  });

  test('test string 2 should return ', () => {
    expect(run6A(testData2)).toBe(5);
  });

  test('test string 3 should return ', () => {
    expect(run6A(testData3)).toBe(6);
  });

  test('test string 4 should return ', () => {
    expect(run6A(testData4)).toBe(10);
  });

  test('test string 5 should return ', () => {
    expect(run6A(testData5)).toBe(11);
  });

  test('input string should return 1210', () => {
    expect(run6A(input6Data)).toBe(1210);
  });
});

describe('part B', () => {
  test('test string 1 should return ', () => {
    expect(run6B(testData1)).toBe(19);
  });

  test('test string 2 should return ', () => {
    expect(run6B(testData2)).toBe(23);
  });

  test('test string 3 should return ', () => {
    expect(run6B(testData3)).toBe(23);
  });

  test('test string 4 should return ', () => {
    expect(run6B(testData4)).toBe(29);
  });

  test('test string 5 should return ', () => {
    expect(run6B(testData5)).toBe(26);
  });

  test('test string should return 3476', () => {
    expect(run6B(input6Data)).toBe(3476);
  });
});

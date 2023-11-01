import {run7A, run7B, input7Data} from '../exercises/exercise_7';

const testData = `$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k`;

describe('part A', () => {
  test('test string should return 95437', () => {
    expect(run7A(testData)).toBe(95437);
  });

  test('input string should return 1743217', () => {
    expect(run7A(input7Data)).toBe(1743217);
  });
});

describe('part B', () => {
  test('test string should return 24933642', () => {
    expect(run7B(testData)).toBe(24933642);
  });

  test('test string should return 8319096', () => {
    expect(run7B(input7Data)).toBe(8319096);
  });
});

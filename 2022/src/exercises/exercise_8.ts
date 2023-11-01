import {readFileSync} from 'fs';

function run8A(data: string) {
  const treeGrid = data.split('\n').map(i => i.split('').map(i => parseInt(i)));
  const nLines = treeGrid.length;

  const exteriorVisible = 4 * (nLines - 1);
  let interiorVisible = 0;

  let tree;

  for (let x = 1; x < nLines - 1; x++) {
    for (let y = 1; y < nLines - 1; y++) {
      tree = treeGrid[x][y];

      // Sides
      const top = getTreesBetween(treeGrid, [0, y], [x - 1, y]);
      const bottom = getTreesBetween(treeGrid, [x + 1, y], [nLines - 1, y]);
      const left = getTreesBetween(treeGrid, [x, 0], [x, y - 1]);
      const right = getTreesBetween(treeGrid, [x, y + 1], [x, nLines - 1]);

      // Min Max over Sides
      const minMaxPerSide = Math.min(
        ...[
          Math.max(...top),
          Math.max(...right),
          Math.max(...bottom),
          Math.max(...left),
        ].filter(i => i !== -Infinity)
      );

      const isVisible = tree > minMaxPerSide;

      if (isVisible === true) {
        interiorVisible += 1;
      }
    }
  }
  return exteriorVisible + interiorVisible;
}

function getTreesBetween(
  treeGrid: Array<Array<number>>,
  XY: number[],
  otherXY: number[]
) {
  const results = [];
  for (let xx = XY[0]; xx <= otherXY[0]; xx++) {
    for (let yy = XY[1]; yy <= otherXY[1]; yy++) {
      results.push(treeGrid[xx][yy]);
    }
  }
  return results;
}

function run8B(data: string) {
  const treeGrid = data.split('\n').map(i => i.split('').map(i => parseInt(i)));
  const nLines = treeGrid.length;

  let maxScenicScore = 0;
  let tree;

  for (let x = 1; x < nLines - 1; x++) {
    for (let y = 1; y < nLines - 1; y++) {
      tree = treeGrid[x][y];

      // Sides
      const top = getTreesBetween(treeGrid, [0, y], [x - 1, y]).reverse();
      const bottom = getTreesBetween(treeGrid, [x + 1, y], [nLines - 1, y]);
      const left = getTreesBetween(treeGrid, [x, 0], [x, y - 1]).reverse();
      const right = getTreesBetween(treeGrid, [x, y + 1], [x, nLines - 1]);

      // Calculate scenic score
      const scenicScore =
        takeFirstElementSmallerThan(top, tree) *
        takeFirstElementSmallerThan(bottom, tree) *
        takeFirstElementSmallerThan(left, tree) *
        takeFirstElementSmallerThan(right, tree);

      if (scenicScore > maxScenicScore) {
        maxScenicScore = scenicScore;
      }
    }
  }

  return maxScenicScore;
}

const BreakError = {};

function takeFirstElementSmallerThan(values: number[], limit: number): number {
  const results: number[] = [];

  try {
    values.forEach(i => {
      if (i < limit) {
        results.push(i);
      } else {
        results.push(i);
        throw BreakError;
      }
    });
  } catch (err) {
    return results.length;
  }

  return results.length;
}
const input8Data = readFileSync('./inputs/input_8.txt', 'utf-8');

export {run8A, run8B, input8Data};

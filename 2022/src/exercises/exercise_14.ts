import {readFileSync} from 'fs';

const AIR = 0;
const ROCK = 1;
const SAND = 2;
const SAND_ENTRACE = 3;

function run14A(data: string) {
  // Rock coordinates
  const coordinates = parseCoordinates(data);

  let maxX = Math.max(...coordinates.map(i => i[0]));
  let maxY = Math.max(...coordinates.map(i => i[1])) + 3;

  let grid = toGrid(maxX, maxY, AIR);
  grid = fillGrid(grid, coordinates, ROCK);

  const unitsOfSand = dropSand(grid, coordinates, maxY);
  return unitsOfSand;
}

function parseCoordinates(data: string) {
  const paths = data
    .split('\n')
    .map(i => i.split(' -> ').map(j => j.split(',').map(k => parseInt(k))));

  let coordinates: number[][] = [];
  paths.forEach(path => {
    coordinates.push(path[0]);

    for (let i = 0; i < path.length - 1; i++) {
      let A = path[i];
      let B = path[i + 1];
      let diff = B.map((item, index) => item - A[index]);
      let factor = diff.map(x => x / Math.max(...diff.map(j => Math.abs(j))));

      let nextPoint = A.map((item, index) => item + factor[index]);
      while (eq(nextPoint, B) === false) {
        coordinates.push(nextPoint);
        nextPoint = nextPoint.map((item, index) => item + factor[index]);
      }
      coordinates.push(B);
    }
  });

  return coordinates;
}

function getDirection(grid: number[][], currentCoordinate: number[]) {
  const directions = [
    [0, 1],
    [-1, 1],
    [1, 1],
    [0, 0],
  ];

  const direction = directions.reduce((result, d) => {
    let newCoordinate = currentCoordinate.map((item, index) => item + d[index]);
    if (getGridValue(grid, newCoordinate) === AIR) {
      result.push(d);
    }
    return result;
  }, Array());

  return direction[0];
}

function toGrid(maxX: number, maxY: number, fillValue: number) {
  let grid: number[][] = [];
  for (let y = 0; y <= maxY; y++) {
    grid[y] = [];
    for (let x = 0; x <= maxX; x++) {
      grid[y][x] = fillValue;
    }
  }

  return grid;
}

function getGridValue(grid: number[][], coordinate: number[]) {
  return grid[coordinate[1]][coordinate[0]];
}

function fillGrid(
  grid: number[][],
  coordinates: number[][],
  fillValue: number
) {
  coordinates.forEach(coord => {
    grid[coord[1]][coord[0]] = fillValue;
  });
  return grid;
}

function removeFromGrid(
  grid: number[][],
  coordinates: number[][],
  fillValue: number
) {
  coordinates.forEach(coord => {
    grid[coord[1]][coord[0]] = fillValue;
  });
  return grid;
}

function run14B(data: string) {
  // Rock coordinates
  const rockCoordinates = parseCoordinates(data);

  let maxX = Math.max(...rockCoordinates.map(i => i[0]));
  let maxY = Math.max(...rockCoordinates.map(i => i[1])) + 2;

  // Add ground coordinates
  const groundCoordinates = parseCoordinates(`0,${maxY} -> 1000,${maxY}`);
  const coordinates = [...rockCoordinates, ...groundCoordinates];

  maxX = Math.max(...coordinates.map(i => i[0]));
  maxY = Math.max(...coordinates.map(i => i[1]));

  // Grid
  let grid = toGrid(maxX, maxY, AIR);
  grid = fillGrid(grid, coordinates, ROCK);
  grid = fillGrid(grid, coordinates, ROCK);

  const unitsOfSand = dropSand(grid, coordinates, maxY);

  return unitsOfSand;
}

function dropSand(grid: number[][], coordinates: number[][], maxY: number) {
  const SAND_ENTRANCE = [500, 0];
  grid = fillGrid(grid, [SAND_ENTRANCE], SAND_ENTRACE);

  let sandCoordinate = SAND_ENTRANCE;
  let unitsOfSand = 0;
  let t = 0;
  while (true === true) {
    // Move sand
    let direction = getDirection(grid, sandCoordinate);

    if (direction === undefined) {
      unitsOfSand += 1;
      break;
    } else if (eq(direction, [0, 0])) {
      grid = fillGrid(grid, [sandCoordinate], SAND);

      unitsOfSand += 1;
      sandCoordinate = SAND_ENTRANCE;
    } else if (sandCoordinate[1] === maxY - 1) {
      break;
    } else {
      sandCoordinate = sandCoordinate.map(
        (item, index) => item + direction[index]
      );
    }
    t += 1;
  }

  //   visualizeGrid(grid, [...coordinates, sandCoordinate]);

  return unitsOfSand;
}

function eq<Values>(a1: Array<Values>, a2: Array<Values>): boolean {
  if (a1.length !== a2.length) {
    return false;
  }

  /** Unique values */
  const set1 = new Set<Values>(a1);
  const set2 = new Set<Values>(a2);
  if (set1.size !== set2.size) {
    return false;
  }

  return [...set1].every(value => [...set2].includes(value));
}

function visualizeGrid(grid: number[][], coordinates: number[][]) {
  // Reduce grid
  let minX = Math.min(...coordinates.map(i => i[0]));
  const reducedGrid = grid.map(i => i.slice(minX));

  // Visualize
  for (let y = 0; y < reducedGrid.length; y++) {
    let line = '';
    for (let x = 0; x < reducedGrid[0].length; x++) {
      if (reducedGrid[y][x] === 1) {
        line += '#';
      } else if (reducedGrid[y][x] === 2) {
        line += 'O';
      } else if (reducedGrid[y][x] === 3) {
        line += '+';
      } else {
        line += '.';
      }
    }
    console.log(line);
  }
}


const input14Data = readFileSync('./inputs/input_14.txt', 'utf-8');

export {run14A, run14B, input14Data};

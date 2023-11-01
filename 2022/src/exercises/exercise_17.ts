import {readFileSync} from 'fs';

const AIR = 0;
const ROCK = 1;
const FALLING = 2;
const WALL = 3;

function run17A(data: string) {
  const patterns: number[] = parseJetPatterns(data);

  let grid = toGrid(9, 5, AIR);
  grid[5] = [WALL, ROCK, ROCK, ROCK, ROCK, ROCK, ROCK, ROCK, WALL]; // floor

  let newRock = true;
  let rockBottom = [0, 0];
  let currentRockType = 0;
  let numberOfRocks = 0;

  while (numberOfRocks < 2023 - 1) {
    if (newRock) {
      // Add more lines to top if necessary
      let highestY = highestRock(grid);
      while (highestY <= 6) {
        grid.unshift([WALL, AIR, AIR, AIR, AIR, AIR, AIR, AIR, WALL]);
        highestY = highestRock(grid);
      }

      // New rock
      currentRockType = numberOfRocks % 5;
      rockBottom = [3, highestY - 4]; // + 1 for wall
      newRock = false;
    }

    // Sideways
    let jet = patterns.shift() || 0;
    patterns.push(jet);

    if (touchesRock(grid, currentRockType, rockBottom, jet, 0) === false) {
      rockBottom[0] += jet;
    }

    // Downwards
    if (touchesRock(grid, currentRockType, rockBottom, 0, 1) === true) {
      grid = setRock(grid, currentRockType, rockBottom, ROCK);

      newRock = true;
      numberOfRocks++;
    } else {
      rockBottom[1] += 1;
    }
  }

  // visualizeGrid(grid);

  let towerHeight = grid.length - highestRock(grid) - 1;

  return towerHeight;
}

function run17B(data: string) {
  const patterns: number[] = parseJetPatterns(data);

  let grid = toGrid(9, 5, AIR);
  grid[5] = [WALL, ROCK, ROCK, ROCK, ROCK, ROCK, ROCK, ROCK, WALL]; // floor

  let newRock = true;
  let rockBottom = [0, 0];
  let currentRockType = 0;
  let numberOfRocks = 0;
  let stateMap = new Map();

  // Cycles
  let dRocks = 0;
  let dHeight = 0;
  let fullCycles = 0;

  const TOTAL_ROCKS_NEEDED = 1000000000000;
  const STATE_GRID_SIZE = 100;

  while (numberOfRocks < TOTAL_ROCKS_NEEDED) {
    // New rock
    if (newRock) {
      // Add more lines to top if necessary
      let highestY = highestRock(grid);
      while (highestY <= 6) {
        grid.unshift([WALL, AIR, AIR, AIR, AIR, AIR, AIR, AIR, WALL]);
        highestY = highestRock(grid);
      }

      // Select new rock
      currentRockType = numberOfRocks % 5;
      rockBottom = [3, highestY - 4]; // + 1 for wall
      newRock = false;
      let towerHeight = grid.length - highestRock(grid) - 1;

      // Get hash of current state
      if (grid.length > STATE_GRID_SIZE) {
        // current wind direction + current shape + top 40 rows
        let stateTopGrid = grid
          .slice(0, STATE_GRID_SIZE)
          .map(i => i.join(''))
          .join('');
        let hashState = `${patterns[0]}-${currentRockType}-${stateTopGrid}`;

        if (stateMap.get(hashState)) {
          // Check if hash is already found
          let foundHash = stateMap.get(hashState);

          // Calculate total number based on cycles
          dRocks = numberOfRocks - foundHash[0];
          dHeight = towerHeight - foundHash[1];
          fullCycles = Math.floor(
            (TOTAL_ROCKS_NEEDED - numberOfRocks - 2) / dRocks
          );
          numberOfRocks = numberOfRocks + fullCycles * dRocks;

          newRock = true;
          stateMap = new Map();

          continue;
        } else {
          stateMap.set(hashState, [numberOfRocks, towerHeight]);
        }
      }
    }

    // Sideways
    let jet = patterns.shift() || 0;
    patterns.push(jet);

    if (touchesRock(grid, currentRockType, rockBottom, jet, 0) === false) {
      rockBottom[0] += jet;
    }

    // Downwards
    if (touchesRock(grid, currentRockType, rockBottom, 0, 1) === true) {
      // Hit rock, finalize rock
      grid = setRock(grid, currentRockType, rockBottom, ROCK);

      newRock = true;
      numberOfRocks++;
    } else {
      // Move falling rock one down
      rockBottom[1] += 1;
    }
  }

  let towerHeight = grid.length - highestRock(grid) - 1;

  return towerHeight + fullCycles * dHeight;
}

function touchesRock(
  grid: number[][],
  rockType: number,
  rockBottom: number[],
  xOffset: number,
  yOffset: number
) {
  let bottomX = rockBottom[0] + xOffset;
  let bottomY = rockBottom[1] + yOffset;
  if (rockType === 0) {
    // ####
    return (
      grid[bottomY][bottomX] !== AIR ||
      grid[bottomY][bottomX + 1] !== AIR ||
      grid[bottomY][bottomX + 2] !== AIR ||
      grid[bottomY][bottomX + 3] !== AIR
    );
  } else if (rockType === 1) {
    // .#.
    // ###
    // .#.
    return (
      grid[bottomY][bottomX + 1] !== AIR ||
      grid[bottomY - 1][bottomX] !== AIR ||
      grid[bottomY - 1][bottomX + 1] !== AIR ||
      grid[bottomY - 1][bottomX + 2] !== AIR ||
      grid[bottomY - 2][bottomX + 1] !== AIR
    );
  } else if (rockType === 2) {
    // ..#
    // ..#
    // ###
    return (
      grid[bottomY][bottomX] !== AIR ||
      grid[bottomY][bottomX + 1] !== AIR ||
      grid[bottomY][bottomX + 2] !== AIR ||
      grid[bottomY - 1][bottomX + 2] !== AIR ||
      grid[bottomY - 2][bottomX + 2] !== AIR
    );
  } else if (rockType === 3) {
    // #
    // #
    // #
    // #
    return (
      grid[bottomY][bottomX] !== AIR ||
      grid[bottomY - 1][bottomX] !== AIR ||
      grid[bottomY - 2][bottomX] !== AIR ||
      grid[bottomY - 3][bottomX] !== AIR
    );
  } else if (rockType === 4) {
    // ##
    // ##
    return (
      grid[bottomY][bottomX] !== AIR ||
      grid[bottomY][bottomX + 1] !== AIR ||
      grid[bottomY - 1][bottomX] !== AIR ||
      grid[bottomY - 1][bottomX + 1] !== AIR
    );
  }

  throw Error;
}

function setRock(
  grid: number[][],
  rockType: number,
  rockBottom: number[],
  fillValue: number
) {
  let bottomX = rockBottom[0];
  let bottomY = rockBottom[1];
  if (rockType === 0) {
    // ####
    grid[bottomY][bottomX] = fillValue;
    grid[bottomY][bottomX + 1] = fillValue;
    grid[bottomY][bottomX + 2] = fillValue;
    grid[bottomY][bottomX + 3] = fillValue;
  } else if (rockType === 1) {
    // .#.
    // ###
    // .#.
    grid[bottomY][bottomX + 1] = fillValue;
    grid[bottomY - 1][bottomX] = fillValue;
    grid[bottomY - 1][bottomX + 1] = fillValue;
    grid[bottomY - 1][bottomX + 2] = fillValue;
    grid[bottomY - 2][bottomX + 1] = fillValue;
  } else if (rockType === 2) {
    // ..#
    // ..#
    // ###
    grid[bottomY][bottomX] = fillValue;
    grid[bottomY][bottomX + 1] = fillValue;
    grid[bottomY][bottomX + 2] = fillValue;
    grid[bottomY - 1][bottomX + 2] = fillValue;
    grid[bottomY - 2][bottomX + 2] = fillValue;
  } else if (rockType === 3) {
    // #
    // #
    // #
    // #
    grid[bottomY][bottomX] = fillValue;
    grid[bottomY - 1][bottomX] = fillValue;
    grid[bottomY - 2][bottomX] = fillValue;
    grid[bottomY - 3][bottomX] = fillValue;
  } else if (rockType === 4) {
    // ##
    // ##
    grid[bottomY][bottomX] = fillValue;
    grid[bottomY][bottomX + 1] = fillValue;
    grid[bottomY - 1][bottomX] = fillValue;
    grid[bottomY - 1][bottomX + 1] = fillValue;
  }

  return grid;
}

function highestRock(grid: number[][]): number {
  let y = 0;
  while (Math.max(...grid[y].slice(1, 8)) === 0) {
    y += 1;
  }
  return y;
}

function parseJetPatterns(data: string) {
  return data.split('').map(i => (i === '>' ? 1 : -1));
}

function toGrid(maxX: number, maxY: number, fillValue: number) {
  let grid: number[][] = [];
  for (let y = 0; y < maxY; y++) {
    grid[y] = [];
    grid[y][0] = WALL;
    for (let x = 1; x < maxX - 1; x++) {
      grid[y][x] = fillValue;
    }
    grid[y][maxX - 1] = WALL;
  }
  return grid;
}

function visualizeGrid(grid: number[][]) {
  // Visualize
  for (let y = 0; y < grid.length - 1; y++) {
    let line = '';
    for (let x = 0; x < grid[0].length; x++) {
      if (grid[y][x] === AIR) {
        line += '.';
      } else if (grid[y][x] === ROCK) {
        line += '#';
      } else if (grid[y][x] === FALLING) {
        line += '@';
      } else if (grid[y][x] === WALL) {
        line += '|';
      }
    }
    console.log(line);
  }
  console.log('+-------+');
}

const input17Data = readFileSync('./inputs/input_17.txt', 'utf-8');

export {run17A, run17B, input17Data};

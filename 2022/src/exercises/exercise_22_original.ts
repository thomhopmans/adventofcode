import {readFileSync} from 'fs';

const OB = ' ';
const EMPTY = '.';
const WALL = '#';
const LEFT = [-1, 0];
const RIGHT = [1, 0];
const UP = [0, -1];
const DOWN = [0, 1];

function run22A(data: string) {
  const [fullGrid, instructions] = parseGridAndInstructions(data);

  const maxX = fullGrid[0].length;
  const maxY = fullGrid.length;

  // Start pos
  let currentPos = [0, 0];
  currentPos[0] = fullGrid[0].indexOf(EMPTY);

  let currentDirection = RIGHT;
  instructions.forEach(operation => {
    if (operation != 'R' && operation != 'L') {
      // Steps
      let steps = parseInt(operation);
      for (let s = 1; s <= steps; s++) {
        let nextPos = currentPos.map((x, index) => x + currentDirection[index]);

        // Move to right is off grid?
        if (currentDirection === RIGHT) {
          if (nextPos[0] >= maxX || fullGrid[nextPos[1]][nextPos[0]] === OB) {
            // Find first non OB in row
            nextPos[0] = indexOf(fullGrid[nextPos[1]]);
          }
        }
        // Move to left is off grid?
        else if (currentDirection === LEFT) {
          if (nextPos[0] < 0 || fullGrid[nextPos[1]][nextPos[0]] === OB) {
            // Find last non OB in row
            nextPos[0] =
              maxX - indexOf(fullGrid[nextPos[1]].slice().reverse()) - 1;
          }
        }
        // Move to down is off grid?
        else if (currentDirection === DOWN) {
          if (nextPos[1] >= maxY || fullGrid[nextPos[1]][nextPos[0]] === OB) {
            // Find top non OB in column
            nextPos[1] = indexOf(fullGrid.map(row => row[nextPos[0]]));
          }
        }
        // Move to up is off grid?
        else if (currentDirection === UP) {
          if (nextPos[1] < 0 || fullGrid[nextPos[1]][nextPos[0]] === OB) {
            // Find bottom non OB in column
            nextPos[1] =
              maxY -
              indexOf(
                fullGrid
                  .map(row => row[nextPos[0]])
                  .slice()
                  .reverse()
              ) -
              1;
          }
        }

        // Next pos is wall?
        if (fullGrid[nextPos[1]][nextPos[0]] == WALL) {
          s = steps + 1; // Abort
          continue;
        }

        // Go to next pos
        currentPos = nextPos;
      }
    } else {
      // Rotate in-place
      currentDirection = changeDirection(operation, currentDirection);
    }
    // Auditing, log direction
  });

  // Final password
  console.log("currentDirection", currentDirection)
  const finalPassword =
    (currentPos[1] + 1) * 1000 +
    (currentPos[0] + 1) * 4 +
    facingNumber(currentDirection);

  return finalPassword;
}

function changeDirection(operation: string, currentDirection: number[]) {
  if (operation === 'L' && currentDirection === UP) {
    currentDirection = LEFT;
  } else if (operation === 'L' && currentDirection === RIGHT) {
    currentDirection = UP;
  } else if (operation === 'L' && currentDirection === DOWN) {
    currentDirection = RIGHT;
  } else if (operation === 'L' && currentDirection === LEFT) {
    currentDirection = DOWN;
  } else if (operation === 'R' && currentDirection === UP) {
    currentDirection = RIGHT;
  } else if (operation === 'R' && currentDirection === RIGHT) {
    currentDirection = DOWN;
  } else if (operation === 'R' && currentDirection === DOWN) {
    currentDirection = LEFT;
  } else if (operation === 'R' && currentDirection === LEFT) {
    currentDirection = UP;
  }
  return currentDirection;
}

function run22B(data: string) {
  const [fullGrid, instructions] = parseGridAndInstructions(data);

  const maxX = fullGrid[0].length;
  const maxY = fullGrid.length;
}

function indexOf(values: string[]) {
  let indices = [values.indexOf(EMPTY), values.indexOf(WALL)].filter(
    i => i !== -1
  );
  return Math.min(...indices);
}

function facingNumber(currentDirection: number[]) {
  if (currentDirection === RIGHT) {
    return 0;
  } else if (currentDirection === DOWN) {
    return 1;
  } else if (currentDirection === LEFT) {
    return 2;
  } else if (currentDirection === UP) {
    return 3;
  }
  return -2324893489234928348;
}

function parseGridAndInstructions(data: string): [string[][], string[]] {
  const [rawGrid, rawInstructions] = data.split('\n\n');

  // Grid
  const grid = rawGrid.split('\n').map(i => i.split(''));
  const maxX = grid.reduce((a, b) => Math.max(a, b.length), 0);
  const fullGrid = grid.map(y => [...y, ...Array(maxX - y.length).fill(OB)]);

  // Instructions
  const instructions = rawInstructions
    .split(/([0-9][0-9]?[0-9]?)([A-Z])/)
    .filter(i => i != '');

  return [fullGrid, instructions];
}

const input22Data = readFileSync('./inputs/input_22.txt', 'utf-8');

export {run22A, run22B, input22Data};

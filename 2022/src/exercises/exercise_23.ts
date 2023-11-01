import {readFileSync} from 'fs';

const EMPTY = '.';
const ELF = '#';

const DN = [-1, 0];
const DNE = [-1, 1];
const DE = [0, 1];
const DSE = [1, 1];
const DS = [1, 0];
const DSW = [1, -1];
const DW = [0, -1];
const DNW = [-1, -1];

const DIRECTIONS = [DN, DNE, DE, DSE, DS, DSW, DW, DNW];

function run23A(data: string) {
  let [grid, elfPositions, _] = simulation(data, 10);
  let maxX = grid[0].length;
  let maxY = grid.length;

  // Reduce grid
  let rowsWithElves = grid.map(row => row.indexOf(ELF));
  const firstRowWithElf = getFirstNonNegative(rowsWithElves);
  const lastRowWithElf =
    maxX - getFirstNonNegative(rowsWithElves.slice().reverse());

  const firstColumnwithElf = Math.min(
    ...grid.map(row => row.indexOf(ELF)).filter(i => i !== -1)
  );
  const lastColumnwithElf =
    maxY -
    Math.min(
      ...grid
        .map(row => row.slice().reverse().indexOf(ELF))
        .filter(i => i !== -1)
    );

  const emptyGroundTiles =
    (lastColumnwithElf - firstColumnwithElf) *
      (lastRowWithElf - firstRowWithElf) -
    elfPositions.size;

  return emptyGroundTiles;
}

function run23B(data: string) {
  let [_, __, currentRound] = simulation(data, 1000000000000);

  return currentRound
}

function simulation(
  data: string,
  numberOfRounds: number
): [string[][], Map<number, number[]>, number] {

  // Grid
  let grid = data.split('\n').map(row => row.split(''));
  let maxX = grid[0].length;
  let maxY = grid.length;
  // console.log('maxX', maxX);
  // console.log('maxY', maxY);
  // visualizeGrid(grid);

  // Current elf positions
  let elfPositions = new Map();
  let elfNumber = 1;

  for (let y = 0; y < maxY; y++) {
    for (let x = 0; x < maxX; x++) {
      if (grid[y][x] === ELF) {
        elfPositions.set(elfNumber, [y, x]);
        elfNumber++;
      }
    }
  }

  // Extend grid
  [grid, elfPositions] = extendGrid(grid, elfPositions);
  maxX = grid[0].length;
  maxY = grid.length;

  // Rounds
  let currentRound = 1;

  const orderedDirections = [
    [DN, [DN, DNE, DNW]],
    [DS, [DS, DSE, DSW]],
    [DW, [DW, DNW, DSW]],
    [DE, [DE, DNE, DSE]],
  ];

  while (currentRound <= numberOfRounds) {
    // console.log(`\n== Round ${currentRound} ==`);
    let elfMovedThisRound = false;

    // First half of round: Determine next move
    let elfProposals: any[] = []; // [elf, y, x]

    // console.log("maxX", maxX)
    // console.log("maxY", maxY)
    // console.log("grid", grid[81])
    // console.log("grid", grid[82])
    // console.log("grid", grid[83])
    // console.log("grid", grid[84])
    // console.log("orderedDirections", orderedDirections)
    
    elfPositions.forEach((position, key) => {
      // console.log(key, position)
      if (isOccupied(grid, position, DIRECTIONS)) {
        // console.log("a", isOccupied(grid, position, DIRECTIONS))
        // Propose moves
        for (let m = 0; m <= 3; m++) {
          let considerDirection: any[] = orderedDirections[m];
          if (!isOccupied(grid, position, considerDirection[1])) {
            elfProposals.push([
              key,
              updatePosition(position, considerDirection[0]),
            ]);
            break;
          }
        }
      }
    });

    // console.log("# proposals", currentRound, elfProposals.length)

    // Update order consideration of directions
    let direction: any = orderedDirections.shift();
    orderedDirections.push(direction);

    // Second half of round

    // Check if duplicate proposals
    let proposalCounts = new Map();
    elfProposals.forEach(proposal => {
      proposalCounts.set(
        proposal[1].join('-'),
        (proposalCounts.get(proposal[1].join('-')) || 0) + 1
      );
    });

    // Move if not a duplicate proposal
    elfProposals.forEach(proposal => {
      if (proposalCounts.get(proposal[1].join('-')) === 1) {
        let newPos = proposal[1];
        elfPositions.set(proposal[0], newPos);

        elfMovedThisRound = true;
      }
    });

    // Update grid
    for (let y = 0; y < maxY; y++) {
      for (let x = 0; x < maxX; x++) {
        grid[y][x] = EMPTY;
      }
    }
    elfPositions.forEach(position => {
      grid[position[0]][position[1]] = ELF;
    });

    // Extend grid
    [grid, elfPositions] = extendGrid(grid, elfPositions);
    maxX = grid[0].length;
    maxY = grid.length;

    // End
    if (elfMovedThisRound === false) {
      // console.log(`No elves moved in round ${currentRound}`);
      break;
    } else {
      currentRound++;
    }
  
    // Visualize grid
    // visualizeGrid(grid);
  }

  return [grid, elfPositions, currentRound];
}

function getFirstNonNegative(values: number[]) {
  for (var i = 0, len = values.length; i < len && values[i] < 0; i++);
  // Use a ternary operator
  return i === len ? -1 : i; // If i === len then the entire array is negative
}

function extendGrid(
  grid: string[][],
  elfPositions: Map<number, number[]>
): [string[][], Map<number, number[]>] {
  let maxX = grid[0].length;
  let maxY = grid.length;

  let anyOnEdge =
    [...elfPositions.values()].map(pos => Math.min(...pos)).includes(0) ||
    [...elfPositions.values()].map(pos => Math.max(...pos)).includes(maxX);

  // Extend with one
  if (anyOnEdge) {
    elfPositions.forEach((position, key) => {
      elfPositions.set(key, updatePosition(position, DSE));
    });

    maxX += 2;
    maxY += 2;

    for (let y = 0; y <= maxY; y++) {
      grid[y] = Array();
      for (let x = 0; x < maxX; x++) {
        grid[y][x] = EMPTY;
      }
    }
    elfPositions.forEach(position => {
      grid[position[0]][position[1]] = ELF;
    });
  }

  return [grid, elfPositions];
}
function isOccupied(
  grid: string[][],
  position: number[],
  directions: number[][]
) {
  let occupied = false;
  directions.forEach(d => {
    let pos = updatePosition(position, d);
    if (grid[pos[0]][pos[1]] == ELF) {
      occupied = true;
    }
  });
  return occupied;
}

function updatePosition(position: number[], direction: number[]) {
  return position.map((i, index) => i + direction[index]);
}

function visualizeGrid(grid: string[][]) {
  grid.forEach(row => {
    console.log(row.join(''));
  });
}

const input23Data = readFileSync('./inputs/input_23.txt', 'utf-8');

export {run23A, run23B, input23Data};

import {readFileSync} from 'fs';

const WALL = '#';
const GROUND = '.';
const USER = 'E';
const BLIZZARDS = ['^', '>', 'v', '<'];
const UP = '^';
const RIGHT = '>';
const DOWN = 'v';
const LEFT = '<';

const DIR_UP = [-1, 0];
const DIR_DOWN = [1, 0];
const DIR_LEFT = [0, -1];
const DIR_RIGHT = [0, 1];
const DIR_WAIT = [0, 0];
const DIRECTIONS = [DIR_UP, DIR_DOWN, DIR_LEFT, DIR_RIGHT, DIR_WAIT];

class Valley {
  blizzards: Blizzard[] = [];
  lcm: number;
  cache: Map<number, string[]>;

  constructor() {
    this.cache = new Map();
    this.lcm = 300;
  }

  precalculate() {
    for (let i = 0; i <= this.lcm; i++) {
      this.positionsAt(i);
    }
  }

  addBlizzard(blizzard: Blizzard) {
    this.blizzards.push(blizzard);
  }

  positionsAt(T: number) {
    // Get from cache if present
    if (this.cache.has(T % this.lcm)) {
      return this.cache.get(T % this.lcm) || [];
    }

    // Otherwise, calculate and store in cache
    const positions: string[] = [];
    this.blizzards.forEach(b => {
      positions.push(b.positionAt(T).join(','));
    });
    this.cache.set(T % this.lcm, positions);

    return positions;
  }
}

class Blizzard {
  startPos: number[];
  directionStr: string;
  direction: number[];
  gridSize: number[];

  constructor(
    startY: number,
    startX: number,
    direction: string,
    grid: string[][]
  ) {
    this.startPos = [startY, startX];
    this.directionStr = direction;
    let maxX = grid[0].length - 2;
    let maxY = grid.length - 2;

    if (direction == '^') {
      this.direction = [-1, 0];
    } else if (direction == '>') {
      this.direction = [0, 1];
    } else if (direction == 'v') {
      this.direction = [1, 0];
    } else if (direction == '<') {
      this.direction = [0, -1];
    } else {
      this.direction = [0, 0];
    }

    this.gridSize = [maxY, maxX];
  }

  positionAt(T: number) {
    let pos = this.startPos;
    for (let t = 0; t < T; t++) {
      pos = pos.map((i, index) => i + this.direction[index]);
      if (pos[0] === 0) pos[0] = this.gridSize[0];
      if (pos[0] === this.gridSize[0] + 1) pos[0] = 1;
      if (pos[1] === 0) pos[1] = this.gridSize[1];
      if (pos[1] === this.gridSize[1] + 1) pos[1] = 1;
    }
    return pos;
  }
}

type Coordinate = {
  y: number;
  x: number;
  length: number;
};

function run24A(data: string) {
  const grid = data.split('\n').map(i => i.split(''));
  const maxY = grid.length;

  // Start and end pos
  const startPos = [0, grid[0].indexOf(GROUND)];
  const endPos = [maxY - 1, grid.slice(-1)[0].indexOf(GROUND)];

  // Add blizzards to Valley
  const valley = new Valley();

  grid.forEach((row, y) => {
    row.forEach((value, x) => {
      if (BLIZZARDS.includes(value)) {
        valley.addBlizzard(new Blizzard(y, x, value, grid));
      }
    });
  });

  // Precalculate all
  valley.precalculate();

  // Find best path
  let bestScore = runBfsAlgorithm(grid, valley, startPos, endPos);

  return bestScore;
}

function run24B(data: string) {
  const grid = data.split('\n').map(i => i.split(''));
  const maxY = grid.length;
  const maxX = grid[0].length;

  // Start and end pos
  const startPos = [0, grid[0].indexOf(GROUND)];
  const endPos = [maxY - 1, grid.slice(-1)[0].indexOf(GROUND)];

  // Add blizzards to Valley
  const valley = new Valley();

  grid.forEach((row, y) => {
    row.forEach((value, x) => {
      if (BLIZZARDS.includes(value)) {
        valley.addBlizzard(new Blizzard(y, x, value, grid));
      }
    });
  });

  // Trips
  let bestScoreTrip1 = runBfsAlgorithm(grid, valley, startPos, endPos);
  let bestScoreTrip2 = runBfsAlgorithm(
    grid,
    valley,
    endPos,
    startPos,
    bestScoreTrip1
  );
  let bestScoreTrip3 = runBfsAlgorithm(
    grid,
    valley,
    startPos,
    endPos,
    bestScoreTrip2
  );

  return bestScoreTrip3;
}

function runBfsAlgorithm(
  grid: string[][],
  valley: Valley,
  startPos: number[],
  endPos: number[],
  startT: number = 0
) {
  const maxY = grid.length;
  const maxX = grid[0].length;

  // BFS
  const visited: boolean[][][] = new Array(maxY)
    .fill(undefined)
    .map(() =>
      new Array(maxX)
        .fill(undefined)
        .map(() => new Array(maxY * maxX).fill(false))
    );

  let bestScore: number = Infinity;
  let bestPath: number[][] = [];

  let queue: Coordinate[] = [];
  queue.push({
    y: startPos[0],
    x: startPos[1],
    length: startT,
  });

  while (queue.length > 0) {
    let node: Coordinate | undefined = queue.shift()!;

    let currentPos = [node.y, node.x];
    let T = node.length;

    if (currentPos[0] === endPos[0] && currentPos[1] === endPos[1]) {
      if (T < bestScore) {
        bestScore = T;
      }
      return bestScore;
    }

    // Free spaces?
    let blizzardPositions = valley.positionsAt(T + 1);

    DIRECTIONS.forEach(d => {
      let toPos = updatePosition(currentPos, d);

      if (toPos[0] < 0 || toPos[0] >= maxY) {
        return;
      }

      if (
        grid[toPos[0]][toPos[1]] !== WALL &&
        blizzardPositions.indexOf(toPos.join(',')) === -1 &&
        visited[toPos[0]][toPos[1]][(T + 1) % (maxY * maxX)] === false
      ) {
        queue.push({
          y: toPos[0],
          x: toPos[1],
          length: T + 1,
        });
        visited[toPos[0]][toPos[1]][(T + 1) % (maxY * maxX)] = true;
      }
    });
  }

  return -1;
}

function updatePosition(position: number[], direction: number[]) {
  return position.map((i, index) => i + direction[index]);
}

function visualizeGrid(
  grid: string[][],
  currentPos: number[],
  valley: Valley,
  T: number
) {
  let blizzards = valley.blizzards;

  // Remove existing blizzards from base grid
  for (let y = 0; y < grid.length - 1; y++) {
    for (let x = 1; x < grid[0].length - 1; x++) {
      if (BLIZZARDS.includes(grid[y][x]) || grid[y][x] === USER) {
        grid[y][x] = GROUND;
      }
    }
  }

  // Add user to grid
  grid[currentPos[0]][currentPos[1]] = USER;

  // Add blizzards to grid
  blizzards.forEach(b => {
    let bpos = b.positionAt(T);
    grid[bpos[0]][bpos[1]] = b.directionStr;
  });

  // Visualize grid
  console.log('T=', T);
  for (let y = 0; y < grid.length; y++) {
    let line = '';
    for (let x = 0; x < grid[0].length; x++) {
      line += grid[y][x];
    }
    console.log(line);
  }
  console.log('');
}

const input24Data = readFileSync('./inputs/input_24.txt', 'utf-8');

export {run24A, run24B, input24Data};

import {readFileSync} from 'fs';

function run18A(data: string) {
  const lavaBits = data
    .split('\n')
    .map(i => i.split(',').map(i => parseInt(i)));

  let totalSurfaceArea = 0;
  for (let i = 0; i < lavaBits.length; i++) {
    let sidesExposed = 6;
    for (let j = 0; j < lavaBits.length; j++) {
      let distance = manhattanDistance(lavaBits[i], lavaBits[j]);
      if (distance === 1) sidesExposed--;
    }
    totalSurfaceArea += sidesExposed;
  }

  return totalSurfaceArea;
}

function manhattanDistance(A: number[], B: number[]) {
  return Math.abs(A[0] - B[0]) + Math.abs(A[1] - B[1]) + Math.abs(A[2] - B[2]);
}

const AIR = 0;
const LAVA = 1;
const STEAM = 3;

const SIZE = 22;

function run18B(data: string) {
  const lavaBits = data
    .split('\n')
    .map(i => i.split(',').map(i => parseInt(i)));

  // Grid size
  const gridSize = Math.max(
    ...data
      .split('\n')
      .map(i => Math.max(...i.split(',').map(i => parseInt(i))))
  );

  // Grid
  let grid: number[][][] = [];
  for (let x = -1; x < SIZE + 1; x++) {
    grid[x] = [];
    for (let y = -1; y < SIZE + 1; y++) {
      grid[x][y] = [];
      for (let z = -1; z < SIZE + 1; z++) {
        grid[x][y][z] = AIR;
      }
    }
  }

  // Lava
  lavaBits.forEach(i => {
    grid[i[0]][i[1]][i[2]] = LAVA;
  });

  // For each point
  let queue: number[][] = [];
  queue.push([-1, -1, -1]);

  let lavaCount = 0;
  while (queue.length > 0) {
    let point = queue.shift() || [-1, -1, -1];

    let maxDistance = 1;
    let pointsWithinDistance = getPointsWithinDistance(point, maxDistance);

    pointsWithinDistance.forEach(p => {
      let pointType = grid[p[0]][p[1]][p[2]];

      if (pointType === AIR) {
        grid[p[0]][p[1]][p[2]] = STEAM;
        queue.push(p);
      } else if (pointType === LAVA) {
        lavaCount++;
      }
    });
  }

  // Count steam sides
  let totalSurfaceArea = 0;
  for (let i = 0; i < lavaBits.length; i++) {
    let sidesExposed = 0;
    let pointsWithinDistance = getPointsWithinDistance(lavaBits[i], 1);
    pointsWithinDistance.forEach(p => {
      let pointType = grid[p[0]][p[1]][p[2]];
      if (pointType === STEAM) sidesExposed++;
    });
    totalSurfaceArea += sidesExposed;
  }

  return totalSurfaceArea;
}

function getPointsWithinDistance(point: number[], distance: number) {
  let pointsWithinRange = [];

  for (
    let x = Math.max(0, point[0] - distance) - 1;
    x < Math.min(point[0] + distance, SIZE) + 1;
    x++
  ) {
    for (
      let y = Math.max(0, point[1] - distance) - 1;
      y < Math.min(point[1] + distance, SIZE) + 1;
      y++
    ) {
      for (
        let z = Math.max(0, point[2] - distance) - 1;
        z < Math.min(point[2] + distance, SIZE) + 1;
        z++
      ) {
        if (manhattanDistance(point, [x, y, z]) === 1)
          pointsWithinRange.push([x, y, z]);
      }
    }
  }

  return pointsWithinRange;
}

const input18Data = readFileSync('./inputs/input_18.txt', 'utf-8');

export {run18A, run18B, input18Data};

1029384756;

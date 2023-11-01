import {readFileSync} from 'fs';

import {DefaultMap} from '../default_map';

const OB = ' ';
const EMPTY = '.';
const WALL = '#';
const RIGHT = [0, 1];
const DOWN = [1, 0];
const LEFT = [0, -1];
const UP = [-1, 0];

class V3 {
  x: number;
  y: number;
  z: number;

  constructor(x: number, y: number, z: number) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  key() {
    return `${this.x}-${this.y}-${this.z}`;
  }

  add(other: V3) {
    return new V3(this.x + other.x, this.y + other.y, this.z + other.z);
  }

  mul(k: number) {
    return new V3(this.x * k, this.y * k, this.z * k);
  }

  sub(other: V3) {
    return new V3(this.x - other.x, this.y - other.y, this.z - other.z);
  }

  matmul(other: V3) {
    // cross product
    return new V3(
      this.y * other.z - this.z * other.y,
      this.z * other.x - this.x * other.z,
      this.x * other.y - this.y * other.x
    );
  }

  dot(other: V3) {
    return this.x * other.x + this.y * other.y + this.z * other.z;
  }
}

function inb(grid: string[][], i: number, j: number) {
  // Within grid
  return (
    i >= 0 &&
    i < grid.length &&
    j >= 0 &&
    j < grid[i].length &&
    grid[i][j] != OB
  );
}

function run22A(data: string) {
  const [grid, instructions] = parseGridAndInstructions(data);

  const rectangleSize = (data.replace(/[^#?.?]/gi, '').length / 6) ** 0.5;

  let iminj = new DefaultMap(100000);
  let jmini = new DefaultMap(100000);
  let imaxj = new DefaultMap(-1);
  let jmaxi = new DefaultMap(-1);

  grid.forEach((row, i) => {
    row.forEach((col, j) => {
      if (col !== OB) {
        iminj.set(i, Math.min(iminj.get(i), j));
        imaxj.set(i, Math.max(imaxj.get(i), j));
        jmini.set(j, Math.min(jmini.get(j), i));
        jmaxi.set(j, Math.max(jmaxi.get(j), i));
      }
    });
  });

  let startColIndex = Math.min(
    ...grid[0].map((col, j) => (col === EMPTY ? j : 9999999))
  );
  let [i0, j0] = [0, startColIndex];

  // Run
  let [i, j] = [i0, j0]; // current position
  let [di, dj] = [0, 1]; // direction

  instructions.forEach(operation => {
    if (operation === 'L') {
      [di, dj] = [-dj, di];
    } else if (operation === 'R') {
      [di, dj] = [dj, -di];
    } else {
      [i, j, di, dj] = step(grid, parseInt(operation), i, j, di, dj);
    }
  });

  function step(
    grid: string[][],
    steps: number,
    i: number,
    j: number,
    di: number,
    dj: number
  ) {
    for (let x = 0; x < steps; x++) {
      // New coordinate
      let [ii, jj, ddi, ddj] = [i + di, j + dj, di, dj];

      // Update coordinate if past boundary
      if (!inb(grid, ii, jj)) {
        // Move i
        if (di === 0) {
          ii = ii;
        } else if (ii < jmini.get(j)) {
          ii = jmaxi.get(j);
        } else if (ii > jmaxi.get(jj)) {
          ii = jmini.get(jj);
        }

        // Move j
        if (dj === 0) {
          jj = jj;
        } else if (jj < iminj.get(i)) {
          jj = imaxj.get(i);
        } else if (jj > imaxj.get(ii)) {
          jj = iminj.get(ii);
        }
      }
      // Next position is a wall, so stay at current position
      if (grid[ii][jj] === WALL) {
        break;
      } else {
        // Move to next position
        [i, j, di, dj] = [ii, jj, ddi, ddj];
      }
    }

    return [i, j, di, dj];
  }

  // Final password
  const finalPassword = (i + 1) * 1000 + (j + 1) * 4 + facingNumber(di, dj);
  return finalPassword;
}

function run22B(data: string) {
  const [grid, instructions] = parseGridAndInstructions(data);

  const rectangleSize = (data.replace(/[^#?.?]/gi, '').length / 6) ** 0.5;

  // Boundaries
  let iminj = new DefaultMap(100000);
  let jmini = new DefaultMap(100000);
  let imaxj = new DefaultMap(-1);
  let jmaxi = new DefaultMap(-1);

  grid.forEach((row, i) => {
    row.forEach((col, j) => {
      if (col !== OB) {
        iminj.set(i, Math.min(iminj.get(i), j));
        imaxj.set(i, Math.max(imaxj.get(i), j));
        jmini.set(j, Math.min(jmini.get(j), i));
        jmaxi.set(j, Math.max(jmaxi.get(j), i));
      }
    });
  });

  // Start Pos
  let startColIndex = Math.min(
    ...grid[0].map((col, j) => (col === EMPTY ? j : 9999999))
  );
  let [i0, j0] = [0, startColIndex];

  // Faces and edges
  function get_faces_and_edges(): [Map<string, V3[]>, Map<string, number[]>] {
    let faces: Map<string, V3[]> = new Map();
    let edges: Map<string, number[]> = new Map();

    function f(i: number, j: number, xyz: V3, di: V3, dj: V3) {
      if (!inb(grid, i, j) || faces.has(key([i, j]))) return;

      faces.set(key([i, j]), [xyz, di, dj]);

      for (let r = 0; r < rectangleSize; r++) {
        edges.set(edgeKey([xyz.add(di.mul(r)), di.matmul(dj)]), [i + r, j]);
        edges.set(
          edgeKey([
            xyz.add(di.mul(r)).add(dj.mul(rectangleSize - 1)),
            di.matmul(dj),
          ]),
          [i + r, j + rectangleSize - 1]
        );
        edges.set(edgeKey([xyz.add(dj.mul(r)), di.matmul(dj)]), [i, j + r]);
        edges.set(
          edgeKey([
            xyz.add(dj.mul(r)).add(di.mul(rectangleSize - 1)),
            di.matmul(dj),
          ]),
          [i + rectangleSize - 1, j + r]
        );
      }

      f(
        i + rectangleSize,
        j,
        xyz.add(di.mul(rectangleSize - 1)),
        di.matmul(dj),
        dj
      );
      f(
        i - rectangleSize,
        j,
        xyz.add(di.matmul(dj).mul(rectangleSize - 1)),
        dj.matmul(di),
        dj
      );
      f(
        i,
        j + rectangleSize,
        xyz.add(dj.mul(rectangleSize - 1)),
        di,
        di.matmul(dj)
      );
      f(
        i,
        j - rectangleSize,
        xyz.add(di.matmul(dj).mul(rectangleSize - 1)),
        di,
        dj.matmul(di)
      );
    }

    f(i0, j0, new V3(0, 0, 0), new V3(1, 0, 0), new V3(0, 1, 0));

    return [faces, edges];
  }

  let [faces, edges] = get_faces_and_edges();

  // Run
  let [i, j] = [i0, j0]; // current position
  let [di, dj] = [0, 1]; // direction

  instructions.forEach(operation => {
    if (operation === 'L') {
      [di, dj] = [-dj, di];
    } else if (operation === 'R') {
      [di, dj] = [dj, -di];
    } else {
      [i, j, di, dj] = step(grid, parseInt(operation), i, j, di, dj);
    }
  });

  function step(
    grid: string[][],
    steps: number,
    i: number,
    j: number,
    di: number,
    dj: number
  ) {
    for (let x = 0; x < steps; x++) {
      // New coordinate
      let [ii, jj, ddi, ddj] = [i + di, j + dj, di, dj];

      // Update coordinate if past boundary
      if (!inb(grid, ii, jj)) {
        // Use a bijection to go from 2d to 3d, transition, and back to 2D
        let [xyz, di3, dj3] = faces.get(
          key([
            Math.floor(i / rectangleSize) * rectangleSize,
            Math.floor(j / rectangleSize) * rectangleSize,
          ])
        )!;

        let here = xyz
          .add(di3.mul(i % rectangleSize))
          .add(dj3.mul(j % rectangleSize));
        let n = di3.matmul(dj3);

        [ii, jj] = edges.get(edgeKey([here, di3.mul(-di).add(dj3.mul(-dj))]))!;

        let foo;
        [foo, di3, dj3] = faces.get(
          key([
            Math.floor(ii / rectangleSize) * rectangleSize,
            Math.floor(jj / rectangleSize) * rectangleSize,
          ])
        )!;

        ddi = di3.dot(n);
        ddj = dj3.dot(n);
      }

      // Next position is a wall, so stay at current position
      if (grid[ii][jj] === WALL) {
        break;
      } else {
        // Move to next position
        [i, j, di, dj] = [ii, jj, ddi, ddj];
      }
    }

    return [i, j, di, dj];
  }

  // Final password
  const finalPassword = (i + 1) * 1000 + (j + 1) * 4 + facingNumber(di, dj);
  return finalPassword;
}

function key(values: number[]) {
  return values.join('-');
}

function edgeKey(values: V3[]) {
  return values.map(i => i.key()).join(';');
}

function facingNumber(di: number, dj: number) {
  [di, dj] = [di === -0 ? 0 : di, dj === -0 ? 0 : dj];
  return [RIGHT, DOWN, LEFT, UP]
    .map(i => i.join('-'))
    .indexOf([di, dj].join('-'));
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

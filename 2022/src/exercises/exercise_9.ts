import {readFileSync} from 'fs';

function run9A(data: string, knots = 2) {
  const movements = data.split('\n').map(i => i.split(' '));

  const ropePositions: Array<Array<number>> = [];
  for (let i = 1; i <= knots; i++) {
    ropePositions.push([0, 0]);
  }

  const visited: string[] = [];

  movements.forEach(move => {
    const direction = move[0];
    const steps = parseInt(move[1]);

    for (let i = 1; i <= steps; i++) {
      // Move head
      if (direction === 'U') {
        ropePositions[0][1] += 1;
      } else if (direction === 'R') {
        ropePositions[0][0] += 1;
      } else if (direction === 'D') {
        ropePositions[0][1] -= 1;
      } else if (direction === 'L') {
        ropePositions[0][0] -= 1;
      }

      for (let r = 1; r < ropePositions.length; r++) {
        // Move tail
        const deltaX = ropePositions[r - 1][0] - ropePositions[r][0];
        const deltaY = ropePositions[r - 1][1] - ropePositions[r][1];

        if (Math.abs(deltaX) <= 1 && Math.abs(deltaY) <= 1) {
          // Do nothing
        } else if (Math.abs(deltaX) === 2 && deltaY === 0) {
          // Left/Right
          ropePositions[r][0] += Math.sign(deltaX);
        } else if (deltaX === 0 && Math.abs(deltaY) === 2) {
          // Up/ Down
          ropePositions[r][1] += Math.sign(deltaY);
        } else {
          // Diagonal
          ropePositions[r][0] += Math.sign(deltaX);
          ropePositions[r][1] += Math.sign(deltaY);
        }

        if (!visited.includes(ropePositions.slice(-1).join('.'))) {
          visited.push(ropePositions.slice(-1).join('.'));
        }
      }
    }
  });

  return visited.length;
}

function run9B(data: string) {
  return run9A(data, 10);
}

const input9Data = readFileSync('./inputs/input_9.txt', 'utf-8');

export {run9A, run9B, input9Data};

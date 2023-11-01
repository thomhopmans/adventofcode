import {readFileSync} from 'fs';

function run10A(data: string) {
  const instructions = data.split('\n').map(i => i.split(' '));

  let cycleX = Array(220);
  cycleX[1] = 1;

  let currentCycle = 1;
  instructions.forEach(i => {
    if (i[0] == 'noop') {
      cycleX[currentCycle + 1] = cycleX[currentCycle];

      currentCycle += 1;
    } else if (i[0] == 'addx') {
      let value = parseInt(i[1]);

      cycleX[currentCycle + 1] = cycleX[currentCycle];
      cycleX[currentCycle + 2] = cycleX[currentCycle] + value;

      currentCycle += 2;
    }
  });

  const signalStrength =
    cycleX[20] * 20 +
    cycleX[60] * 60 +
    cycleX[100] * 100 +
    cycleX[140] * 140 +
    cycleX[180] * 180 +
    cycleX[220] * 220;

  return signalStrength;
}

function run10B(data: string) {
  const instructions = data.split('\n').map(i => i.split(' '));
  const register = getRegister(instructions);

  let line = '';
  const startSpritePos = 2;

  register[0] = startSpritePos;
  for (let cycle = 1; cycle <= 240; cycle++) {
    // Is pixel visible?
    let spritePos = register[cycle] + 1;
    let isVisible = Math.abs(spritePos - (cycle % 40)) <= 1;

    // Draw pixel
    line += isVisible ? '#' : '.';
    if (cycle % 40 === 0) {
      line += '\n';
    }
  }
  return line;
}

function getRegister(instructions: Array<Array<string>>) {
  let cycleX = Array(220);
  cycleX[1] = 1;

  let currentCycle = 1;
  instructions.forEach(i => {
    if (i[0] == 'noop') {
      cycleX[currentCycle + 1] = cycleX[currentCycle];

      currentCycle += 1;
    } else if (i[0] == 'addx') {
      let value = parseInt(i[1]);

      cycleX[currentCycle + 1] = cycleX[currentCycle];
      cycleX[currentCycle + 2] = cycleX[currentCycle] + value;

      currentCycle += 2;
    }
  });

  return cycleX.slice(0, -1);
}

const input10Data = readFileSync('./inputs/input_10.txt', 'utf-8');

export {run10A, run10B, input10Data};

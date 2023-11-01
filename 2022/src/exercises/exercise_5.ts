import {readFileSync} from 'fs';

interface Instruction {
  quantity: number;
  from: number;
  to: number;
}

function run5A(data: string) {
  // Parse
  const output = parseCratePositionsAndInstructions(data);
  const cratePositions: Array<Array<string>> = output[0];
  const instructionsMap: Instruction[] = output[1];

  // Move crates
  let takeCrate: string | undefined;

  instructionsMap.forEach(instruction => {
    for (let i = 1; i <= instruction.quantity; i++) {
      takeCrate = cratePositions[instruction.from - 1].shift();
      if (takeCrate) {
        cratePositions[instruction.to - 1].unshift(takeCrate);
      }
    }
  });

  return cratePositions.map(tower => tower[0]).join('');
}

function run5B(data: string) {
  // Parse
  const output = parseCratePositionsAndInstructions(data);
  const cratePositions: Array<Array<string>> = output[0];
  const instructionsMap: Instruction[] = output[1];

  // Move crates
  let takeCrates: string[];
  instructionsMap.forEach(instruction => {
    takeCrates = cratePositions[instruction.from - 1].slice(
      0,
      instruction.quantity
    );
    cratePositions[instruction.from - 1] = cratePositions[
      instruction.from - 1
    ].slice(instruction.quantity);
    cratePositions[instruction.to - 1] = takeCrates.concat(
      cratePositions[instruction.to - 1]
    );
  });

  return cratePositions.map(tower => tower[0]).join('');
}

function parseCratePositionsAndInstructions(data: string) {
  const lines = data.split('\n');

  const splitIndex = lines.indexOf('');

  const crates: string[] = lines.slice(0, splitIndex - 1);
  const instructions: string[] = lines.slice(splitIndex + 1);

  let cratePositions: Array<Array<string>> = [];
  crates.forEach(crate => {
    cratePositions.push(parseCrates(crate));
  });

  cratePositions = transpose(cratePositions).map((line: string[]) =>
    line.filter(i => i !== '')
  );

  const instructionsMap: Instruction[] = [];
  instructions.forEach(instruction => {
    instructionsMap.push(parseInstructions(instruction));
  });

  return [cratePositions, instructionsMap] as const;
}

function parseCrates(line: string) {
  const n = (line.length + 1) / 4; // 4 + 4 + 4

  const crates = Array(n)
    .fill('')
    .map((_, index) =>
      line
        .slice(index * 4, (index + 1) * 4)
        .replaceAll(' ', '')
        .replace(/\t/, '')
        .replace('[', '')
        .replace(']', '')
    );
  return crates;
}

function parseInstructions(line: string): Instruction {
  const commands = line.split(' ');
  return {
    quantity: parseInt(commands[1]),
    from: parseInt(commands[3]),
    to: parseInt(commands[5]),
  };
}

function transpose(matrix: Array<Array<string>>) {
  return matrix[0].map((_, i) => matrix.map(row => row[i]));
}

const input5Data = readFileSync('./inputs/input_5.txt', 'utf-8');

export {run5A, run5B, input5Data};

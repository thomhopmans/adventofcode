import {readFileSync} from 'fs';

const BreakError = {};

function run13A(data: string) {
  const packetPairs = data
    .replace(/\n$/, '')
    .split('\n\n')
    .map(i => i.split('\n'));

  let results: number[] = [0];
  packetPairs.forEach((pair, index) => {
    let A = JSON.parse(pair[0]);
    let B = JSON.parse(pair[1]);

    // Compare one by one
    try {
      if (compare(A, B)) {
        results.push(index + 1);
      }
    } catch (err) {}
  });

  console.log(results);
  return results.reduce((sum, x) => sum + x);
}

function compare(A: any, B: any): boolean {
  const length = Math.max(A.length, B.length);

  for (let i = 0; i < length; i++) {
    let leftValue = A[i];
    let rightValue = B[i];

    if (leftValue === undefined) {
      // Left side ran out of items, so inputs are in the right order
      return true;
    }

    if (rightValue === undefined) {
      // Right side ran out of items, so inputs are not in the right order
      throw BreakError;
    }

    // Mixed types check
    if (typeof leftValue == 'number' && Array.isArray(rightValue)) {
      leftValue = Array(1).fill(leftValue);
    }
    if (typeof rightValue == 'number' && Array.isArray(leftValue)) {
      rightValue = Array(1).fill(rightValue);
    }

    // Comparison
    if (Array.isArray(leftValue) && Array.isArray(rightValue)) {
      if (compare(leftValue, rightValue)) {
        return true;
      }
    } else if (leftValue === rightValue) {
      continue;
    } else if (leftValue < rightValue) {
      return true;
    } else if (leftValue > rightValue) {
      throw BreakError;
    } else {
    }
  }

  return false;
}

function run13B(data: string) {
  const packets = data
    .replace(/\n$/, '')
    .split('\n')
    .filter(i => i !== '')
    .map(i => JSON.parse(i));

  const dividerPackets = [[[2]], [[6]]];
  const allPackets = [...packets, ...dividerPackets];
  const sortedPackets = allPackets.sort((a, b) =>
    breakCompare(a, b) ? -1 : !breakCompare(a, b) ? 1 : 0
  );

  const decoderKey = sortedPackets.reduce(
    (product, packet, i) =>
      product * (dividerPackets.includes(packet) ? i + 1 : 1),
    1
  );

  return decoderKey;
}

function breakCompare(A: any, B: any) {
  try {
    if (compare(A, B)) {
      return true;
    }
  } catch (err) {
    return false;
  }
  return false;
}

const input13Data = readFileSync('./inputs/input_13.txt', 'utf-8');

export {run13A, run13B, input13Data};

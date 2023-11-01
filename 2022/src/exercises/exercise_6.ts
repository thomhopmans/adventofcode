import {readFileSync} from 'fs';

function run6A(datastream: string) {
  // Start of packet
  return detectMarker(datastream, 4);
}

function run6B(datastream: string) {
  // Start of message
  return detectMarker(datastream, 14);
}

function detectMarker(datastream: string, markerLength: number) {
  for (let i = 0; i <= datastream.length - markerLength; i++) {
    const subroutine = datastream.slice(i, i + markerLength);
    if (isUnique(subroutine)) {
      return i + markerLength;
    }
  }
  return;
}

function isUnique(value: string) {
  return new Set(value).size === value.length;
}

const input6Data = readFileSync('./inputs/input_6.txt', 'utf-8');

export {run6A, run6B, input6Data};

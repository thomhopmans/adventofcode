import {readFileSync} from 'fs';

interface SensorBeacon {
  sensor: number[];
  closestBeacon: number[];
}

function run15A(data: string, lineOfInterest: number) {
  const sensorData = data.split('\n').map(i => parseLine(i));

  const maxX = Math.max(
    ...sensorData.reduce((result, item) => {
      result.push(item.sensor[0]);
      result.push(item.closestBeacon[0]);
      return result;
    }, Array())
  );

  let markedX = getMarkedX(sensorData, lineOfInterest);
  let minPos = markedX.reduce((result, x) => Math.min(result, x[0]), 0);
  let maxPos = markedX.reduce((result, x) => Math.max(result, x[1]), 0);

  return Math.abs(minPos) + maxPos;
}

function run15B(data: string, maxY: number) {
  const sensorData = data.split('\n').map(i => parseLine(i));

  let distressSignalBeacon = [-1, -1];

  for (let y = 0; y <= maxY; y++) {
    let result = fillGridLine(sensorData, y);

    if (result.length > 0) {
      distressSignalBeacon = [result[0][1] + 1, y];
      break;
    }
  }

  let tuningFrequency =
    distressSignalBeacon[0] * 4000000 + distressSignalBeacon[1];

  return tuningFrequency;
}

function parseLine(line: string): SensorBeacon {
  // Sensor at x=2, y=18: closest beacon is at x=-2, y=15
  const sensor = line
    .split(':')[0]
    .split('Sensor at x=')[1]
    .split(', y=')
    .map(i => parseInt(i));

  const closestBeacon = line
    .split('closest beacon is at x=')[1]
    .split(', y=')
    .map(i => parseInt(i));

  return {sensor: sensor, closestBeacon: closestBeacon};
}

function toGridLine(maxX: number, fillValue: string) {
  let grid: string[] = [];

  for (let x = 0; x <= maxX; x++) {
    grid[x] = fillValue;
  }

  return grid;
}

function fillGridLine(sensors: SensorBeacon[], lineOfInterest: number) {
  let markedX = getMarkedX(sensors, lineOfInterest);

  let result: number[][] = [];
  let prev = markedX[0];
  markedX.slice(1).forEach(x => {
    if (x[0] >= prev[0] && x[1] <= prev[1]) {
      return;
    } else if (x[0] - prev[1] > 1) {
      result.push(prev);
      result.push(x);
    }
    prev = x;
  });

  return result;
}

function getMarkedX(sensors: SensorBeacon[], lineOfInterest: number) {
  let markedX: number[][] = [];

  sensors.forEach(sb => {
    let sensor = sb.sensor;
    let closestBeacon = sb.closestBeacon;

    // Distance
    const beaconDistance = manhattanDistance(sensor, closestBeacon);

    const deltaYline = Math.abs(lineOfInterest - sensor[1]);
    const lineOfInterestDeltaX = beaconDistance - deltaYline;
    if (lineOfInterestDeltaX < 0) {
      return;
    }
    const markMinX = sensor[0] - lineOfInterestDeltaX;
    const markMaxX = sensor[0] + lineOfInterestDeltaX;

    markedX.push([markMinX, markMaxX]);
  });

  markedX = markedX.sort((a, b) => (a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0));
  return markedX;
}

function manhattanDistance(A: number[], B: number[]) {
  return Math.abs(A[0] - B[0]) + Math.abs(A[1] - B[1]);
}

const input15Data = readFileSync('./inputs/input_15.txt', 'utf-8');

export {run15A, run15B, input15Data};

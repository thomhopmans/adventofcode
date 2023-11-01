import {KeyObject} from 'crypto';
import {readFileSync} from 'fs';

function run16A(data: string) {
  // Load graph
  const valveGraph = parseValveNetwork(data);

  // Run search algorithm for shortest distances from all valves to all other valves
  const T = distancesToAllValves(valveGraph);

  // Cache key by making each state unique
  let valveId = new Map();
  let i = 0;
  valveGraph.forEach((value, key) => {
    if (value.flowRate > 0) {
      valveId.set(key, 2 ** i);
      i++;
    }
  });

  // Visit
  let answer = new Map();
  let result = visit(valveGraph, valveId, T, 'AA', 30, 0, 0, answer);

  return Math.max(...result.values());
}

function parseValveNetwork(data: string) {
  return data.split('\n').reduce((map, line) => {
    const [valve, tunnels] = line.split(';');
    const [rawValveName, flowRate] = valve.split(' has flow rate=');
    const valveName = rawValveName.split(/\s+/)[1];

    map.set(valveName, {
      flowRate: parseInt(flowRate),
      toValves: tunnels.split(/ leads? to valves? /gi)[1].split(', '),
    });
    return map;
  }, new Map());
}

function distancesToAllValves(valveGraph: Map<string, any>) {
  let T = new Map();

  for (const fromValve of valveGraph.keys()) {
    let toMap = new Map();
    for (const toValve of valveGraph.keys()) {
      let visited = new Map();
      valveGraph.forEach((_, key) => {
        visited.set(key, false);
      });

      let maxSteps = breadthFirstSearch(
        valveGraph,
        visited,
        fromValve,
        toValve
      );

      if (fromValve === toValve) {
        maxSteps = 2;
      }

      toMap.set(toValve, maxSteps);
    }
    T.set(fromValve, toMap);
  }

  return T;
}

function breadthFirstSearch(
  valveGraph: Map<string, any>,
  visited: Map<string, boolean>,
  startNode: string,
  endNode: string
) {
  let currentLength = 0;
  const queue: any[][] = [[startNode, currentLength]];

  visited.set(startNode, true);

  while (queue.length) {
    let currentNode = queue.shift();

    if (currentNode) {
      currentLength = currentNode[1];

      let toValves = valveGraph.get(currentNode[0]).toValves;
      for (const valve of toValves) {
        if (visited.get(valve) !== true) {
          visited.set(valve, true);

          if (valve === endNode) {
            return currentLength + 1;
          }
          queue.push([valve, currentLength + 1]);
        }
      }
    }
  }

  return -1;
}

function visit(
  valveGraph: Map<string, any>,
  valveId: Map<string, any>,
  T: Map<string, any>,
  fromValve: string,
  budget: number,
  state: number,
  flow: number,
  answer: Map<number, number>
) {
  let currentStateAnswer = answer.get(state) || 0;
  answer.set(state, Math.max(currentStateAnswer, flow));

  // todo: only use positive flows
  for (const [toValve, value] of valveGraph) {
    if (value.flowRate > 0) {
      let newBudget = budget - T.get(fromValve).get(toValve) - 1;

      // Bit mask
      if (valveId.get(toValve) & state || newBudget < 0) {
        continue;
      }

      // Bit mask
      let newState = state | valveId.get(toValve);
      visit(
        valveGraph,
        valveId,
        T,
        toValve,
        newBudget,
        newState,
        flow + newBudget * value.flowRate,
        answer
      );
    }
  }
  return answer;
}

function run16B(data: string) {
  // Load graph
  const valveGraph = parseValveNetwork(data);

  // Run search algorithm for shortest distances from all valves to all other valves
  const T = distancesToAllValves(valveGraph);

  // Cache key by making each state unique
  let valveId = new Map();
  let i = 0;
  valveGraph.forEach((value, key) => {
    if (value.flowRate > 0) {
      valveId.set(key, 2 ** i);
      i++;
    }
  });

  // Visit
  const result = visit(valveGraph, valveId, T, 'AA', 26, 0, 0, new Map());

  let maxPressure = 0;
  for (const [toValve1, value1] of result) {
    for (const [toValve2, value2] of result) {
      // Bit wise
      if (!(toValve1 & toValve2) && value1 + value2 > maxPressure) {
        maxPressure = value1 + value2;
      }
    }
  }

  return maxPressure;
}

const input16Data = readFileSync('./inputs/input_16.txt', 'utf-8');

export {run16A, run16B, input16Data};

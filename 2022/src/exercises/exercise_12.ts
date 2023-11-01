import {readFileSync} from 'fs';

function run12A(data: string) {
  const mountain = createMountainGrid(data);

  const maxX = mountain[0].length;
  const maxY = mountain.length;
  const nodes = maxX * maxY;

  let visited = new Array(nodes);
  let graph = createGraph(nodes);
  graph = addEdgesToGraph(graph, mountain);

  // Start node
  let startNode = 0;
  for (let x = 0; x < maxX; x++) {
    for (let y = 0; y < maxY; y++) {
      if (mountain[y][x] === -1) {
        let current = y * maxX + x;
        startNode = current;
      }
    }
  }

  // End node
  let endNode = 0;
  for (let x = 0; x < maxX; x++) {
    for (let y = 0; y < maxY; y++) {
      if (mountain[y][x] === 26) {
        let current = y * maxX + x;
        endNode = current;
      }
    }
  }

  // Run search algorithm
  let maxSteps = breadthFirstSearch(graph, visited, startNode, endNode);

  return maxSteps;
}

function createMountainGrid(data: string) {
  const mountain = data.split('\n').map(i =>
    i
      .split('')
      .map(j => j.charCodeAt(0) - 97)
      .map(j => (j === -28 ? 26 : j))
      .map(j => (j === -14 ? -1 : j))
  );
  return mountain;
}

function createGraph(nodes: number): number[][] {
  let graph = new Array(nodes);

  for (let i = 0; i < graph.length; i++) {
    graph[i] = new Array(nodes);
  }

  for (let i = 0; i < graph.length; i++) {
    for (let j = 0; j < graph[i].length; j++) {
      graph[i][j] = 0;
    }
  }

  return graph;
}

function addEdgesToGraph(graph: any, mountain: any) {
  //   console.log('Add edges to graph...');

  const maxX = mountain[0].length;
  const maxY = mountain.length;

  // Add edges
  for (let x = 0; x < maxX; x++) {
    // console.log(x + '/' + maxX);
    for (let y = 0; y < maxY; y++) {
      let current = y * maxX + x;
      let currentValue = mountain[y][x];

      // right adjacent
      if (x + 1 <= maxX) {
        let rightValue = mountain[y][x + 1];
        if (canMove(currentValue, rightValue)) {
          let right = y * maxX + (x + 1);
          graph = addEdge(graph, current, right);
        }
      }
      // left adjacent
      if (x - 1 >= 0) {
        let leftValue = mountain[y][x - 1];
        if (canMove(currentValue, leftValue)) {
          let left = y * maxX + (x - 1);
          graph = addEdge(graph, current, left);
        }
      }
      // top adjacent
      if (y - 1 >= 0) {
        let topValue = mountain[y - 1][x];
        if (canMove(currentValue, topValue)) {
          let top = (y - 1) * maxX + x;
          graph = addEdge(graph, current, top);
        }
      }
      // bottom adjacent
      if (y + 1 < maxY) {
        let bottomValue = mountain[y + 1][x];
        if (canMove(currentValue, bottomValue)) {
          let bottom = (y + 1) * maxX + x;
          graph = addEdge(graph, current, bottom);
        }
      }
    }
  }
  return graph;
}

function addEdge(graph: any, a: number, b: number) {
  const maxX = graph[0].length;
  const maxY = graph.length;

  let ii = Math.floor(a / maxX) + (a % maxY);
  let jj = Math.floor(b / maxX) + (b % maxY);

  graph[ii][jj] = 1;

  return graph;
}

function canMove(from: number, to: number) {
  // TODO: Get rid of last two conditionals by properly transforming S and E to a and z
  return to - from <= 1 || (from == -1 && to == 1) || (from == 24 && to == 26);
}

function breadthFirstSearch(
  graph: any,
  visited: any,
  startNode: any,
  endNode: any
) {
  const queue: number[][] = [[startNode, 0]];

  visited = Array(visited.length).fill(false);
  visited[startNode] = true;

  while (queue.length) {
    let currentNode = queue.shift();

    if (currentNode) {
      let currentLength = currentNode[1];

      for (let j = 0; j < graph[currentNode[0]].length; j++) {
        if (visited[j] === true) {
          continue;
        } else if (graph[currentNode[0]][j] === 0) {
          continue;
        } else {
          visited[j] = true;

          if (j === endNode) {
            return currentLength + 1;
          }
          queue.push([j, currentLength + 1]);
        }
      }
    }
  }

  return visited;
}

function run12B(data: string) {
  // Initialize graph
  const mountain = createMountainGrid(data);

  const maxX = mountain[0].length;
  const maxY = mountain.length;
  const nodes = maxX * maxY;

  let visited = new Array(nodes);
  let graph = createGraph(nodes);
  graph = addEdgesToGraph(graph, mountain);

  // Find all possible start node
  let startNodes = [];
  for (let x = 0; x < maxX; x++) {
    for (let y = 0; y < maxY; y++) {
      if (mountain[y][x] === -1 || mountain[y][x] === 0) {
        let current = y * maxX + x;
        // console.log('start node', x, y, current);
        startNodes.push(current);
      }
    }
  }

  // End node
  let endNode = 0;
  for (let x = 0; x < maxX; x++) {
    for (let y = 0; y < maxY; y++) {
      if (mountain[y][x] === 26) {
        let current = y * maxX + x;
        endNode = current;
      }
    }
  }

  // Run search algorithm
  let results: number[] = [];
  startNodes.forEach(sn => {
    let maxSteps = breadthFirstSearch(graph, visited, sn, endNode);
    results.push(maxSteps);
  });

  results = results.filter(i => i > 0);

  const maxSteps = Math.min(...results);
  return maxSteps;
}

const input12Data = readFileSync('./inputs/input_12.txt', 'utf-8');

export {run12A, run12B, input12Data};

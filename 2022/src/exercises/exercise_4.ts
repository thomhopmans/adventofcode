import {readFileSync} from 'fs';

interface Assignment {
  start: number;
  end: number;
}

function strToAssignment(assignment: string): Assignment {
  return {
    start: parseInt(assignment.split('-')[0]),
    end: parseInt(assignment.split('-')[1]),
  };
}

function fullyContains(
  assignment: Assignment,
  otherAssignment: Assignment
): boolean {
  return (
    assignment.start >= otherAssignment.start &&
    assignment.end <= otherAssignment.end
  );
}

function run4A(data: string) {
  const results: number[] = [];
  data.split('\n').forEach(item => {
    const pairs = item.split(',');
    const firstElfAssignment = strToAssignment(pairs[0]);
    const secondElfAssignment = strToAssignment(pairs[1]);

    results.push(
      fullyContains(firstElfAssignment, secondElfAssignment) ||
        fullyContains(secondElfAssignment, firstElfAssignment)
        ? 1
        : 0
    );
  });
  const score = results.reduce((sum, x) => sum + x);
  return score;
}

function hasOverlap(
  assignment: Assignment,
  otherAssignment: Assignment
): boolean {
  return (
    assignment.end >= otherAssignment.start &&
    assignment.start <= otherAssignment.end
  );
}

function run4B(data: string) {
  const results: number[] = [];
  data.split('\n').forEach(item => {
    const pairs = item.split(',');
    const firstElfAssignment = strToAssignment(pairs[0]);
    const secondElfAssignment = strToAssignment(pairs[1]);

    results.push(
      hasOverlap(firstElfAssignment, secondElfAssignment) ||
        hasOverlap(secondElfAssignment, firstElfAssignment)
        ? 1
        : 0
    );
  });
  const score = results.reduce((sum, x) => sum + x);
  return score;
}

const input4Data = readFileSync('./inputs/input_4.txt', 'utf-8');

export {run4A, run4B, input4Data};

import {readFileSync} from 'fs';

function run1A(data: string) {
  const elfFood = parseFoodPerElf(data);
  const sumOfElfWithMostCalories = Math.max(...elfFood);

  return sumOfElfWithMostCalories;
}

function run1B(data: string) {
  const elfFood = parseFoodPerElf(data);

  return sumOfThreeElvesWithMostCalories(elfFood);
}

function parseFoodPerElf(data: string) {
  const elves = data.replace(/\n$/, '').split('\n\n');

  const elfFood = [];
  for (const elf of elves) {
    elfFood.push(
      elf
        .split('\n')
        .map(x => parseInt(x))
        .reduce((sum, x) => sum + x)
    );
  }
  return elfFood;
}

function sumOfThreeElvesWithMostCalories(elfFood: number[]) {
  return elfFood
    .sort((n1, n2) => n2 - n1)
    .slice(0, 3)
    .reduce((sum, x) => sum + x);
}

// Run
const input1Data = readFileSync('./inputs/input_1.txt', 'utf-8');

export {run1A, run1B, input1Data};

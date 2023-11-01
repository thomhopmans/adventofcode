import {readFileSync} from 'fs';

class Monkey {
  name: number;
  items: number[];
  operation: string;
  testDivisibleBy: number;
  testTrueToMonkey: number;
  testFalseToMonkey: number;
  numberOfInspections: number = 0;

  constructor(name: number, monkeyData: string) {
    let monkeyOperations = monkeyData.split('\n');

    this.name = name;
    this.items = monkeyOperations[0]
      .replace('Starting items: ', '')
      .split(', ')
      .map(i => parseInt(i));
    this.operation = monkeyOperations[1].replace('Operation: new = ', '');
    this.testDivisibleBy = parseInt(
      monkeyOperations[2].replace('Test: divisible by ', '')
    );
    this.testTrueToMonkey = parseInt(
      monkeyOperations[3].replace('  If true: throw to monkey ', '')
    );
    this.testFalseToMonkey = parseInt(
      monkeyOperations[4].replace('  If false: throw to monkey ', '')
    );
  }

  updateWorryLevel(worryLevel: number) {
    let operation = this.operation.replaceAll('old', String(worryLevel));
    let result = 0;

    if (operation.includes(' * ')) {
      let values = operation.split(' * ').map(i => parseInt(i));
      result = values[0] * values[1];
    } else if (operation.includes(' + ')) {
      let values = operation.split(' + ').map(i => parseInt(i));
      result = values[0] + values[1];
    }

    return result;
  }

  toMonkey(worryLevel: number): number {
    let targetMonkey;
    if (worryLevel % this.testDivisibleBy === 0) {
      targetMonkey = this.testTrueToMonkey;
    } else {
      targetMonkey = this.testFalseToMonkey;
    }
    return targetMonkey;
  }
}

function run11A(data: string) {
  const monkeys = parseMonkeyOperations(data);

  const numberOfRounds = 20;

  for (let round = 1; round <= numberOfRounds; round++) {
    // Monkey Operations
    monkeys.forEach(monkey => {
      monkey.items.forEach(item => {
        monkey.numberOfInspections += 1;
        let newWorryLevel = monkey.updateWorryLevel(item);

        newWorryLevel = Math.floor(newWorryLevel / 3);

        let toMonkey = monkey.toMonkey(newWorryLevel);
        monkeys[toMonkey].items.push(newWorryLevel);
      });
      monkey.items = [];
    });
  }

  // Inspection Summary
  const monkeyBusiness = monkeys
    .map(m => m.numberOfInspections)
    .sort((a, b) => (a < b ? -1 : a > b ? 1 : 0))
    .reverse()
    .slice(0, 2)
    .reduce((sum, x) => sum * x);

  monkeys.forEach(monkey => {
    // console.log(
    //   `Monkey ${monkey.name} inspected items ${monkey.numberOfInspections} times.`
    // );
  });

  return monkeyBusiness;
}

function run11B(data: string) {
  const monkeys = parseMonkeyOperations(data);
  const moduloProduct = monkeys.map(m => m.testDivisibleBy).reduce((sum, x) => sum * x);

  const numberOfRounds = 10000;
  let monkeyBusiness;

  for (let round = 1; round <= numberOfRounds; round++) {
    // Monkey Operations
    monkeys.forEach(monkey => {
      // console.log(`Monkey ${monkey.name}:`);
      monkey.items.forEach(worryLevel => {
        // console.log(`  Monkey inspects an item with a worry level of ${worryLevel}.`);
        monkey.numberOfInspections += 1;
        let newWorryLevel = monkey.updateWorryLevel(worryLevel);
        
        newWorryLevel = newWorryLevel % moduloProduct
        // console.log(
        //   `    Monkey gets bored with item. Worry level is divided by 3 to ${newWorryLevel}.`
        // );
    
        let toMonkey = monkey.toMonkey(newWorryLevel);
        monkeys[toMonkey].items.push(newWorryLevel);
      });
      monkey.items = [];
    });

    // Inspection Summary
    if ([1, 20, 1000, 10000].includes(round)) {
      monkeyBusiness = calculateMonkeyBusiness(monkeys);
      
      // console.log(`\nAfter round ${round}:`);
      // monkeys.forEach(monkey => {
      //   console.log(
      //     `Monkey ${monkey.name} inspected items ${monkey.numberOfInspections} times.`
      //   );
      // });
    }
  }

  return monkeyBusiness;
}

function parseMonkeyOperations(data: string): Monkey[] {
  const monkeys = data
    .split(/Monkey \d:\n/)
    .slice(1)
    .map(i => i.trim())
    .map((m, index) => new Monkey(index, m));

  return monkeys;
}

function calculateMonkeyBusiness(monkeys: Monkey[]) {
  const monkeyBusiness = monkeys
    .map(m => m.numberOfInspections)
    .sort((a, b) => (a < b ? -1 : a > b ? 1 : 0))
    .reverse()
    .slice(0, 2)
    .reduce((sum, x) => sum * x);

  return monkeyBusiness;
}

const input11Data = readFileSync('./inputs/input_11.txt', 'utf-8');

export {run11A, run11B, input11Data};

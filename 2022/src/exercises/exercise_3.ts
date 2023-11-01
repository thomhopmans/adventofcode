import {readFileSync} from 'fs';

class BagWithCompartments {
  firstCompartment: string[];
  secondCompartment: string[];
  sharedItems: string[];

  constructor(items: string) {
    const splitItems = items.split('');
    const n = splitItems.length;

    this.firstCompartment = splitItems.slice(0, n / 2);
    this.secondCompartment = splitItems.slice(n / 2, n);

    this.sharedItems = this.firstCompartment.filter(val1 =>
      this.secondCompartment.find(val2 => val1 === val2)
    );
    this.sharedItems = this.sharedItems.filter(
      (value, index) => this.sharedItems.indexOf(value) === index
    );
  }

  priority() {
    const shared = this.sharedItems[0];
    const isUppercase = shared.toUpperCase() === shared ? 1 : 0;
    return parseInt(shared, 36) - 9 + 26 * isUppercase;
  }
}

class Group {
  bag1: string[];
  bag2: string[];
  bag3: string[];
  sharedItems: string[];

  constructor(group: string[]) {
    this.bag1 = group[0].split('');
    this.bag2 = group[1].split('');
    this.bag3 = group[2].split('');

    this.sharedItems = this.getSharedItems();
  }

  getSharedItems() {
    return this.bag1
      .filter(val1 => this.bag2.find(val2 => val1 === val2))
      .filter(val12 => this.bag3.find(val3 => val12 === val3));
  }

  priority() {
    const shared = this.sharedItems[0];
    const isUppercase = shared.toUpperCase() === shared ? 1 : 0;
    return parseInt(shared, 36) - 9 + 26 * isUppercase;
  }
}

function run3A(data: string) {
  const results: number[] = [];
  data.split('\n').forEach(items => {
    results.push(new BagWithCompartments(items).priority());
  });
  const priority = results.reduce((sum, x) => sum + x);

  return priority;
}

function run3B(data: string) {
  const elves = data.split('\n');
  const groups: Array<Array<string>> = [];

  let current_group: string[] = [];
  elves.forEach(items => {
    current_group.push(items);
    if (current_group.length === 3) {
      groups.push(current_group);
      current_group = [];
    }
  });

  const priorities: number[] = [];
  groups.forEach(items => {
    priorities.push(new Group(items).priority());
  });
  const priority = priorities.reduce((sum, x) => sum + x);

  return priority;
}

const input3Data = readFileSync('./inputs/input_3.txt', 'utf-8');

export {run3A, run3B, input3Data};

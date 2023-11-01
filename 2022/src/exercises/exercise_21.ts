import {readFileSync} from 'fs';

const ONLY_DIGITS = /^[+-]?([0-9]*[.])?[0-9]+$/;

function run21A(data: string) {
  // Parse
  const monkeyMap = parseMonkeys(data);

  // Replace
  while (!ONLY_DIGITS.test(monkeyMap.get('root'))) {
    monkeyMap.forEach((value, name) => {
      const digitsOnly = ONLY_DIGITS.test(value);

      if (digitsOnly) return;

      let terms = value.split(' ');
      let operator = terms[1];

      let term1value = monkeyMap.get(terms[0]);
      if (ONLY_DIGITS.test(term1value)) terms[0] = parseInt(term1value);

      let term2value = monkeyMap.get(terms[2]);
      if (ONLY_DIGITS.test(term2value)) terms[2] = parseInt(term2value);

      if (ONLY_DIGITS.test(terms[0]) && ONLY_DIGITS.test(terms[2])) {
        if (operator === '+') {
          terms = parseInt(terms[0]) + parseInt(terms[2]);
        } else if (operator === '-') {
          terms = parseInt(terms[0]) - parseInt(terms[2]);
        } else if (operator === '*') {
          terms = parseInt(terms[0]) * parseInt(terms[2]);
        } else if (operator === '/') {
          terms = parseInt(terms[0]) / parseInt(terms[2]);
        }
      } else {
        terms = terms.join(' ');
      }

      monkeyMap.set(name, terms);
    });
  }

  return monkeyMap.get('root');
}

class MatchError extends Error {}
class SmallerError extends Error {}
class GreaterError extends Error {}

function run21B(data: string) {
  // Output
  let output = undefined;

  // Binary Search
  const UPPER_BOUND = 10000000000000;
  const SIGN = -1;

  let humanNumber = UPPER_BOUND / 2; // Searchspace [0, UPPER_BOUND]
  let stepSize = UPPER_BOUND / 4;

  const MAX_ITERATIONS = 100;
  for (let number = 1; number <= MAX_ITERATIONS; number++) {
    try {
      runComparison(data, humanNumber);
    } catch (e: any) {
      if (e.name === 'MatchError') {
        // console.log(humanNumber, 'match');
        output = humanNumber;
        number = MAX_ITERATIONS + 1;
      } else if (e.name === 'SmallerError') {
        // console.log(humanNumber, 'too small');
        humanNumber += SIGN * stepSize;
        stepSize /= 2;
      } else if (e.name === 'GreaterError') {
        // console.log(humanNumber, 'too high');
        humanNumber += -1 * SIGN * stepSize;
        stepSize /= 2;
      }

      humanNumber = Math.round(humanNumber);
    }
  }

  return output;
}

function runComparison(data: string, humanNumber: number) {
  // Parse
  const monkeyMap = parseMonkeys(data);

  // Update root
  let rootMonkey = monkeyMap.get('root');
  monkeyMap.set('root', rootMonkey.replace('+', '='));

  monkeyMap.set('humn', humanNumber);

  // Replace
  let doRun = true;
  while (doRun === true) {
    monkeyMap.forEach((value, name) => {
      const digitsOnly = ONLY_DIGITS.test(value);

      if (digitsOnly) return;

      let terms = value.split(' ');
      let operator = terms[1];

      let term1value = monkeyMap.get(terms[0]);
      if (ONLY_DIGITS.test(term1value)) terms[0] = parseFloat(term1value);

      let term2value = monkeyMap.get(terms[2]);
      if (ONLY_DIGITS.test(term2value)) terms[2] = parseFloat(term2value);

      if (ONLY_DIGITS.test(terms[0]) && ONLY_DIGITS.test(terms[2])) {
        if (operator === '+') {
          terms = parseFloat(terms[0]) + parseFloat(terms[2]);
        } else if (operator === '-') {
          terms = parseFloat(terms[0]) - parseFloat(terms[2]);
        } else if (operator === '*') {
          terms = parseFloat(terms[0]) * parseFloat(terms[2]);
        } else if (operator === '/') {
          terms = Math.round(parseFloat(terms[0]) / parseFloat(terms[2]));
        } else if (operator === '=') {
          let equalTerms = parseFloat(terms[0]) === parseFloat(terms[2]);

          if (equalTerms === false) {
            doRun = false;
            if (parseFloat(terms[0]) > parseFloat(terms[2])) throw GreaterError;
            else if (parseFloat(terms[0]) < parseFloat(terms[2]))
              throw SmallerError;

            // throw Error;
          } else {
            throw MatchError;
          }
        }
      } else {
        terms = terms.join(' ');
      }

      monkeyMap.set(name, terms);
    });
  }
}

function parseMonkeys(data: string) {
  const monkeyMap = new Map();
  data
    .split('\n')
    .map(i => i.split(': '))
    .sort((a, b) => (a[1] < b[1] ? -1 : a[1] > b[1] ? 1 : 0))
    .forEach(i => {
      monkeyMap.set(i[0], ONLY_DIGITS.test(i[1]) ? parseInt(i[1]) : i[1]);
    });
  return monkeyMap;
}

const input21Data = readFileSync('./inputs/input_21.txt', 'utf-8');

export {run21A, run21B, input21Data};

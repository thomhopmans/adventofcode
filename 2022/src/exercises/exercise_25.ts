import {readFileSync} from 'fs';

function run25A(data: string) {
  const snafuNumbers = data.split('\n');

  let sumDecimals = snafuNumbers
    .map(sn => snafuToDecimal(sn))
    .reduce((sum, x) => sum + x);

  return decimalToSnafu(sumDecimals);
}

function snafuToDecimal(snafu: string) {
  let values = snafu.split('').slice().reverse();
  let decimal = 0;

  values.forEach((i, index) => {
    let number;
    if (i === '-') number = -1;
    else if (i === '=') number = -2;
    else number = parseInt(i);

    number = number * 5 ** index;
    decimal += number;
  });
  return decimal;
}

function decimalToSnafu(decimal: number): string {
  if (decimal > 0) {
    const quotient = Math.floor((decimal + 2) / 5);
    const remainder = (decimal + 2) % 5;
    const snafuValue = '=-012'.slice(remainder, remainder + 1);
    // console.log('>', decimal, quotient, remainder, snafuValue);
    return decimalToSnafu(quotient) + snafuValue;
  }
  return '';
}

const input25Data = readFileSync('./inputs/input_25.txt', 'utf-8');

export {run25A, input25Data};

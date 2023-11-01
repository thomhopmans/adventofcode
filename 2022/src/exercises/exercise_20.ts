import {readFileSync} from 'fs';

function run20A(data: string) {
  const decryptionKey = 1;
  let mixing = data.split('\n').map(i => parseInt(i) * decryptionKey);
  const n = mixing.length;

  let tracking = [...Array(n)].map((_, i) => i + 1);

  // 1 rounds of mixing
  for (let i = 1; i <= n; i++) {
    let index = tracking.indexOf(i);
    let output = move(mixing, tracking, index);
    mixing = output[0];
    tracking = output[1];
  }

  // find grove coordinates
  let result: number[] = [];
  while (result.length <= 3000 + n) {
    result = result.concat([...mixing]);
  }
  while (result[0] !== 0) {
    result.shift();
  }

  return result[1000] + result[2000] + result[3000];
}

function run20B(data: string) {
  const decryptionKey = 811589153;
  let mixing = data.split('\n').map(i => parseInt(i) * decryptionKey);
  const n = mixing.length;

  let tracking = [...Array(n)].map((_, i) => i + 1);

  // 10 rounds of mixing
  for (let m = 1; m <= 10; m++) {
    for (let i = 1; i <= n; i++) {
      let index = tracking.indexOf(i);
      let output = move(mixing, tracking, index);
      mixing = output[0];
      tracking = output[1];
    }
  }
  // find grove coordinates
  let result: number[] = [];
  while (result.length <= 3000 + n) {
    result = result.concat([...mixing]);
  }
  while (result[0] !== 0) {
    result.shift();
  }

  return result[1000] + result[2000] + result[3000];
}

function move(mixing: number[], tracking: number[], index: number) {
  const n = mixing.length;
  let value = mixing[index];

  if (value > 0) value %= n - 1;
  if (value < 0) value = ((value * -1) % (n - 1)) * -1;

  let newIndex = index;
  while (value > 0) {
    if (newIndex == mixing.length - 1) newIndex = 0;
    newIndex++;
    value--;
  }
  while (value < 0) {
    if (newIndex == 0) newIndex = mixing.length - 1;
    newIndex--;
    value++;
  }

  mixing = array_move(mixing, index, newIndex);
  tracking = array_move(tracking, index, newIndex);

  return [mixing, tracking] as const;
}

function array_move(arr: any[], old_index: number, new_index: number) {
  arr.splice(new_index, 0, arr.splice(old_index, 1)[0]);
  return arr;
}

const input20Data = readFileSync('./inputs/input_20.txt', 'utf-8');

export {run20A, run20B, input20Data, move};

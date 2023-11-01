import {readFileSync} from 'fs';

enum Rsp {
  Rock,
  Paper,
  Scissors,
}

const opponentMap = new Map<string, number>([
  ['A', Rsp.Rock],
  ['B', Rsp.Paper],
  ['C', Rsp.Scissors],
]);

const meMap = new Map<string, number>([
  ['X', Rsp.Rock],
  ['Y', Rsp.Paper],
  ['Z', Rsp.Scissors],
]);

class Round {
  opponent: number;
  me: number;

  constructor(round: string) {
    const decisions = round.split(' ');
    this.opponent = opponentMap.get(decisions[0]) || Rsp.Rock;
    this.me = meMap.get(decisions[1]) || Rsp.Rock;
  }

  score() {
    let score = -99;
    if (this.opponent === Rsp.Rock) {
      if (this.me === Rsp.Rock) {
        score = 3;
      } else if (this.me === Rsp.Paper) {
        score = 6;
      } else if (this.me === Rsp.Scissors) {
        score = 0;
      }
    } else if (this.opponent === Rsp.Paper) {
      if (this.me === Rsp.Rock) {
        score = 0;
      } else if (this.me === Rsp.Paper) {
        score = 3;
      } else if (this.me === Rsp.Scissors) {
        score = 6;
      }
    } else if (this.opponent === Rsp.Scissors) {
      if (this.me === Rsp.Rock) {
        score = 6;
      } else if (this.me === Rsp.Paper) {
        score = 0;
      } else if (this.me === Rsp.Scissors) {
        score = 3;
      }
    }
    return score + this.me_score();
  }

  me_score() {
    return [Rsp.Rock, Rsp.Paper, Rsp.Scissors].indexOf(this.me) + 1;
  }
}

enum Result {
  Win = 6,
  Draw = 3,
  Lose = 0,
}

const resultMap = new Map<string, number>([
  ['X', Result.Lose],
  ['Y', Result.Draw],
  ['Z', Result.Win],
]);

class EndScore {
  opponent: number;
  me: number;
  result: number;

  constructor(round: string) {
    const decisions = round.split(' ');
    this.opponent = opponentMap.get(decisions[0]) || 0;
    this.result = resultMap.get(decisions[1]) || 0;
    this.me = 0;
  }

  score() {
    let score = -99;
    if (this.opponent === Rsp.Rock) {
      if (this.me === Rsp.Rock) {
        score = 3;
      } else if (this.me === Rsp.Paper) {
        score = 6;
      } else if (this.me === Rsp.Scissors) {
        score = 0;
      }
    } else if (this.opponent === Rsp.Paper) {
      if (this.me === Rsp.Rock) {
        score = 0;
      } else if (this.me === Rsp.Paper) {
        score = 3;
      } else if (this.me === Rsp.Scissors) {
        score = 6;
      }
    } else if (this.opponent === Rsp.Scissors) {
      if (this.me === Rsp.Rock) {
        score = 6;
      } else if (this.me === Rsp.Paper) {
        score = 0;
      } else if (this.me === Rsp.Scissors) {
        score = 3;
      }
    }
    return score + this.me_score();
  }

  setMe() {
    if (this.opponent === Rsp.Rock) {
      if (this.result === Result.Lose) {
        this.me = Rsp.Scissors;
      } else if (this.result === Result.Draw) {
        this.me = Rsp.Rock;
      } else if (this.result === Result.Win) {
        this.me = Rsp.Paper;
      }
    } else if (this.opponent === Rsp.Paper) {
      if (this.result === Result.Lose) {
        this.me = Rsp.Rock;
      } else if (this.result === Result.Draw) {
        this.me = Rsp.Paper;
      } else if (this.result === Result.Win) {
        this.me = Rsp.Scissors;
      }
    } else if (this.opponent === Rsp.Scissors) {
      if (this.result === Result.Lose) {
        this.me = Rsp.Paper;
      } else if (this.result === Result.Draw) {
        this.me = Rsp.Scissors;
      } else if (this.result === Result.Win) {
        this.me = Rsp.Rock;
      }
    }
    return this;
  }

  me_score() {
    return [Rsp.Rock, Rsp.Paper, Rsp.Scissors].indexOf(this.me) + 1;
  }
}

function run2A(data: string) {
  const rounds: number[] = [];
  data.split('\n').forEach(round => {
    rounds.push(new Round(round).score());
  });
  const score = rounds.reduce((sum, x) => sum + x);
  return score;
}

function run2B(data: string) {
  const results: number[] = [];
  data.split('\n').forEach(result => {
    results.push(new EndScore(result).setMe().score());
  });
  const score = results.reduce((sum, x) => sum + x);
  return score;
}

const input2Data = readFileSync('./inputs/input_2.txt', 'utf-8');

export {run2A, run2B, input2Data};

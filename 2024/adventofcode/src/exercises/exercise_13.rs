use crate::exercises::utils;
use std::collections::HashMap;

pub const EXERCISE: usize = 13;

type Machine = HashMap<String, (i64, i64)>;

pub fn main() {
    let input_data = utils::load_data(EXERCISE);
    println!("Exercise {}A: {}", EXERCISE, run_a(&input_data));
    println!("Exercise {}B: {}", EXERCISE, run_b(&input_data));
}

pub fn run_a(input_data: &str) -> i64 {
    let prize_data = parse_prize_data(input_data, 0);
    min_tokens_to_win_most_prices(&prize_data)
}

pub fn run_b(input_data: &str) -> i64 {
    let prize_data = parse_prize_data(input_data, 10_000_000_000_000);
    min_tokens_to_win_most_prices(&prize_data)
}

fn parse_prize_data(data: &str, shift_prize: i64) -> Vec<Machine> {
    let entries: Vec<&str> = data.trim().split("\n\n").collect();
    let mut machines = Vec::new();

    for entry in entries {
        let lines: Vec<&str> = entry.split('\n').collect();
        let button_a = parse_coordinates(lines[0], "X+", "Y+");
        let button_b = parse_coordinates(lines[1], "X+", "Y+");
        let prize = parse_coordinates(lines[2], "X=", "Y=");

        machines.push(
            [
                ("button_a".to_string(), button_a),
                ("button_b".to_string(), button_b),
                (
                    "prize".to_string(),
                    (prize.0 + shift_prize, prize.1 + shift_prize),
                ),
            ]
            .iter()
            .cloned()
            .collect(),
        );
    }

    machines
}

fn parse_coordinates(line: &str, x_delim: &str, y_delim: &str) -> (i64, i64) {
    let parts: Vec<i64> = line
        .split(':')
        .nth(1)
        .unwrap()
        .replace(x_delim, "")
        .replace(y_delim, "")
        .split(',')
        .map(|s| s.trim().parse().unwrap())
        .collect();

    (parts[0], parts[1])
}

fn min_tokens_to_win_most_prices(prize_data: &[Machine]) -> i64 {
    prize_data
        .iter()
        .map(|machine| {
            let button_a = machine["button_a"];
            let button_b = machine["button_b"];
            let prize = machine["prize"];

            let (push_a, push_b) = min_tokens_to_get_machine_prize(
                button_a.0, button_a.1, button_b.0, button_b.1, prize.0, prize.1,
            );
            push_a * 3 + push_b * 1
        })
        .sum()
}

fn min_tokens_to_get_machine_prize(
    a_x: i64,
    a_y: i64,
    b_x: i64,
    b_y: i64,
    prize_x: i64,
    prize_y: i64,
) -> (i64, i64) {
    let denom = a_x * b_y - a_y * b_x;
    let numer_a = b_y * prize_x - b_x * prize_y;
    let numer_b = a_y * prize_x - a_x * prize_y;

    if denom != 0 && numer_a % denom == 0 && numer_b % -denom == 0 {
        return (numer_a / denom, numer_b / -denom);
    }
    (0, 0)
}

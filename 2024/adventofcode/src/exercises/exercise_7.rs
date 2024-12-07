use crate::exercises::utils;
use itertools::Itertools;
use std::str::FromStr;

pub const EXERCISE: usize = 7;

pub fn main() {
    let input_data = utils::load_data(EXERCISE);
    println!("Exercise {}A: {}", EXERCISE, run_a(&input_data));
    println!("Exercise {}B: {}", EXERCISE, run_b(&input_data));
}

pub fn run_a(input_data: &str) -> i64 {
    let equations = parse_equations(input_data);
    let allowed_operators = ["+", "*"];

    let total_sum: i64 = equations
        .iter()
        .filter(|(test_value, numbers)| can_produce_value(*test_value, numbers, &allowed_operators))
        .map(|(test_value, _)| *test_value)
        .sum();

    total_sum
}

pub fn run_b(input_data: &str) -> i64 {
    let equations = parse_equations(input_data);
    let allowed_operators = ["+", "*", "||"];

    let total_sum: i64 = equations
        .iter()
        .filter(|(test_value, numbers)| can_produce_value(*test_value, numbers, &allowed_operators))
        .map(|(test_value, _)| *test_value)
        .sum();

    total_sum
}

fn parse_equations(input_data: &str) -> Vec<(i64, Vec<i64>)> {
    input_data
        .trim()
        .lines()
        .map(|line| {
            let parts: Vec<&str> = line.trim().split(':').collect();
            let test_value = i64::from_str(parts[0].trim()).unwrap();
            let numbers: Vec<i64> = parts[1]
                .trim()
                .split_whitespace()
                .map(|x| i64::from_str(x).unwrap())
                .collect();
            (test_value, numbers)
        })
        .collect()
}

fn can_produce_value(test_value: i64, numbers: &Vec<i64>, allowed_operators: &[&str]) -> bool {
    // No operators are required if formula is only one number
    if numbers.len() == 1 {
        return numbers[0] == test_value;
    }

    let n_operators_required = numbers.len() - 1;

    // Repeat the slice of 'allowed_operators' 'n_operators_required' times,
    // to get the cartesian product.
    let operator_combinations = std::iter::repeat(&allowed_operators[..])
        .take(n_operators_required)
        .map(|slice| slice.iter().map(|&x| x)) // Map &&str to &str
        .multi_cartesian_product();

    for ops in operator_combinations {
        let val = evaluate_expression(numbers, &ops, allowed_operators);
        if val == test_value {
            return true;
        }
    }

    false
}

fn evaluate_expression(numbers: &Vec<i64>, ops: &Vec<&str>, allowed_operators: &[&str]) -> i64 {
    let mut result = numbers[0];
    for (op, &num) in ops.iter().zip(numbers.iter().skip(1)) {
        if !allowed_operators.contains(op) {
            continue;
        }

        match *op {
            "+" => {
                result += num;
            }
            "*" => {
                result *= num;
            }
            "||" => {
                let concatenated = format!("{}{}", result, num);
                result = concatenated.parse::<i64>().unwrap();
            }
            _ => {}
        }
    }
    result
}

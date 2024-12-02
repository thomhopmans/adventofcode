use crate::exercises::utils;
use std::str::FromStr;

pub const EXERCISE: usize = 2;

pub fn main() {
    let input_data = utils::load_data(EXERCISE);
    println!("Exercise {}A: {}", EXERCISE, run_a(&input_data));
    println!("Exercise {}B: {}", EXERCISE, run_b(&input_data));
}

pub fn run_a(input_data: &str) -> usize {
    let reports = parse_reports(input_data);
    reports
        .iter()
        .filter(|row: &&Vec<i32>| is_safe(row))
        .count()
}

pub fn run_b(input_data: &str) -> usize {
    let reports = parse_reports(input_data);
    reports
        .iter()
        .filter(|row| is_safe(row) || can_be_safe_with_one_removal(row))
        .count()
}

fn parse_reports(input_data: &str) -> Vec<Vec<i32>> {
    input_data
        .lines()
        .map(|line| {
            line.split_whitespace()
                .map(|num| i32::from_str(num).unwrap())
                .collect()
        })
        .collect()
}

fn is_safe(row: &Vec<i32>) -> bool {
    is_monotonic(row) && is_within_difference_constraint(row)
}

fn is_monotonic(row: &Vec<i32>) -> bool {
    let increasing = row.windows(2).all(|pair| pair[0] <= pair[1]);
    let decreasing = row.windows(2).all(|pair| pair[0] >= pair[1]);
    increasing || decreasing
}

fn is_within_difference_constraint(row: &Vec<i32>) -> bool {
    row.windows(2).all(|pair| {
        let diff = (pair[1] - pair[0]).abs();
        diff >= 1 && diff <= 3
    })
}

fn can_be_safe_with_one_removal(row: &Vec<i32>) -> bool {
    for i in 0..row.len() {
        let mut modified_row = row.clone();
        modified_row.remove(i);
        if is_safe(&modified_row) {
            return true;
        }
    }
    false
}

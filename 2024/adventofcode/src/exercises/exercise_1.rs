use crate::exercises::utils;
use std::collections::HashMap;

pub const EXERCISE: usize = 1;

pub fn main() {
    let input_data = utils::load_data(EXERCISE);
    println!("Exercise {}A: {}", EXERCISE, run_a(&input_data));
    println!("Exercise {}B: {}", EXERCISE, run_b(&input_data));
}

pub fn run_a(input_data: &str) -> i32 {
    let (mut left, mut right) = parse_lists(input_data);

    left.sort();
    right.sort();

    // Sort lists, calculate absolute differences and sum over all
    let total_difference: i32 = left
        .iter()
        .zip(right.iter())
        .map(|(l, r)| (l - r).abs())
        .sum();

    total_difference
}

pub fn run_b(input_data: &str) -> i32 {
    let (left, right) = parse_lists(input_data);

    // Count occurrences in right
    let mut right_counts: HashMap<i32, i32> = HashMap::new();
    for value in right {
        *right_counts.entry(value).or_insert(0) += 1;
    }

    // Calculate similarities
    let total_similarity: i32 = left
        .iter()
        .map(|value| value * right_counts.get(value).unwrap_or(&0))
        .sum();

    total_similarity
}

fn parse_lists(input_data: &str) -> (Vec<i32>, Vec<i32>) {
    let rows: Vec<Vec<&str>> = input_data
        .lines()
        .map(|line| line.split_whitespace().collect())
        .collect();

    let left: Vec<i32> = rows
        .iter()
        .map(|row| row[0].parse::<i32>().unwrap())
        .collect();
    let right: Vec<i32> = rows
        .iter()
        .map(|row| row[1].parse::<i32>().unwrap())
        .collect();

    (left, right)
}

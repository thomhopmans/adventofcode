use crate::exercises::utils;
use std::collections::HashMap;

pub const EXERCISE: usize = 11;

pub fn main() {
    let input_data = utils::load_data(EXERCISE);
    println!("Exercise {}A: {}", EXERCISE, run_a(&input_data));
    println!("Exercise {}B: {}", EXERCISE, run_b(&input_data));
}

pub fn run_a(input_data: &str) -> u64 {
    let initial_stones = parse_stones(input_data);
    let mut mapping = HashMap::new();
    let blinks = 25;
    initial_stones
        .iter()
        .map(|&stone| get_stone_number(blinks, stone, &mut mapping))
        .sum()
}

pub fn run_b(input_data: &str) -> u64 {
    let initial_stones = parse_stones(input_data);
    let mut mapping = HashMap::new();
    let blinks = 75;
    initial_stones
        .iter()
        .map(|&stone| get_stone_number(blinks, stone, &mut mapping))
        .sum()
}

fn parse_stones(input_data: &str) -> Vec<u64> {
    input_data
        .split_whitespace()
        .map(|x| x.parse::<u64>().unwrap())
        .collect()
}

fn get_stone_number(blinks_left: u32, stone: u64, mapping: &mut HashMap<(u32, u64), u64>) -> u64 {
    if blinks_left == 0 {
        return 1;
    }

    // Check the cache
    if let Some(&result) = mapping.get(&(blinks_left, stone)) {
        return result;
    }

    // Compute the result
    let result = if stone == 0 {
        get_stone_number(blinks_left - 1, 1, mapping)
    } else if stone.to_string().len() % 2 == 0 {
        // Even-length stone: split into left and right halves
        let stone_str = stone.to_string();
        let middle = stone_str.len() / 2;
        let left_stone = stone_str[..middle].parse::<u64>().unwrap();
        let right_stone = stone_str[middle..].parse::<u64>().unwrap();
        get_stone_number(blinks_left - 1, left_stone, mapping)
            + get_stone_number(blinks_left - 1, right_stone, mapping)
    } else {
        // Odd-length stone: multiply by 2024
        get_stone_number(blinks_left - 1, stone * 2024, mapping)
    };

    // Update the cache
    mapping.insert((blinks_left, stone), result);

    result
}

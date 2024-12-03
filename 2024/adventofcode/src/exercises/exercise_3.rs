use crate::exercises::utils;
use regex::Regex;

pub const EXERCISE: usize = 3;

pub fn main() {
    let input_data = utils::load_data(EXERCISE);
    println!("Exercise {}A: {}", EXERCISE, run_a(&input_data));
    println!("Exercise {}B: {}", EXERCISE, run_b(&input_data));
}

pub fn run_a(input_data: &str) -> i32 {
    extract_and_compute_mul(input_data)
}

pub fn run_b(input_data: &str) -> i32 {
    extract_and_compute_with_conditions(input_data)
}

fn extract_and_compute_mul(input_string: &str) -> i32 {
    let pattern = Regex::new(r"mul\((\d{1,3}),(\d{1,3})\)").unwrap();
    pattern
        .captures_iter(input_string)
        .map(|cap| {
            let x: i32 = cap[1].parse().unwrap();
            let y: i32 = cap[2].parse().unwrap();
            x * y
        })
        .sum()
}

fn extract_and_compute_with_conditions(input_string: &str) -> i32 {
    let mul_pattern = Regex::new(r"mul\((\d{1,3}),(\d{1,3})\)").unwrap();
    let condition_pattern = Regex::new(r"do\(\)|don't\(\)").unwrap();

    let mut events: Vec<(usize, &str, Option<(i32, i32)>)> = vec![];

    for mat in mul_pattern.find_iter(input_string) {
        let captures = mul_pattern.captures(mat.as_str()).unwrap();
        let x: i32 = captures[1].parse().unwrap();
        let y: i32 = captures[2].parse().unwrap();
        events.push((mat.start(), "mul", Some((x, y))));
    }

    for mat in condition_pattern.find_iter(input_string) {
        events.push((mat.start(), mat.as_str(), None));
    }

    events.sort_by_key(|event| event.0);

    let mut enabled = true;
    let mut total_sum = 0;

    for (_, event_type, value) in events {
        match event_type {
            "do()" => enabled = true,
            "don't()" => enabled = false,
            "mul" => {
                if enabled {
                    if let Some((x, y)) = value {
                        total_sum += x * y;
                    }
                }
            }
            _ => {}
        }
    }

    total_sum
}

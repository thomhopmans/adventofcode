use crate::exercises::utils;
use std::collections::HashMap;

pub const EXERCISE: usize = 5;

pub fn main() {
    let input_data = utils::load_data(EXERCISE);
    println!("Exercise {}A: {}", EXERCISE, run_a(&input_data));
    println!("Exercise {}B: {}", EXERCISE, run_b(&input_data));
}

pub fn run_a(input_data: &str) -> i32 {
    let (rules, updates) = parse_data(input_data);
    let mut sum_valid_middle_pages = 0;

    for update in updates {
        if is_correct_order(&update, &rules) {
            sum_valid_middle_pages += middle_page(&update);
        }
    }

    sum_valid_middle_pages
}

pub fn run_b(input_data: &str) -> i32 {
    let (rules, updates) = parse_data(input_data);
    let mut sum_corrected_middle_pages = 0;

    for update in updates {
        if !is_correct_order(&update, &rules) {
            let corrected_update = fix_update_by_using_order_rules(&update, &rules);
            sum_corrected_middle_pages += middle_page(&corrected_update);
        }
    }

    sum_corrected_middle_pages
}

fn parse_data(input_data: &str) -> (Vec<(i32, i32)>, Vec<Vec<i32>>) {
    let parts: Vec<&str> = input_data.split("\n\n").collect();
    let rules_str = parts[0];
    let updates_str = parts[1];

    let rules: Vec<(i32, i32)> = rules_str
        .lines()
        .map(|line| {
            let mut nums = line.split('|').map(|x| x.trim().parse::<i32>().unwrap());
            (nums.next().unwrap(), nums.next().unwrap())
        })
        .collect();

    let updates: Vec<Vec<i32>> = updates_str
        .lines()
        .map(|line| {
            line.split(',')
                .map(|x| x.trim().parse::<i32>().unwrap())
                .collect()
        })
        .collect();

    (rules, updates)
}

fn is_correct_order(update: &[i32], rules: &[(i32, i32)]) -> bool {
    let page_indices: HashMap<i32, usize> = update
        .iter()
        .enumerate()
        .map(|(i, &page)| (page, i))
        .collect();

    for &(x, y) in rules {
        if let (Some(&ix), Some(&iy)) = (page_indices.get(&x), page_indices.get(&y)) {
            if ix > iy {
                return false;
            }
        }
    }

    true
}

fn middle_page(update: &[i32]) -> i32 {
    update[update.len() / 2]
}

fn fix_update_by_using_order_rules(pages: &[i32], rules: &[(i32, i32)]) -> Vec<i32> {
    let mut directed_graph: HashMap<i32, Vec<i32>> = HashMap::new();
    let mut incoming_edges_count: HashMap<i32, usize> = HashMap::new();

    // Build the directed graph based on the pages and the rules
    for &(predecessor, successor) in rules {
        if pages.contains(&predecessor) && pages.contains(&successor) {
            directed_graph
                .entry(predecessor)
                .or_default()
                .push(successor);
            *incoming_edges_count.entry(successor).or_insert(0) += 1;

            // Ensure every predecessor is in the `incoming_edges_count` map
            incoming_edges_count.entry(predecessor).or_insert(0);
        }
    }

    // Initialize the queue with pages that have no incoming edges
    let mut no_incoming_edges: Vec<i32> = pages
        .iter()
        .filter(|&&page| *incoming_edges_count.get(&page).unwrap_or(&0) == 0)
        .cloned()
        .collect();

    let mut sorted_pages: Vec<i32> = Vec::new();

    // Perform sorting
    while let Some(current_page) = no_incoming_edges.pop() {
        sorted_pages.push(current_page);

        if let Some(dependent_pages) = directed_graph.get(&current_page) {
            for &dependent_page in dependent_pages {
                if let Some(count) = incoming_edges_count.get_mut(&dependent_page) {
                    *count -= 1;
                    if *count == 0 {
                        no_incoming_edges.push(dependent_page);
                    }
                }
            }
        }
    }

    sorted_pages
}

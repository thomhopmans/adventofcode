use crate::exercises::utils;
use std::collections::HashSet;

pub const EXERCISE: usize = 6;
const DIRECTIONS: [(isize, isize); 4] = [(-1, 0), (0, 1), (1, 0), (0, -1)];
const DIRECTION_SYMBOLS: [&str; 4] = ["^", ">", "v", "<"];

pub fn main() {
    let input_data = utils::load_data(EXERCISE);
    println!("Exercise {}A: {}", EXERCISE, run_a(&input_data));
    println!("Exercise {}B: {}", EXERCISE, run_b(&input_data));
}

pub fn run_a(input_data: &str) -> usize {
    let grid: Vec<Vec<char>> = input_data
        .trim()
        .lines()
        .map(|line| line.chars().collect())
        .collect();

    let (guard_pos, current_direction) = find_starting_position_and_direction_of_guard(&grid);
    let (_, visited_states) = simulate_guard_patrol(&grid, guard_pos, current_direction, None);

    // Extract unique visited positions
    let unique_visited_positions: HashSet<_> = visited_states.iter().map(|(pos, _)| *pos).collect();
    unique_visited_positions.len()
}

pub fn run_b(input_data: &str) -> usize {
    let grid: Vec<Vec<char>> = input_data
        .trim()
        .lines()
        .map(|line| line.chars().collect())
        .collect();

    count_valid_obstruction_positions(&grid)
}

fn count_valid_obstruction_positions(grid: &[Vec<char>]) -> usize {
    // Identify all possible obstructions positions where an obstruction can be placed
    // The possible solution space is reduced significantly by only evaluating positions the guards visits when no obstructions are placed
    let (guard_pos, current_direction) = find_starting_position_and_direction_of_guard(&grid);
    let (_, visited_states) = simulate_guard_patrol(&grid, guard_pos, current_direction, None);
    let unique_visited_positions: HashSet<_> = visited_states.iter().map(|(pos, _)| *pos).collect();

    // Check each empty position
    let mut valid_positions = 0;
    for pos in unique_visited_positions {
        let (is_loop, _) = simulate_guard_patrol(grid, guard_pos, current_direction, Some(pos));
        if is_loop {
            valid_positions += 1;
        }
    }

    valid_positions
}

fn find_starting_position_and_direction_of_guard(grid: &[Vec<char>]) -> ((usize, usize), usize) {
    for (r, row) in grid.iter().enumerate() {
        for (c, &cell) in row.iter().enumerate() {
            if let Some(index) = DIRECTION_SYMBOLS
                .iter()
                .position(|&s| s == cell.to_string())
            {
                return ((r, c), index);
            }
        }
    }
    panic!("Guard starting position not found");
}

fn simulate_guard_patrol(
    grid: &[Vec<char>],
    mut guard_pos: (usize, usize),
    mut current_direction: usize,
    new_obstruction: Option<(usize, usize)>,
) -> (bool, HashSet<((usize, usize), usize)>) {
    let rows = grid.len();
    let cols = grid[0].len();
    let mut simulation_grid = grid.to_vec();

    // Add the new obstruction if specified
    if let Some((r, c)) = new_obstruction {
        simulation_grid[r][c] = '#';
    }

    let mut visited_states = HashSet::new();

    loop {
        // Store current state (position and direction)
        let state = (guard_pos, current_direction);
        if visited_states.contains(&state) {
            return (true, visited_states); // Loop detected
        }
        visited_states.insert(state);

        // Calculate the position in front of the guard
        let (dr, dc) = DIRECTIONS[current_direction];
        let next_pos = (
            (guard_pos.0 as isize + dr) as usize,
            (guard_pos.1 as isize + dc) as usize,
        );

        // Check if the guard is leaving the mapped area
        if next_pos.0 >= rows || next_pos.1 >= cols {
            return (false, visited_states); // No loop, leaves the area
        }

        // Check for obstacles
        if simulation_grid[next_pos.0][next_pos.1] == '#' {
            // Turn clockwise
            current_direction = (current_direction + 1) % 4;
        } else {
            // Move forward
            guard_pos = next_pos;
        }
    }
}

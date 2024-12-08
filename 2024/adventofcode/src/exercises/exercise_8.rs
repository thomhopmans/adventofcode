use crate::exercises::utils;
use std::cmp::Ordering;
use std::collections::{HashMap, HashSet};

pub const EXERCISE: usize = 8;

pub fn main() {
    let input_data = utils::load_data(EXERCISE);
    println!("Exercise {}A: {}", EXERCISE, run_a(&input_data));
    println!("Exercise {}B: {}", EXERCISE, run_b(&input_data));
}

pub fn run_a(input_data: &str) -> usize {
    let grid: Vec<Vec<char>> = input_data
        .lines()
        .map(|line| line.chars().collect())
        .collect();
    let antennas = parse_antenna_coordinates(&grid);
    find_all_antinodes_a(&antennas, &grid)
}

pub fn run_b(input_data: &str) -> usize {
    let grid: Vec<Vec<char>> = input_data
        .lines()
        .map(|line| line.chars().collect())
        .collect();
    let antennas = parse_antenna_coordinates(&grid);
    find_all_antinodes_b(&antennas, &grid)
}

fn parse_antenna_coordinates(grid: &[Vec<char>]) -> HashMap<char, Vec<(usize, usize)>> {
    let mut antennas = HashMap::new();
    for (y, row) in grid.iter().enumerate() {
        for (x, &cell) in row.iter().enumerate() {
            if cell.is_ascii_alphanumeric() {
                antennas.entry(cell).or_insert_with(Vec::new).push((y, x));
            }
        }
    }
    antennas
}

fn find_all_antinodes_a(
    antennas: &HashMap<char, Vec<(usize, usize)>>,
    grid: &[Vec<char>],
) -> usize {
    let rows = grid.len();
    let cols = grid[0].len();
    let mut antinodes = HashSet::new();

    for positions in antennas.values() {
        for (y1, x1) in positions {
            for (y2, x2) in positions {
                if (y1, x1) == (y2, x2) {
                    continue;
                }

                let dx = *x2 as isize - *x1 as isize;
                let dy = *y2 as isize - *y1 as isize;

                let antinode_1 = ((*y1 as isize - dy) as usize, (*x1 as isize - dx) as usize);
                let antinode_2 = ((*y2 as isize + dy) as usize, (*x2 as isize + dx) as usize);

                for antinode in [antinode_1, antinode_2] {
                    if antinode.0 < rows && antinode.1 < cols {
                        antinodes.insert(antinode);
                    }
                }
            }
        }
    }
    antinodes.len()
}

fn find_all_antinodes_b(
    antennas: &HashMap<char, Vec<(usize, usize)>>,
    grid: &[Vec<char>],
) -> usize {
    let rows = grid.len();
    let cols = grid[0].len();
    let mut antinodes = HashSet::new();

    for positions in antennas.values() {
        for (y1, x1) in positions {
            for (y2, x2) in positions {
                if (y1, x1) == (y2, x2) {
                    continue;
                }

                let dx = *x2 as isize - *x1 as isize;
                let dy = *y2 as isize - *y1 as isize;
                let gcd_value = gcd(dx, dy);
                let step_x = dx / gcd_value;
                let step_y = dy / gcd_value;

                // Extend backward
                let (mut start_x, mut start_y) = (*x1 as isize, *y1 as isize);
                while start_x >= 0
                    && start_y >= 0
                    && (start_x as usize) < cols
                    && (start_y as usize) < rows
                {
                    antinodes.insert((start_y as usize, start_x as usize));
                    start_x -= step_x;
                    start_y -= step_y;
                }

                // Extend forward
                let (mut start_x, mut start_y) = (*x2 as isize, *y2 as isize);
                while start_x >= 0
                    && start_y >= 0
                    && (start_x as usize) < cols
                    && (start_y as usize) < rows
                {
                    antinodes.insert((start_y as usize, start_x as usize));
                    start_x += step_x;
                    start_y += step_y;
                }
            }
        }
    }
    antinodes.len()
}

fn gcd(a: isize, b: isize) -> isize {
    match b.cmp(&0) {
        Ordering::Equal => a.abs(),
        _ => gcd(b, a % b),
    }
}

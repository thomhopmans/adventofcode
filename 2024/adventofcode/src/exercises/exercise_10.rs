use crate::exercises::utils;
use std::collections::{HashSet, VecDeque};

pub const EXERCISE: usize = 10;
const DIRECTIONS: [(isize, isize); 4] = [(-1, 0), (1, 0), (0, -1), (0, 1)];
const TRAILHEAD: i32 = 0;
const MAX_HEIGHT: i32 = 9;

pub fn main() {
    let input_data = utils::load_data(EXERCISE);
    println!("Exercise {}A: {}", EXERCISE, run_a(&input_data));
    println!("Exercise {}B: {}", EXERCISE, run_b(&input_data));
}

pub fn run_a(input_data: &str) -> usize {
    let grid = parse_map(input_data);
    let trailheads = find_trailheads(&grid);
    trailheads
        .iter()
        .map(|&trailhead| find_reachable_nines(&grid, trailhead))
        .sum()
}

pub fn run_b(input_data: &str) -> usize {
    let grid = parse_map(input_data);
    let trailheads = find_trailheads(&grid);
    trailheads
        .iter()
        .map(|&trailhead| find_distinct_trails(&grid, trailhead))
        .sum()
}

fn parse_map(map_str: &str) -> Vec<Vec<i32>> {
    map_str
        .lines()
        .map(|line| {
            line.trim()
                .chars()
                .map(|ch| ch.to_digit(10).unwrap() as i32)
                .collect()
        })
        .collect()
}

fn find_trailheads(grid: &[Vec<i32>]) -> Vec<(usize, usize)> {
    let mut trailheads = Vec::new();
    let rows = grid.len();
    let cols = grid[0].len();

    for r in 0..rows {
        for c in 0..cols {
            if grid[r][c] == TRAILHEAD {
                trailheads.push((r, c));
            }
        }
    }
    trailheads
}

fn find_reachable_nines(grid: &[Vec<i32>], trailhead: (usize, usize)) -> usize {
    let rows = grid.len();
    let cols = grid[0].len();

    // BFS to find reachable 9s
    let mut visited = HashSet::new();
    let mut queue = VecDeque::new();
    let mut reachable_nines = HashSet::new();

    queue.push_back(trailhead);

    while let Some((y, x)) = queue.pop_front() {
        visited.insert((y, x));

        for &(dy, dx) in &DIRECTIONS {
            let ny = y as isize + dy;
            let nx = x as isize + dx;

            if ny >= 0 && ny < rows as isize && nx >= 0 && nx < cols as isize {
                let ny = ny as usize;
                let nx = nx as usize;

                if !visited.contains(&(ny, nx)) && grid[ny][nx] == grid[y][x] + 1 {
                    if grid[ny][nx] == MAX_HEIGHT {
                        reachable_nines.insert((ny, nx));
                    }
                    queue.push_back((ny, nx));
                }
            }
        }
    }

    reachable_nines.len()
}

fn find_distinct_trails(grid: &[Vec<i32>], trailhead: (usize, usize)) -> usize {
    fn dfs(grid: &[Vec<i32>], y: usize, x: usize, visited: &mut HashSet<(usize, usize)>) -> usize {
        if grid[y][x] == MAX_HEIGHT {
            // Valid trail end
            return 1;
        }

        let mut count = 0;
        for &(dy, dx) in &DIRECTIONS {
            let ny = y as isize + dy;
            let nx = x as isize + dx;

            if ny >= 0 && ny < grid.len() as isize && nx >= 0 && nx < grid[0].len() as isize {
                let ny = ny as usize;
                let nx = nx as usize;

                if !visited.contains(&(ny, nx)) && grid[ny][nx] == grid[y][x] + 1 {
                    visited.insert((ny, nx));
                    count += dfs(grid, ny, nx, visited);
                    visited.remove(&(ny, nx));
                }
            }
        }

        count
    }

    let mut visited = HashSet::new();
    visited.insert(trailhead);
    dfs(grid, trailhead.0, trailhead.1, &mut visited)
}

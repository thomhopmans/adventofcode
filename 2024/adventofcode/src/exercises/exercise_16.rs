use crate::exercises::utils;
use std::cmp::Ordering;
use std::collections::{BinaryHeap, HashMap, HashSet};
use std::f64::INFINITY;

pub const EXERCISE: usize = 16;

pub fn main() {
    let input_data = utils::load_data(EXERCISE);
    println!("Exercise {}A: {}", EXERCISE, run_a(&input_data));
    println!("Exercise {}B: {}", EXERCISE, run_b(&input_data));
}

type Position = (usize, usize);
type Direction = (isize, isize);

#[derive(Clone, PartialEq)]
struct State {
    cost: f64,
    position: Position,
    direction: Direction,
    tiles: Vec<Position>,
}

impl Eq for State {}

impl Ord for State {
    fn cmp(&self, other: &Self) -> Ordering {
        other.cost.partial_cmp(&self.cost).unwrap()
    }
}

impl PartialOrd for State {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

pub fn run_a(input_data: &str) -> usize {
    let grid = parse_grid(input_data);
    let (start, end) = get_start_end_position(&grid);
    dijkstra_a(&grid, start, end)
}

pub fn run_b(input_data: &str) -> usize {
    let grid = parse_grid(input_data);
    let (start, end) = get_start_end_position(&grid);
    dijkstra_b(&grid, start, end)
}

fn parse_grid(data: &str) -> Vec<Vec<char>> {
    data.lines().map(|line| line.chars().collect()).collect()
}

fn get_start_end_position(grid: &[Vec<char>]) -> (Position, Position) {
    let mut start = None;
    let mut end = None;

    for (y, row) in grid.iter().enumerate() {
        for (x, &v) in row.iter().enumerate() {
            if v == 'S' {
                start = Some((y, x));
            } else if v == 'E' {
                end = Some((y, x));
            }
        }
    }
    (start.unwrap(), end.unwrap())
}

fn dijkstra_a(grid: &[Vec<char>], start: Position, end: Position) -> usize {
    let (rows, cols) = (grid.len(), grid[0].len());
    let mut scores: HashMap<(Position, Direction), f64> = HashMap::new();
    let mut priority_queue = BinaryHeap::new();

    scores.insert((start, (0, 1)), 0.0);
    priority_queue.push(State {
        cost: 0.0,
        position: start,
        direction: (0, 1),
        tiles: vec![start],
    });

    while let Some(State {
        cost,
        position,
        direction,
        tiles,
    }) = priority_queue.pop()
    // Take value from priority queue
    {
        // Reached destination
        if position == end {
            return cost as usize;
        }

        let (i, j) = position;
        let (di, dj) = direction;

        // Try all possible moves
        for (new_cost, new_y, new_x, new_dy, new_dx) in [
            (
                cost + 1.0,
                (i as isize + di) as usize,
                (j as isize + dj) as usize,
                di,
                dj,
            ),
            (
                cost + 1001.0,
                (i as isize - dj) as usize,
                (j as isize + di) as usize,
                -dj,
                di,
            ),
            (
                cost + 1001.0,
                (i as isize + dj) as usize,
                (j as isize - di) as usize,
                dj,
                -di,
            ),
        ] {
            // Check if next move is feasible
            if new_y >= rows || new_x >= cols || grid[new_y][new_x] == '#' {
                continue;
            }

            // Only continue if we have a higher score for that position.
            // This reduces the number of solutions to explore.
            let new_state = ((new_y, new_x), (new_dy, new_dx));
            if *scores.get(&new_state).unwrap_or(&INFINITY) > new_cost {
                scores.insert(new_state, new_cost);
                priority_queue.push(State {
                    cost: new_cost,
                    position: (new_y, new_x),
                    direction: (new_dy, new_dx),
                    tiles: {
                        let mut t = tiles.clone();
                        t.push((new_y, new_x));
                        t
                    },
                });
            }
        }
    }

    0
}

fn dijkstra_b(grid: &[Vec<char>], start: Position, end: Position) -> usize {
    let (rows, cols) = (grid.len(), grid[0].len());
    let mut scores: HashMap<(Position, Direction), f64> = HashMap::new();
    let mut priority_queue = BinaryHeap::new();

    let mut all_tiles = HashSet::new();
    let mut current_best_score = f64::INFINITY;

    scores.insert((start, (0, 1)), 0.0);
    priority_queue.push(State {
        cost: 0.0,
        position: start,
        direction: (0, 1),
        tiles: vec![start],
    });

    while let Some(State {
        cost,
        position,
        direction,
        tiles,
    }) = priority_queue.pop()
    // Take value from priority queue
    {
        // Reached destination
        if position == end {
            // Update the current best score if a better score is found
            if cost < current_best_score {
                current_best_score = cost;
                all_tiles.clear(); // Clear previous tiles for non-optimal paths
            }

            // If the current score matches the best score, save tiles
            if (cost - current_best_score).abs() < f64::EPSILON {
                all_tiles.extend(tiles.clone());
            }
        }

        let (i, j) = position;
        let (di, dj) = direction;

        // Try all possible moves
        for (new_cost, new_y, new_x, new_dy, new_dx) in [
            (
                cost + 1.0,
                (i as isize + di) as usize,
                (j as isize + dj) as usize,
                di,
                dj,
            ),
            (
                cost + 1001.0,
                (i as isize - dj) as usize,
                (j as isize + di) as usize,
                -dj,
                di,
            ),
            (
                cost + 1001.0,
                (i as isize + dj) as usize,
                (j as isize - di) as usize,
                dj,
                -di,
            ),
        ] {
            // Check if next move is feasible
            if new_y >= rows || new_x >= cols || grid[new_y][new_x] == '#' {
                continue;
            }

            // Only continue if we have a higher score for that position.
            // This reduces the number of solutions to explore.
            let new_state = ((new_y, new_x), (new_dy, new_dx));
            if *scores.get(&new_state).unwrap_or(&INFINITY) >= new_cost {
                scores.insert(new_state, new_cost);
                priority_queue.push(State {
                    cost: new_cost,
                    position: (new_y, new_x),
                    direction: (new_dy, new_dx),
                    tiles: {
                        let mut t = tiles.clone();
                        t.push((new_y, new_x));
                        t
                    },
                });
            }
        }
    }

    all_tiles.len()
}

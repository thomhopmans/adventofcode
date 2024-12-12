use crate::exercises::utils;
use std::collections::VecDeque;

pub const EXERCISE: usize = 12;

pub fn main() {
    let input_data = utils::load_data(EXERCISE);
    println!("Exercise {}A: {}", EXERCISE, run_a(&input_data));
    println!("Exercise {}B: {}", EXERCISE, run_b(&input_data));
}

pub fn run_a(input_data: &str) -> i32 {
    let grid = parse_map(input_data);
    let rows = grid.len();
    let cols = if rows > 0 { grid[0].len() } else { 0 };

    let mut visited = vec![vec![false; cols]; rows];
    let mut total_price = 0;

    for y in 0..rows {
        for x in 0..cols {
            if !visited[y][x] {
                let region_char = grid[y][x];
                let (visited_after, cells) = bfs(&grid, visited, y, x, region_char);
                visited = visited_after;

                let area = cells.len() as i32;
                let perimeter = get_perimeter(&grid, &cells, rows, cols, region_char);
                total_price += area * perimeter;
            }
        }
    }

    total_price
}

pub fn run_b(input_data: &str) -> i32 {
    let grid = parse_map(input_data);
    let rows = grid.len();
    let cols = if rows > 0 { grid[0].len() } else { 0 };

    let mut visited = vec![vec![false; cols]; rows];
    let mut total_price = 0;

    for y in 0..rows {
        for x in 0..cols {
            if !visited[y][x] {
                let region_char = grid[y][x];
                let (visited_after, cells) = bfs(&grid, visited, y, x, region_char);
                visited = visited_after;

                total_price += (cells.len() as i32) * number_of_sides(&cells);
            }
        }
    }

    total_price
}

fn parse_map(input_data: &str) -> Vec<Vec<char>> {
    input_data
        .trim()
        .lines()
        .map(|line| line.chars().collect())
        .collect()
}

fn bfs(
    grid: &Vec<Vec<char>>,
    mut visited: Vec<Vec<bool>>,
    start_y: usize,
    start_x: usize,
    region_char: char,
) -> (Vec<Vec<bool>>, Vec<(usize, usize)>) {
    let rows = grid.len();
    let cols = if rows > 0 { grid[0].len() } else { 0 };

    visited[start_y][start_x] = true;
    let mut queue = VecDeque::new();
    queue.push_back((start_y, start_x));
    let mut cells = vec![(start_y, start_x)];

    while let Some((y, x)) = queue.pop_front() {
        for (ny, nx) in neighbors(y, x) {
            if in_bounds(ny, nx, rows, cols) && !visited[ny][nx] && grid[ny][nx] == region_char {
                visited[ny][nx] = true;
                queue.push_back((ny, nx));
                cells.push((ny, nx));
            }
        }
    }

    (visited, cells)
}

fn get_perimeter(
    grid: &Vec<Vec<char>>,
    cells: &[(usize, usize)],
    rows: usize,
    cols: usize,
    region_char: char,
) -> i32 {
    let mut perimeter = 0;
    for &(r, c) in cells {
        for (ny, nx) in neighbors(r, c) {
            if !in_bounds(ny, nx, rows, cols) || grid[ny][nx] != region_char {
                perimeter += 1;
            }
        }
    }
    perimeter
}

fn number_of_sides(cells: &[(usize, usize)]) -> i32 {
    let mut edges = 0;

    let min_y = cells.iter().map(|&(y, _)| y).min().unwrap();
    let max_y = cells.iter().map(|&(y, _)| y).max().unwrap();
    let min_x = cells.iter().map(|&(_, x)| x).min().unwrap();
    let max_x = cells.iter().map(|&(_, x)| x).max().unwrap();

    let cell_set: std::collections::HashSet<_> = cells.iter().copied().collect();

    // Iterate over Y, count top and bottom edges
    for y in min_y..=max_y {
        let mut top_was_edge = false;
        let mut bottom_was_edge = false;
        for x in min_x..=max_x {
            let top_is_edge =
                cell_set.contains(&(y, x)) && !cell_set.contains(&(y.wrapping_sub(1), x));
            let bottom_is_edge = cell_set.contains(&(y, x)) && !cell_set.contains(&(y + 1, x));

            if top_is_edge && !top_was_edge {
                edges += 1;
            }
            if bottom_is_edge && !bottom_was_edge {
                edges += 1;
            }

            top_was_edge = top_is_edge;
            bottom_was_edge = bottom_is_edge;
        }
    }

    // Iterate over X, count left and right edges
    for x in min_x..=max_x {
        let mut left_was_edge = false;
        let mut right_was_edge = false;
        for y in min_y..=max_y {
            let left_is_edge =
                cell_set.contains(&(y, x)) && !cell_set.contains(&(y, x.wrapping_sub(1)));
            let right_is_edge = cell_set.contains(&(y, x)) && !cell_set.contains(&(y, x + 1));

            if left_is_edge && !left_was_edge {
                edges += 1;
            }
            if right_is_edge && !right_was_edge {
                edges += 1;
            }

            left_was_edge = left_is_edge;
            right_was_edge = right_is_edge;
        }
    }

    edges
}

fn in_bounds(y: usize, x: usize, rows: usize, cols: usize) -> bool {
    y < rows && x < cols
}

fn neighbors(y: usize, x: usize) -> Vec<(usize, usize)> {
    // Safe subtraction handled by checking bounds elsewhere
    let candidates = [
        (y.wrapping_sub(1), x),
        (y + 1, x),
        (y, x.wrapping_sub(1)),
        (y, x + 1),
    ];

    candidates.to_vec()
}

use crate::exercises::utils;

pub const EXERCISE: usize = 4;
const DIRECTIONS: [(isize, isize); 8] = [
    (0, 1),   // right
    (0, -1),  // left
    (1, 0),   // bottom
    (-1, 0),  // top
    (1, 1),   // bottom-right
    (-1, -1), // top-left
    (1, -1),  // bottom-left
    (-1, 1),  // top-right
];

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

    let word = "XMAS".chars().collect::<Vec<char>>();
    DIRECTIONS
        .iter()
        .map(|&(dx, dy)| count_xmas_occurrences(&grid, &word, dx, dy))
        .sum()
}

pub fn run_b(input_data: &str) -> usize {
    let grid: Vec<Vec<char>> = input_data
        .lines()
        .map(|line| line.chars().collect())
        .collect();

    count_xmas_patterns(&grid)
}

fn count_xmas_occurrences(grid: &[Vec<char>], word: &[char], dx: isize, dy: isize) -> usize {
    let rows = grid.len() as isize;
    let cols = grid[0].len() as isize;
    let word_length = word.len() as isize;
    let mut count = 0;

    for x in 0..rows {
        for y in 0..cols {
            let mut match_found = true;

            for k in 0..word_length {
                let nx = x + k * dx;
                let ny = y + k * dy;

                if nx < 0
                    || ny < 0
                    || nx >= rows
                    || ny >= cols
                    || grid[nx as usize][ny as usize] != word[k as usize]
                {
                    match_found = false;
                    break;
                }
            }

            if match_found {
                count += 1;
            }
        }
    }

    count
}

fn count_xmas_patterns(grid: &[Vec<char>]) -> usize {
    let mut matches = 0;
    let rows = grid.len();
    let cols = grid[0].len();

    for x in 1..rows - 1 {
        for y in 1..cols - 1 {
            if grid[x][y] == 'A' && is_xmas_pattern(grid, x, y) {
                matches += 1;
            }
        }
    }

    matches
}

fn is_xmas_pattern(grid: &[Vec<char>], x: usize, y: usize) -> bool {
    let patterns = [
        ('M', 'M', 'S', 'S'),
        ('S', 'M', 'M', 'S'),
        ('S', 'S', 'M', 'M'),
        ('M', 'S', 'S', 'M'),
    ];

    let neighbors = (
        grid[x - 1][y - 1],
        grid[x - 1][y + 1],
        grid[x + 1][y + 1],
        grid[x + 1][y - 1],
    );

    patterns.iter().any(|&pattern| neighbors == pattern)
}

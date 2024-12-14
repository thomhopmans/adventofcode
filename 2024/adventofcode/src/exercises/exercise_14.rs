use crate::exercises::utils;
use std::collections::HashMap;

pub const EXERCISE: usize = 14;

#[derive(Debug, Clone)]
struct Robot {
    position: (i32, i32),
    velocity: (i32, i32),
}

pub fn main() {
    let input_data = utils::load_data(EXERCISE);
    println!("Exercise {}A: {}", EXERCISE, run_a(&input_data, 101, 103));
    println!("Exercise {}B: {}", EXERCISE, run_b(&input_data));
}

pub fn run_a(input_data: &str, width: i32, height: i32) -> i32 {
    let robots = parse_robots(input_data);

    // Simulate the positions after 100 seconds
    let seconds = 100;
    let positions: Vec<(i32, i32)> = robots
        .iter()
        .map(|robot| {
            get_position_after_time(robot.position, robot.velocity, seconds, width, height)
        })
        .collect();

    // Count robots in each quadrant
    let mut grid_counts: HashMap<(i32, i32), i32> = HashMap::new();
    for position in positions {
        *grid_counts.entry(position).or_insert(0) += 1;
    }

    let mut quadrants = vec![0, 0, 0, 0]; // Top-left, top-right, bottom-left, bottom-right

    for ((x, y), count) in grid_counts {
        if x != width / 2 && y != height / 2 {
            if x < width / 2 && y < height / 2 {
                quadrants[0] += count;
            } else if x >= width / 2 && y < height / 2 {
                quadrants[1] += count;
            } else if x < width / 2 && y >= height / 2 {
                quadrants[2] += count;
            } else if x >= width / 2 && y >= height / 2 {
                quadrants[3] += count;
            }
        }
    }

    // Output safety factor
    quadrants.iter().product()
}

pub fn run_b(input_data: &str) -> i32 {
    let width = 101;
    let height = 103;

    let robots = parse_robots(input_data);

    let mut seconds = 517;
    loop {
        let positions: Vec<(i32, i32)> = robots
            .iter()
            .map(|robot| {
                get_position_after_time(robot.position, robot.velocity, seconds, width, height)
            })
            .collect();

        let n_consecutive = max_consecutive_robots_in_row(&positions, width, height);

        if n_consecutive >= 31 {
            print_grid(&positions, width, height);
            break;
        }

        seconds += 1;
    }

    seconds
}

fn parse_robots(data: &str) -> Vec<Robot> {
    let mut robots = Vec::new();
    for line in data.lines() {
        if let Some(captures) = regex::Regex::new(r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)")
            .unwrap()
            .captures(line)
        {
            let px = captures[1].parse().unwrap();
            let py = captures[2].parse().unwrap();
            let vx = captures[3].parse().unwrap();
            let vy = captures[4].parse().unwrap();
            robots.push(Robot {
                position: (px, py),
                velocity: (vx, vy),
            });
        }
    }
    robots
}

fn get_position_after_time(
    position: (i32, i32),
    velocity: (i32, i32),
    time: i32,
    width: i32,
    height: i32,
) -> (i32, i32) {
    (
        (position.0 + velocity.0 * time).rem_euclid(width),
        (position.1 + velocity.1 * time).rem_euclid(height),
    )
}

fn max_consecutive_robots_in_row(positions: &[(i32, i32)], width: i32, height: i32) -> i32 {
    let grid = create_grid(positions, width, height);

    let mut max_consecutive = 0;
    for row in grid {
        let mut current_streak = 0;
        for &cell in &row {
            if cell > 0 {
                current_streak += cell;
                max_consecutive = max_consecutive.max(current_streak);
            } else {
                current_streak = 0;
            }
        }
    }

    max_consecutive
}

fn create_grid(positions: &[(i32, i32)], width: i32, height: i32) -> Vec<Vec<i32>> {
    let mut grid = vec![vec![0; width as usize]; height as usize];

    let mut position_counts: HashMap<(i32, i32), i32> = HashMap::new();
    for &position in positions {
        *position_counts.entry(position).or_insert(0) += 1;
    }

    for ((x, y), count) in position_counts {
        grid[y as usize][x as usize] = count;
    }

    grid
}

fn print_grid(positions: &[(i32, i32)], width: i32, height: i32) {
    let mut grid = vec![vec!['.'; width as usize]; height as usize];

    let mut position_counts: HashMap<(i32, i32), i32> = HashMap::new();
    for &position in positions {
        *position_counts.entry(position).or_insert(0) += 1;
    }

    for ((x, y), count) in position_counts {
        grid[y as usize][x as usize] = if count > 1 {
            (b'0' + count as u8) as char
        } else {
            '1'
        };
    }

    for row in grid {
        println!("{}", row.iter().collect::<String>());
    }
}

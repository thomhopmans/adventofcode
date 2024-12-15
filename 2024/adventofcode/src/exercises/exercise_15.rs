use crate::exercises::utils;

pub const EXERCISE: usize = 15;

pub fn main() {
    let input_data = utils::load_data(EXERCISE);
    println!("Exercise {}A: {}", EXERCISE, run_a(&input_data));
    println!("Exercise {}B: {}", EXERCISE, run_b(&input_data));
}
pub fn run_a(input_data: &str) -> i32 {
    let (mut grid, moves) = parse_input(input_data);

    let mut robot_pos = find_robot(&grid).expect("Robot not found");
    for m in moves.chars() {
        robot_pos = move_robot_a(&mut grid, robot_pos, m);
    }

    calculate_score(&grid)
}

pub fn run_b(input_data: &str) -> i32 {
    let (mut grid, moves) = parse_input(input_data);
    grid = double_warehouse(&grid);

    let mut robot_pos = find_robot(&grid).expect("Robot not found");
    for m in moves.chars() {
        robot_pos = move_robot_b(&mut grid, robot_pos, m);
    }

    calculate_score(&grid)
}

fn parse_input(input_data: &str) -> (Vec<Vec<char>>, String) {
    let trimmed = input_data.trim();
    let parts: Vec<&str> = trimmed.split("\n\n").collect();
    let map_str = parts[0];
    let moves_str = parts[1];

    let warehouse_map: Vec<Vec<char>> = map_str.lines().map(|l| l.chars().collect()).collect();
    let moves: String = moves_str.lines().collect();
    (warehouse_map, moves)
}

#[allow(dead_code)]
fn print_grid(grid: &Vec<Vec<char>>) {
    for row in grid {
        let line: String = row.iter().collect();
        println!("{}", line);
    }
}

fn double_warehouse(map_str: &Vec<Vec<char>>) -> Vec<Vec<char>> {
    let mut doubled_map = Vec::new();
    for line in map_str {
        let mut doubled_line = String::new();
        for &ch in line {
            match ch {
                '#' => doubled_line.push_str("##"),
                'O' => doubled_line.push_str("[]"),
                '.' => doubled_line.push_str(".."),
                '@' => doubled_line.push_str("@."),
                _ => doubled_line.push(ch),
            }
        }
        doubled_map.push(doubled_line.chars().collect());
    }
    doubled_map
}

fn move_robot_a(
    warehouse_map: &mut Vec<Vec<char>>,
    robot_pos: (usize, usize),
    move_cmd: char,
) -> (usize, usize) {
    let (rows, cols) = (warehouse_map.len(), warehouse_map[0].len());
    let (r, c) = robot_pos;

    // Map directions to movement deltas
    let directions = [('^', (-1, 0)), ('v', (1, 0)), ('<', (0, -1)), ('>', (0, 1))];
    let (dr, dc) = directions.iter().find(|&&(d, _)| d == move_cmd).unwrap().1;

    // Calculate new position of the robot
    let new_r = if dr == -1 {
        if r == 0 {
            return robot_pos;
        } else {
            r - 1
        }
    } else if dr == 1 {
        if r + 1 >= rows {
            return robot_pos;
        } else {
            r + 1
        }
    } else {
        r
    };

    // Check boundaries
    let new_c = if dc == -1 {
        if c == 0 {
            return robot_pos;
        } else {
            c - 1
        }
    } else if dc == 1 {
        if c + 1 >= cols {
            return robot_pos;
        } else {
            c + 1
        }
    } else {
        c
    };

    // Determine what is in the target cell
    let target_cell = warehouse_map[new_r][new_c];

    match target_cell {
        '#' => robot_pos, // Wall: no movement
        '.' => {
            // Free space: move robot
            warehouse_map[r][c] = '.';
            warehouse_map[new_r][new_c] = '@';
            (new_r, new_c)
        }
        'O' => {
            // Box: attempt to push
            if push_box_a(warehouse_map, new_r, new_c, dr, dc) {
                warehouse_map[r][c] = '.';
                warehouse_map[new_r][new_c] = '@';
                (new_r, new_c)
            } else {
                robot_pos
            }
        }
        _ => robot_pos,
    }
}

fn push_box_a(
    warehouse_map: &mut Vec<Vec<char>>,
    box_r: usize,
    box_c: usize,
    dr: i32,
    dc: i32,
) -> bool {
    let (rows, cols) = (warehouse_map.len(), warehouse_map[0].len());

    // Check boundaries are valid
    let new_box_r = if dr == -1 {
        if box_r == 0 {
            return false;
        }
        box_r - 1
    } else if dr == 1 {
        if box_r + 1 >= rows {
            return false;
        }
        box_r + 1
    } else {
        box_r
    };

    let new_box_c = if dc == -1 {
        if box_c == 0 {
            return false;
        }
        box_c - 1
    } else if dc == 1 {
        if box_c + 1 >= cols {
            return false;
        }
        box_c + 1
    } else {
        box_c
    };

    let target = warehouse_map[new_box_r][new_box_c];
    if target == '.' {
        // Space available to push
        warehouse_map[box_r][box_c] = '.';
        warehouse_map[new_box_r][new_box_c] = 'O';
        true
    } else if target == 'O' {
        // Another box: attempt to push it recursively
        if push_box_a(warehouse_map, new_box_r, new_box_c, dr, dc) {
            warehouse_map[box_r][box_c] = '.';
            warehouse_map[new_box_r][new_box_c] = 'O';
            true
        } else {
            false
        }
    } else {
        false
    }
}

fn move_robot_b(
    warehouse_map: &mut Vec<Vec<char>>,
    robot_pos: (usize, usize),
    move_cmd: char,
) -> (usize, usize) {
    let (rows, cols) = (warehouse_map.len(), warehouse_map[0].len());
    let (r, c) = robot_pos;

    // Map directions to movement deltas
    let directions = [('^', (-1, 0)), ('v', (1, 0)), ('<', (0, -1)), ('>', (0, 1))];
    let (dr, dc) = directions.iter().find(|&&(d, _)| d == move_cmd).unwrap().1;

    // Calculate new position of the robot
    let new_r = if dr == -1 {
        if r == 0 {
            return robot_pos;
        } else {
            r - 1
        }
    } else if dr == 1 {
        if r + 1 >= rows {
            return robot_pos;
        } else {
            r + 1
        }
    } else {
        r
    };

    // Check boundaries
    let new_c = if dc == -1 {
        if c == 0 {
            return robot_pos;
        } else {
            c - 1
        }
    } else if dc == 1 {
        if c + 1 >= cols {
            return robot_pos;
        } else {
            c + 1
        }
    } else {
        c
    };

    // Determine what is in the target cell
    let target_cell = warehouse_map[new_r][new_c];

    // Use left side of the box as reference point
    let new_box_c = if target_cell == ']' {
        if new_c == 0 {
            return robot_pos;
        }
        new_c - 1
    } else {
        new_c
    };

    let mut boxes_to_move = Vec::new();
    let mut hit_wall = false;

    match target_cell {
        '#' => {
            // Wall: no movement
            return robot_pos;
        }
        '.' => {
            // Free space: move robot
            warehouse_map[r][c] = '.';
            warehouse_map[new_r][new_c] = '@';
            return (new_r, new_c);
        }
        '[' | ']' => {
            if dc == 1 || dc == -1 {
                // Box to the left or right
                let (moved, hw) = push_box_b(
                    warehouse_map,
                    new_r,
                    new_box_c,
                    dr,
                    dc,
                    boxes_to_move,
                    false,
                );
                boxes_to_move = moved;
                hit_wall = hw;
            } else if dr == 1 || dr == -1 {
                // Box above or below
                let (moved, hw) = push_box_b(
                    warehouse_map,
                    new_r,
                    new_box_c,
                    dr,
                    dc,
                    boxes_to_move,
                    false,
                );
                boxes_to_move = moved;
                hit_wall = hw;
            }
        }
        _ => {}
    }

    // Apply moves if we do not hit the wall
    if !hit_wall {
        apply_moves(warehouse_map, &boxes_to_move);
        warehouse_map[r][c] = '.';
        warehouse_map[new_r][new_c] = '@';
        return (new_r, new_c);
    }

    robot_pos
}

fn push_box_b(
    warehouse_map: &mut Vec<Vec<char>>,
    box_r: usize,
    box_c: usize,
    dr: i32,
    dc: i32,
    mut boxes_to_move: Vec<(usize, usize, i32, i32)>,
    hit_wall: bool,
) -> (Vec<(usize, usize, i32, i32)>, bool) {
    let (rows, cols) = (warehouse_map.len(), warehouse_map[0].len());

    // Check boundaries and whether the next position is valid
    let new_box_r = if dr == -1 {
        if box_r == 0 {
            return (boxes_to_move, true);
        }
        box_r - 1
    } else if dr == 1 {
        if box_r + 1 >= rows {
            return (boxes_to_move, true);
        }
        box_r + 1
    } else {
        box_r
    };

    let new_box_c = if dc == -1 {
        if box_c == 0 {
            return (boxes_to_move, true);
        }
        box_c - 1
    } else if dc == 1 {
        if box_c + 1 >= cols {
            return (boxes_to_move, true);
        }
        box_c + 1
    } else {
        box_c
    };

    if new_box_c + 1 >= cols {
        return (boxes_to_move, true);
    }

    // If we hit the wall, we do not move anything
    let target = &warehouse_map[new_box_r][new_box_c..new_box_c + 2];
    if target.contains(&'#') {
        return (Vec::new(), true);
    } else {
        boxes_to_move.push((box_r, box_c, dr, dc));
    }

    if dc == -1 {
        // Move left
        if target[0] == '.' {
            // Space available to push by 1 position to left
            return (boxes_to_move, hit_wall);
        } else if target == [']', '['] {
            // Another box: attempt to push it recursively
            let (m, h) = push_box_b(
                warehouse_map,
                new_box_r,
                new_box_c - 1,
                dr,
                dc,
                boxes_to_move,
                hit_wall,
            );
            return (m, h);
        } else {
            panic!("Unexpected pattern in push_box_b (dc == -1)");
        }
    } else if dc == 1 {
        // Move right
        if target[1] == '.' {
            // Space available to push by 1 position to right
            return (boxes_to_move, hit_wall);
        } else if target == [']', '['] {
            // Another box: attempt to push it recursively
            let (m, h) = push_box_b(
                warehouse_map,
                new_box_r,
                new_box_c + 1,
                dr,
                dc,
                boxes_to_move,
                hit_wall,
            );
            return (m, h);
        } else {
            panic!("Unexpected pattern in push_box_b (dc == 1)");
        }
    } else if dr == -1 || dr == 1 {
        // Move up or down
        match target {
            ['[', ']'] => {
                let (m, h) = push_box_b(
                    warehouse_map,
                    new_box_r,
                    new_box_c,
                    dr,
                    dc,
                    boxes_to_move,
                    hit_wall,
                );
                return (m, h);
            }
            [']', '['] => {
                // Two stacked boxes, add both to moves and recursively push upward
                let (m1, h1) = push_box_b(
                    warehouse_map,
                    new_box_r,
                    new_box_c - 1,
                    dr,
                    dc,
                    boxes_to_move,
                    hit_wall,
                );
                let (m2, h2) = push_box_b(warehouse_map, new_box_r, new_box_c + 1, dr, dc, m1, h1);
                return (m2, h2);
            }
            ['.', '['] => {
                // Space followed by left part of a box, move this box
                let (m, h) = push_box_b(
                    warehouse_map,
                    new_box_r,
                    new_box_c + 1,
                    dr,
                    dc,
                    boxes_to_move,
                    hit_wall,
                );
                return (m, h);
            }
            [']', '.'] => {
                // Right part of a box followed by space, move this box
                let (m, h) = push_box_b(
                    warehouse_map,
                    new_box_r,
                    new_box_c - 1,
                    dr,
                    dc,
                    boxes_to_move,
                    hit_wall,
                );
                return (m, h);
            }
            ['.', '.'] => {
                // Free space above, move the box
                return (boxes_to_move, hit_wall);
            }
            _ => panic!("Unexpected pattern in push_box_b (vertical move)"),
        }
    }

    panic!("Unexpected case in push_box_b");
}

fn apply_moves(warehouse_map: &mut Vec<Vec<char>>, boxes_to_move: &[(usize, usize, i32, i32)]) {
    let mut boxes_to_move = boxes_to_move.to_vec();
    boxes_to_move.reverse();

    // Ensure moving boxes in correct sequential order when moving up or down
    let dr = boxes_to_move[0].2;
    if dr == 1 {
        boxes_to_move.sort_by(|a, b| b.0.cmp(&a.0));
    } else if dr == -1 {
        boxes_to_move.sort_by(|a, b| a.0.cmp(&b.0));
    }

    for (box_r, box_c, dr, dc) in boxes_to_move {
        let (box_r_i, box_c_i) = (box_r as isize, box_c as isize);
        let (dr_i, dc_i) = (dr as isize, dc as isize);

        let new_box_r = (box_r_i + dr_i) as usize;
        let new_box_c = (box_c_i + dc_i) as usize;

        if dr != 0 {
            // Vertical move
            warehouse_map[new_box_r][new_box_c] = '[';
            warehouse_map[new_box_r][new_box_c + 1] = ']';
            warehouse_map[box_r][box_c] = '.';
            warehouse_map[box_r][box_c + 1] = '.';
        } else {
            // Horizontal move
            warehouse_map[box_r][box_c] = '.';
            warehouse_map[new_box_r][new_box_c] = '[';
            warehouse_map[new_box_r][new_box_c + 1] = ']';
        }
    }
}

fn find_robot(warehouse_map: &Vec<Vec<char>>) -> Option<(usize, usize)> {
    for (r, row) in warehouse_map.iter().enumerate() {
        for (c, &cell) in row.iter().enumerate() {
            if cell == '@' {
                return Some((r, c));
            }
        }
    }
    None
}

fn calculate_score(warehouse_map: &Vec<Vec<char>>) -> i32 {
    let mut score: i32 = 0;
    for (r, row) in warehouse_map.iter().enumerate() {
        for (c, &cell) in row.iter().enumerate() {
            if cell == '[' || cell == 'O' {
                let gps_coordinate = 100 * (r as i32) + (c as i32);
                score += gps_coordinate;
            }
        }
    }
    score
}

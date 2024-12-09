use crate::exercises::utils;

pub const EXERCISE: usize = 9;

pub fn main() {
    let input_data = utils::load_data(EXERCISE);
    println!("Exercise {}A: {}", EXERCISE, run_a(&input_data));
    println!("Exercise {}B: {}", EXERCISE, run_b(&input_data));
}

#[derive(Debug, Clone)]
struct Block {
    id: Option<u64>,
    length: usize,
}

pub fn run_a(input_data: &str) -> i64 {
    let disk_map = parse_diskmap(input_data.trim());
    let result = compact_filesystem_a(disk_map);
    calculate_checksum(&result)
}

pub fn run_b(input_data: &str) -> i64 {
    let disk_map = parse_diskmap(input_data.trim());
    let result = compact_filesystem_b(disk_map);
    calculate_checksum(&result)
}

fn compact_filesystem_a(mut disk_map: Vec<Block>) -> Vec<Block> {
    let mut result = Vec::new();

    let mut free_block = disk_map.remove(0);
    let mut data_block = disk_map.pop().expect("Expected a block");

    while !disk_map.is_empty() {
        // We have a popped a free block at the front and a data block at the back. Start moving data.
        if free_block.id.is_none() && data_block.id.is_some() {
            // Equal block size
            if data_block.length == free_block.length {
                result.push(data_block.clone());
                free_block = disk_map.remove(0);
                data_block = disk_map.pop().expect("Expected a block");
            }
            // Free block shorter then data block
            else if free_block.length < data_block.length {
                result.push(Block {
                    id: data_block.id,
                    length: free_block.length,
                });
                data_block.length -= free_block.length;
                free_block = disk_map.remove(0);
            }
            // Free block larger than data block
            else {
                free_block.length -= data_block.length;
                result.push(data_block.clone());
                data_block = disk_map.pop().expect("Expected a block");
            }
        }
        // Popped forward block is not a free block
        else if free_block.id.is_some() {
            result.push(free_block.clone());
            free_block = disk_map.remove(0);
        }
        // Popped last block is not a data block
        else {
            data_block = disk_map.pop().expect("Expected a block");
        }
    }

    // Last iteration. Data is such that this is always a data block.
    result.push(data_block);
    result
}

fn compact_filesystem_b(mut disk_map: Vec<Block>) -> Vec<Block> {
    let mut result = Vec::new();
    let mut last_id = u64::MAX;
    let mut data_block = disk_map.pop().expect("Expected a block");

    while last_id > 1 {
        if let Some(id) = data_block.id {
            // Skipping data block because id has already been moved
            if id > last_id {
                result.insert(0, data_block);
                data_block = disk_map.pop().expect("Expected a block");
                continue;
            }

            last_id = id;

            // Popped block is a data block. Find first possible free block to move data to.
            let mut forward_index = 0;
            while forward_index < disk_map.len() {
                let free_block = &mut disk_map[forward_index];
                if free_block.id.is_none() && free_block.length >= data_block.length {
                    // Split the free block to fit the data block
                    let remaining_length = free_block.length - data_block.length;

                    // Replace the free block with the data block
                    free_block.id = data_block.id;
                    free_block.length = data_block.length;

                    // If there is remaining space, insert a new free block
                    if remaining_length > 0 {
                        disk_map.insert(
                            forward_index + 1,
                            Block {
                                id: None,
                                length: remaining_length,
                            },
                        );
                    }

                    // Update the data block to indicate it has been moved
                    data_block = Block {
                        id: None,
                        length: data_block.length,
                    };

                    break;
                } else {
                    forward_index += 1;
                }
            }

            // No suitable free block found for data block
            if forward_index == disk_map.len() {
                result.insert(0, data_block);
                data_block = disk_map.pop().expect("Expected a block");
            }
        }
        // Find the last data block
        else {
            result.insert(0, data_block);
            data_block = disk_map.pop().expect("Expected a block");
        }
    }

    let mut final_result = disk_map.into_iter().collect::<Vec<_>>();
    final_result.push(data_block);
    final_result.extend(result);
    final_result
}

fn parse_diskmap(input_data: &str) -> Vec<Block> {
    let mut disk_map = Vec::new();
    let mut is_file = true;
    let mut id = 0;

    for digit in input_data.chars() {
        let length = digit.to_digit(10).unwrap() as usize;
        if is_file {
            disk_map.push(Block {
                id: Some(id),
                length,
            });
            id += 1;
        } else {
            disk_map.push(Block { id: None, length });
        }
        is_file = !is_file;
    }

    disk_map
}

fn calculate_checksum(result: &[Block]) -> i64 {
    let mut checksum = 0;
    let mut position = 0;

    for block in result {
        for _ in 0..block.length {
            if let Some(id) = block.id {
                checksum += position * id as i64;
            }
            position += 1;
        }
    }

    checksum
}

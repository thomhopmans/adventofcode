import {readFileSync} from 'fs';

interface fileSystem {
  directories: directory[];
  files: file[];
}

interface file {
  key: string;
  size: number;
}

interface directory {
  key: string;
  size: number;
}

function run7A(data: string) {
  // Map file system
  const fileSystem = mapFileSystem(data);

  // Sum size of 'small' directories
  let result = 0;
  fileSystem.directories.forEach(dir => {
    if (dir.size <= 100000) {
      result += dir.size;
    }
  });

  return result;
}

function run7B(data: string) {
  // Settings
  const maxFileSystemSpace = 70000000;
  const minAvailableSpace = 30000000;

  // Map Files
  const fileSystem = mapFileSystem(data);

  // Find directory to delete that frees enough space for update
  const totalSpaceUsed = fileSystem.directories.filter(i => i.key === '/')[0]
    .size;
  const unusedSpace = maxFileSystemSpace - totalSpaceUsed;

  const deleteDirectorySize = fileSystem.directories
    .sort((a, b) => (a.size < b.size ? -1 : a.size > b.size ? 1 : 0))
    .filter(i => unusedSpace + i.size >= minAvailableSpace)[0].size;

  return deleteDirectorySize;
}

function mapFileSystem(data: string): fileSystem {
  const files: file[] = [];
  const directories: directory[] = [];
  const currentPath: string[] = [];

  // Iterate over all commands
  data.split('\n').forEach(item => {
    // User command
    if (item.startsWith('$ ')) {
      const commands = item.split(' ');
      const command = commands[1];
      const to = commands[2];

      if (command === 'cd' && to !== '..') {
        currentPath.push(to.endsWith('/') ? to : to + '/');
        directories.push({key: currentPath.join(''), size: 0});
      } else if (command === 'cd' && to === '..') {
        currentPath.pop();
      }
    }
    // List directories / files
    else if (!item.startsWith('dir ')) {
      const fileSize = item.split(' ')[0];
      const fileName = item.split(' ')[1];
      files.push({
        key: currentPath.join('') + fileName,
        size: parseInt(fileSize),
      });
    }
  });

  // Calculate directory sizes
  directories.forEach(dir => {
    const dirSize = getKeysMatchingPrefix(files, dir.key)
      .map(i => i.size)
      .reduce((sum, x) => sum + x);
    dir.size = dirSize;
  });

  return {
    directories: directories,
    files: files,
  };
}

function getKeysMatchingPrefix(fileSystem: file[], prefix: string) {
  return fileSystem.filter(item => item.key.startsWith(prefix));
}

// Run
const input7Data = readFileSync('./inputs/input_7.txt', 'utf-8');

export {run7A, run7B, input7Data};

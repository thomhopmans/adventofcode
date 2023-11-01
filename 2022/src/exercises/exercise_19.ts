import {readFileSync} from 'fs';

const ORE = 0;
const CLAY = 1;
const OBSIDIAN = 2;
const GEODE = 3;

function run19A(data: string) {
  const blueprints = parseBlueprints(data);
  const maxMinutes = 24;

  let totalQualityLevel = 0;
  blueprints.forEach((blueprint, index) => {
    let geodes = calculateBlueprint(blueprint, maxMinutes);
    let qualityLevel = (index + 1) * geodes;
    totalQualityLevel += qualityLevel;
  });

  return totalQualityLevel;
}

function run19B(data: string) {
  const blueprints = parseBlueprints(data).slice(0, 3);
  const maxMinutes = 32;

  let totalQualityLevel = 1;
  blueprints.forEach((blueprint, index) => {
    let geodes = calculateBlueprint(blueprint, maxMinutes);
    totalQualityLevel *= geodes;
  });

  return totalQualityLevel;
}

function calculateBlueprint(
  blueprint: Map<number, number[]>,
  maxMinutes: number
) {
  // Start
  const maxRobots = robotMaximum(blueprint);
  let inventory = [0, 0, 0, 0]; // ore, clay, obsidian, geode
  let robotState = [1, 0, 0, 0]; // ore, clay, obsidian, geode

  let maxGeodes = 0;
  let minute = 0;

  let cache = new Map();

  runCycle(blueprint, minute, [...inventory], [...robotState], ORE, maxMinutes);
  runCycle(
    blueprint,
    minute,
    [...inventory],
    [...robotState],
    CLAY,
    maxMinutes
  );

  function runCycle(
    blueprint: Map<number, number[]>,
    minute: number,
    inventory: number[],
    robotState: number[],
    materialGoal: number,
    maxMinutes: number
  ) {
    // Prune strategies that even in optimistic cases do not improve solution
    let currentGeodes = inventory[3];
    let currentGeodeRobots = robotState[3];
    let optimisticScore = currentGeodes;
    for (let t = minute; t < maxMinutes; t++) {
      optimisticScore += currentGeodeRobots;
      currentGeodeRobots += 1;
    }
    if (optimisticScore < maxGeodes) return;

    // Calculate minute whe goal robot can be build
    const materialRequirements = blueprint.get(materialGoal) || [];
    let currentInventory = inventory.slice(0, 3);

    let missingMaterial = materialRequirements
      .map((q, index) => q - currentInventory[index])
      .map((q, index) =>
        robotState[index] > 0 ? q / robotState[index] : q > 0 ? NaN : 0
      );

    if (missingMaterial.includes(NaN)) {
      // Impossibru
      return;
    }
    let waitMinutesForBuild =
      Math.max(0, Math.ceil(Math.max(...missingMaterial))) + 1;

    // No more time left?
    if (minute + waitMinutesForBuild > maxMinutes) {
      let delta = maxMinutes - minute;
      inventory[GEODE] += robotState[GEODE] * delta;

      if (inventory[GEODE] > maxGeodes) {
        maxGeodes = inventory[3];
      }
      return;
    }

    // Add inventory
    inventory[ORE] += robotState[ORE] * waitMinutesForBuild;
    inventory[CLAY] += robotState[CLAY] * waitMinutesForBuild;
    inventory[OBSIDIAN] += robotState[OBSIDIAN] * waitMinutesForBuild;
    inventory[GEODE] += robotState[GEODE] * waitMinutesForBuild;

    // Decrease inventory
    inventory[ORE] -= materialRequirements[ORE];
    inventory[CLAY] -= materialRequirements[CLAY];
    inventory[OBSIDIAN] -= materialRequirements[OBSIDIAN];

    // Build robot
    robotState[materialGoal] += 1;

    [ORE, CLAY, OBSIDIAN, GEODE].forEach(goal => {
      // Check if we have already enough?
      if (robotState[ORE] > maxRobots[ORE]) return;
      if (robotState[CLAY] > maxRobots[CLAY]) return;
      if (robotState[OBSIDIAN] > maxRobots[OBSIDIAN]) return;

      // Run
      runCycle(
        blueprint,
        minute + waitMinutesForBuild,
        [...inventory],
        [...robotState],
        goal,
        maxMinutes
      );
    });

    return;
  }

  return maxGeodes;
}

function robotMaximum(bp: Map<number, number[]>) {
  let maximums = [0, 0, 0];
  bp.forEach((value, _) => {
    [ORE, CLAY, OBSIDIAN].forEach(key => {
      if (maximums[key] < value[key]) {
        maximums[key] = value[key];
      }
    });
  });
  return maximums;
}

function parseBlueprints(data: string) {
  return data.split('\n').map((line, index) => {
    const [oreRobot, clayRobot, obsidianRobot, geodeRobot] = line.split('.');

    const oreRegexPattern = /costs (\d+) ore/;
    const clayRegexPattern = /and (\d+) clay/;
    const obsidianRegexPattern = /and (\d+) obsidian/;

    const oreRobotOre = oreRobot.match(oreRegexPattern) || [];
    const clayRobotOre = clayRobot.match(oreRegexPattern) || [];

    const obsidianRobotOre = obsidianRobot.match(oreRegexPattern) || [];
    const obsidianRobotClay = obsidianRobot.match(clayRegexPattern) || [];

    const geodeRobotOre = geodeRobot.match(oreRegexPattern) || [];
    const geodeRobotObsidian = geodeRobot.match(obsidianRegexPattern) || [];

    const map = new Map();
    map.set(ORE, [parseInt(oreRobotOre[1]), 0, 0]);
    map.set(CLAY, [parseInt(clayRobotOre[1]), 0, 0]);
    map.set(OBSIDIAN, [
      parseInt(obsidianRobotOre[1]),
      parseInt(obsidianRobotClay[1]),
      0,
    ]);
    map.set(GEODE, [
      parseInt(geodeRobotOre[1]),
      0,
      parseInt(geodeRobotObsidian[1]),
    ]);

    return map;
  });
}

const input19Data = readFileSync('./inputs/input_19.txt', 'utf-8');

export {run19A, run19B, input19Data};

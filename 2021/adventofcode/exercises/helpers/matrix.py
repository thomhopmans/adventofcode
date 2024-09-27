from dataclasses import dataclass
import numpy as np

@dataclass
class Vector:
    x: int
    y: int
    z: int

    def __hash__(self):
        return "_".join(map(str, [self.x, self.y, self.z])).__hash__()

    def __add__(self, other: "Vector") -> "Vector":
        return Vector(
            self.x + other.x,
            self.y + other.y,
            self.z + other.z,
        )
    
    def delta(self, other: "Vector") -> "Vector":
        return Vector(
            self.x - other.x,
            self.y - other.y,
            self.z - other.z,
        )

    def distance(self, other: "Vector") -> int:
        return abs(self.x - other.x) + abs(self.y - other.y) + abs(self.z - other.z)

    def numpy(self):
        return np.array([self.x, self.y, self.z])

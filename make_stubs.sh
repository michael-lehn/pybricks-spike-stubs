mkdir -p stubs/pybricks

#-------------------------------------------------------------------------------

cat > pyrightconfig.json <<'EOF'
{
    "stubPath": "stubs",
    "typeCheckingMode": "basic",
    "reportMissingModuleSource": false,
}
EOF

#-------------------------------------------------------------------------------

cat > stubs/pybricks/__init__.pyi <<'EOF'
# Marker file so Pyright treats this as a package.
EOF

#-------------------------------------------------------------------------------

cat > stubs/pybricks/parameters.pyi <<'EOF'
from __future__ import annotations
from enum import Enum, IntEnum

class Port(Enum):
    A: Port
    B: Port
    C: Port
    D: Port
    E: Port
    F: Port

class Button(Enum):
    LEFT: Button
    RIGHT: Button
    CENTER: Button
    BLUETOOTH: Button

class Direction(IntEnum):
    CLOCKWISE = 1
    COUNTERCLOCKWISE = -1

class Stop(Enum):
    COAST: Stop
    BRAKE: Stop
    HOLD: Stop

class Color(Enum):
    BLACK: Color
    BLUE: Color
    GREEN: Color
    YELLOW: Color
    RED: Color
    WHITE: Color
    BROWN: Color
    ORANGE: Color
    PURPLE: Color
EOF

#-------------------------------------------------------------------------------

cat > stubs/pybricks/tools.pyi <<'EOF'
def wait(ms: int) -> None: ...
EOF

#-------------------------------------------------------------------------------

cat > stubs/pybricks/hubs.pyi <<'EOF'
from __future__ import annotations
from typing import Optional, Tuple
from pybricks.parameters import Button, Color

class _Buttons:
    def pressed(self) -> tuple[Button, ...]: ...

class _System:
    def set_stop_button(self, button: Optional[Button | tuple[Button, ...]]) -> None: ...
    def shutdown(self) -> None: ...
    def reset(self) -> None: ...

class _Light:
    def on(self, color: Color) -> None: ...
    def off(self) -> None: ...
    def blink(self, color: Color, intervals: tuple[int, int] = ...) -> None: ...

class _Display:
    def off(self) -> None: ...
    def on(self) -> None: ...
    def orientation(self, up: Button) -> None: ...
    def icon(self, matrix: Tuple[Tuple[int, ...], ...]) -> None: ...
    def number(self, n: int) -> None: ...
    def text(self, s: str) -> None: ...

class _IMU:
    # Returns (roll, pitch, yaw) in degrees (convention depends on firmware).
    def rotation(self) -> tuple[int, int, int]: ...
    # Common convenience forms (some firmwares provide one or the other):
    def heading(self) -> int: ...
    def reset_heading(self, value: int = ...) -> None: ...

class _Speaker:
    def beep(self, frequency: int = ..., duration: int = ...) -> None: ...
    def volume(self, value: int = ...) -> int: ...

class _Battery:
    def voltage(self) -> int: ...
    def current(self) -> int: ...

class PrimeHub:
    def __init__(self) -> None: ...
    buttons: _Buttons
    system: _System
    light: _Light
    display: _Display
    imu: _IMU
    speaker: _Speaker
    battery: _Battery
EOF


#-------------------------------------------------------------------------------

cat > stubs/pybricks/pupdevices.pyi <<'EOF'
from __future__ import annotations
from typing import Optional, Sequence, Tuple, Union

from pybricks.parameters import Port, Direction, Stop, Color

_Number = Union[int, float]

class Motor:
    def __init__(
        self,
        port: Port,
        positive_direction: Direction = ...,
        gears: Optional[Sequence[int]] = ...,
        reset_angle: bool = ...,
    ) -> None: ...

    # Basic control
    def run(self, speed: int) -> None: ...
    def dc(self, duty: int) -> None: ...
    def stop(self) -> None: ...
    def brake(self) -> None: ...
    def hold(self) -> None: ...

    # State
    def angle(self) -> int: ...
    def reset_angle(self, angle: int = ...) -> None: ...
    def speed(self, window: int = ...) -> int: ...

    # Motion commands
    def run_time(
        self,
        speed: int,
        time: int,
        *,
        then: Stop = ...,
        wait: bool = ...,
    ) -> None: ...

    def run_angle(
        self,
        speed: int,
        rotation_angle: int,
        *,
        then: Stop = ...,
        wait: bool = ...,
    ) -> None: ...

    def run_target(
        self,
        speed: int,
        target_angle: int,
        *,
        then: Stop = ...,
        wait: bool = ...,
    ) -> None: ...

    def run_until_stalled(
        self,
        speed: int,
        *,
        then: Stop = ...,
        duty_limit: int = ...,
    ) -> int: ...

class ColorSensor:
    def __init__(self, port: Port) -> None: ...

    # Common readings
    def reflection(self) -> int: ...
    def ambient(self) -> int: ...

    # Color outputs
    def color(self) -> Optional[Color]: ...

    # Raw-ish data (availability depends on firmware)
    def rgb(self) -> Tuple[int, int, int]: ...
    def hsv(self) -> Tuple[int, int, int]: ...

class UltrasonicSensor:
    def __init__(self, port: Port) -> None: ...

    # Distance in mm; typical "no object" value is 2000 mm on SPIKE.
    def distance(self) -> int: ...

    # Some firmwares expose presence(). If yours doesn't, just delete this.
    def presence(self) -> bool: ...
EOF

#-------------------------------------------------------------------------------

cat > stubs/pybricks/robotics.pyi <<'EOF'
from __future__ import annotations

from typing import Any, Optional, Sequence, Tuple, Union, overload

from pybricks.parameters import Stop
from pybricks.pupdevices import Motor

_Number = Union[int, float]

class DriveBase:
    def __init__(
        self,
        left_motor: Motor,
        right_motor: Motor,
        wheel_diameter: _Number,
        axle_track: _Number,
    ) -> None: ...

    # Drive by distance / angle
    def straight(self, distance: _Number, *, then: Stop = ..., wait: bool = ...) -> None: ...
    def turn(self, angle: _Number, *, then: Stop = ..., wait: bool = ...) -> None: ...

    def arc(
        self,
        radius: _Number,
        *,
        angle: Optional[_Number] = ...,
        distance: Optional[_Number] = ...,
        then: Stop = ...,
        wait: bool = ...,
    ) -> None: ...
    # Legacy (still mentioned in docs as being replaced by arc in newer versions).
    def curve(self, radius: _Number, angle: _Number, *, then: Stop = ..., wait: bool = ...) -> None: ...

    # Common settings (returns current values when called without args)
    @overload
    def settings(self) -> Tuple[int, int, int, int]: ...
    @overload
    def settings(
        self,
        straight_speed: _Number,
        straight_acceleration: Union[_Number, Tuple[_Number, _Number]],
        turn_rate: _Number,
        turn_acceleration: Union[_Number, Tuple[_Number, _Number]],
    ) -> Tuple[int, int, int, int]: ...

    # Run continuously
    def drive(self, speed: _Number, turn_rate: _Number) -> None: ...

    # Stop modes
    def stop(self) -> None: ...
    def brake(self) -> None: ...

    # State / odometry-ish
    def distance(self) -> int: ...
    def angle(self) -> float: ...
    def state(self) -> Tuple[int, int, int, int]: ...
    def reset(self, distance: _Number = ..., angle: _Number = ...) -> None: ...

    # Status
    def done(self) -> bool: ...
    def stalled(self) -> bool: ...

    # Gyro usage
    def use_gyro(self, use_gyro: bool) -> None: ...

    # Advanced PID controls (real type would be Control; keep loose)
    distance_control: Any
    heading_control: Any


class Car:
    def __init__(
        self,
        steer_motor: Motor,
        drive_motors: Union[Motor, Sequence[Motor]],
        torque_limit: _Number = ...,
    ) -> None: ...

    def steer(self, percentage: _Number) -> None: ...
    def drive_power(self, power: _Number) -> None: ...
    def drive_speed(self, speed: _Number) -> None: ...
EOF


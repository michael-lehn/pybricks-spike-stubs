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

mkdir -p stubs/robotics

#-------------------------------------------------------------------------------
cat > stubs/robotics/__init__.pyi <<'EOF'
# Marker file so Pyright treats this as a package.

from __future__ import annotations

__all__: list[str]
EOF

#-------------------------------------------------------------------------------
cat > stubs/robotics/imu.pyi <<'EOF'
from __future__ import annotations
from typing import Protocol, Tuple

class IMU(Protocol):
    """Generic IMU interface."""

    def accel(self) -> tuple[float, float, float]: ...
    """Returns (ax, ay, az) in m/s^2 or g depending on implementation."""

    def gyro(self) -> tuple[float, float, float]: ...
    """Returns (gx, gy, gz) in deg/s or rad/s depending on implementation."""

    def rotation(self) -> tuple[float, float, float]: ...
    """Returns (roll, pitch, yaw) in degrees (or radians) depending on implementation."""

    def heading(self) -> float: ...
    def reset_heading(self, value: float = ...) -> None: ...
EOF

#-------------------------------------------------------------------------------
cat > stubs/robotics/led_matrix.pyi <<'EOF'
from __future__ import annotations
from typing import Iterable, Sequence

class LEDMatrix:
    """Simple LED matrix abstraction (e.g., 5x5)."""

    def clear(self) -> None: ...
    def off(self) -> None: ...
    def on(self) -> None: ...

    def set_pixel(self, x: int, y: int, value: int = ...) -> None: ...
    """value typically 0..100 or 0..255 depending on implementation."""

    def show(self, frame: Sequence[Sequence[int]]) -> None: ...
    """frame is a 2D array-like brightness map."""

    def text(self, s: str, *, scroll: bool = ..., delay_ms: int = ...) -> None: ...
    def number(self, n: int) -> None: ...
EOF

#-------------------------------------------------------------------------------
cat > stubs/robotics/buttons.pyi <<'EOF'
from __future__ import annotations
from enum import Enum
from typing import Tuple

class Button(Enum):
    A: Button
    B: Button
    X: Button
    Y: Button
    UP: Button
    DOWN: Button
    LEFT: Button
    RIGHT: Button
    CENTER: Button

class Buttons:
    def pressed(self) -> tuple[Button, ...]: ...
EOF

#-------------------------------------------------------------------------------
cat > stubs/robotics/time.pyi <<'EOF'
from __future__ import annotations

def sleep_ms(ms: int) -> None: ...
def ticks_ms() -> int: ...
def ticks_diff(new: int, old: int) -> int: ...
EOF

#-------------------------------------------------------------------------------
cat > stubs/robotics/serial.pyi <<'EOF'
from __future__ import annotations
from typing import Optional

class Serial:
    def __init__(self, *, baudrate: int = ..., timeout_ms: int = ...) -> None: ...
    def write(self, data: bytes) -> int: ...
    def read(self, n: int = ...) -> bytes: ...
    def readline(self) -> bytes: ...
    def available(self) -> int: ...
    def close(self) -> None: ...

def open_serial(port: str, *, baudrate: int = ..., timeout_ms: int = ...) -> Serial: ...
EOF


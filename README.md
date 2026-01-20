# Pybricks SPIKE Type Stubs (for Pyright)

This repository provides **project-local type stubs (`.pyi`) for Pybricks on LEGO SPIKE Prime**, intended for use with **Pyright** (and Pyright-based language servers such as Pylance).

The stubs are **editor-only**: they enable autocomplete, type checking, and signature help on the host machine.  
They do **not** provide a runtime implementation of Pybricks.

---

## Motivation

When developing Pybricks programs on a host computer:

- The **Pybricks API exists only on the hub firmware**, not on the host.
- `pybricksdev` provides flashing and communication tools, but **no Python module**.
- Existing stub packages focus mainly on **EV3**, not **SPIKE / Powered Up**.

This repository provides **SPIKE-focused stubs** that integrate cleanly with Pyright, without polluting `site-packages` or requiring `pip install`.

---

## Scope

The stubs currently cover the most common SPIKE Prime use cases:

### Hubs
- `PrimeHub`
  - buttons
  - system (stop button, reset, shutdown)
  - light
  - display
  - IMU
  - speaker
  - battery

### Devices
- `Motor`
- `ColorSensor`
- `UltrasonicSensor`

### Parameters / Tools
- `Port`
- `Button`
- `Direction`
- `Stop`
- `Color`
- `wait(ms)`

The goal is **practical completeness**, not exhaustive coverage of the entire Pybricks API.

---

## Design Principles

- **Stubs only** – no fake runtime modules
- **Project-local** – no global installation
- **Minimal but accurate**
- **No hardcoded firmware defaults**
- **Suitable for teaching environments**

---

## Usage (Recommended)

### 1. Clone the repository into your project

From your project root:

```bash
git clone https://github.com/michael-lehn/pybricks-spike-stubs
```

Your directory now looks like:

```
your_project/
├── ...
├── pybricks-spike-stubs/
│   ├── make_stubs.sh
│   └── stubs/
│       └── pybricks/
│           ├── hubs.pyi
│           ├── pupdevices.pyi
│           ├── parameters.pyi
│           └── tools.pyi
```

### 2. Run the setup script in your project

From the project root, execute:

source pybricks-spike-stubs/make_stubs.sh

This will:

1. create a `stubs/` directory in the current project
2. copy the Pybricks SPIKE stub files into `stubs/pybricks/`
3. create a `pyrightconfig.json` file in the project root (if it does not already exist)

After running the script, your project directory will contain:

```
your_project/
├── ...
├── pyrightconfig.json
└── stubs/
    └── pybricks/
        ├── __init__.pyi
        ├── hubs.pyi
        ├── pupdevices.pyi
        ├── parameters.pyi
        └── tools.pyi
```


### Generated pyrightconfig.json

The script creates the following configuration:

```
{
  "stubPath": "stubs",
  "typeCheckingMode": "basic",
  "reportMissingModuleSource": false
}
```

The option reportMissingModuleSource = false is required because Pybricks
modules exist only on the hub firmware, not on the host system.


### Notes

- The stubs are purely for static analysis (Pyright, autocomplete, hover).
- They do not allow running Pybricks programs on the host.
- Re-running the script is safe and can be used to update the stubs.


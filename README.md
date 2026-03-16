# Stone Towers

A first-person dungeon crawler game originally written in **Turbo Pascal 7** for MS-DOS, developed by **raist**, **ernie** and **dusty** throughout the 1990s.

## Play in your browser

**[hugoshamrock.github.io/stone-towers](https://hugoshamrock.github.io/stone-towers/)**

Controls: `W/↑` forward · `S/↓` back · `A/←` turn left · `D/→` turn right · `Q/E` strafe · `M` minimap

## What is this?

Stone Towers is a classic Czech indie DOS game — a tile-based, first-person dungeon explorer in the spirit of early Wolfenstein 3D. The player navigates a 20×20 grid map while the engine renders corridor-style wall slices using VGA 256-color graphics (320×200).

The original codebase includes:
- A custom rendering engine (`ENGINE.PAS`) with EMS memory management for texture paging
- VGA 256-color graphics mode handler
- GIF image loader for textures (doom, wood, hell themes)
- CMF/Sound Blaster FM music system
- INI-based level configuration
- Multiple iterated source revisions (`149.PAS` through `250.PAS`) documenting the evolution of the engine

The project was never publicly released and remains unfinished.

## Repository structure

```
index.html        — web port, playable in any modern browser
original-dos/
  stonet1/        — main game source code and assets (Turbo Pascal, ~18 MB)
    ENGINE.PAS        core rendering engine
    *.PAS             game logic iterations and utility modules
    Ini/              level configuration files
    TEXTURES/         wall texture data
    CMF/              music files (Creative Music Format)
    WIZ/              game asset directories
    STONET/           compiled game and installer
  stonet2/        — second version / graphics library (lostGFX, 640×480×256 mode)
```

## Intent

This repository preserves the original source code as-is. The web port is being developed with the assistance of **Claude AI**, using the original Pascal source as a reference for game logic and level design. The goal is to complete the gameplay that was never finished — enemies, items, combat, multiple levels — playable directly in the browser without any emulator.

## Running the original DOS version

Requires MS-DOS or a DOS emulator such as [DOSBox](https://www.dosbox.com/).

```
dosbox original-dos/stonet1/STONET/STONET.EXE
```

## License

Original source code © raist, ernie, dusty. Published with the authors' permission for archival and educational purposes.

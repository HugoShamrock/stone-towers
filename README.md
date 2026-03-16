# Stone Towers

A first-person dungeon crawler game originally written in **Turbo Pascal 7** for MS-DOS, developed by **raist**, **ernie** and **dusty** throughout the 1990s.

## What is this?

Stone Towers is a classic Czech indie DOS game — a tile-based, first-person dungeon explorer in the spirit of early Wolfenstein 3D. The player navigates a 20×20 grid map, moving in four cardinal directions, while the engine renders corridor-style wall slices using VGA 256-color graphics (320×200).

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
stonet1/   — main game source code and assets (Turbo Pascal, ~18 MB)
  ENGINE.PAS     — core rendering engine
  *.PAS          — game logic iterations and utility modules
  Ini/           — level configuration files
  TEXTURES/      — wall texture data
  CMF/           — music files (Creative Music Format)
  WIZ/           — game asset directories
  STONET/        — compiled game and installer

stonet2/   — second version / graphics library (lostGFX, 640×480×256 mode)
```

## Intent

This repository preserves the original source code as-is. A separate modern reimplementation is planned in a new directory, with the goal of:

1. Making the game **playable in a web browser** (no DOS emulator required)
2. Completing the gameplay that was never finished — enemies, items, combat, multiple levels
3. Using the original assets (textures, music) where possible

The rewrite will be developed with the assistance of **Claude AI**, using the original Pascal source as a reference for game logic and level design.

## Running the original

The original game requires MS-DOS or a DOS emulator such as [DOSBox](https://www.dosbox.com/).

```
dosbox stonet1/STONET/STONET.EXE
```

## License

Original source code © raist, ernie, dusty. Published with the authors' permission for archival and educational purposes.

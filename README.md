# Stone Towers

A Czech indie DOS game originally written in **Turbo Pascal 7** for MS-DOS, developed by **raist**, **ernie** and **dusty** throughout the 1990s.

## Play in your browser

**[hugoshamrock.github.io/stone-towers](https://hugoshamrock.github.io/stone-towers/)**

The landing page offers three playable versions:

| Game | Type | Description |
|------|------|-------------|
| **Dungeon Walker** | First-person 3D | Explore a 20×20 stone maze. DDA raycasting engine based on `ENGINE.PAS`. |
| **The Adventure** | Point-and-click RPG | Navigate a dungeon, collect items, cast spells, solve puzzles. Procedural graphics. |
| **The Adventure — Original Graphics** | Point-and-click RPG | Same game, rendered with the authentic 1995 VGA artwork (129 GIF files from the original archive). |

## What is this?

The original Stone Towers codebase contains two distinct games:

**Dungeon Walker** (`ENGINE.PAS`, iterations `149.PAS`–`250.PAS`) — a tile-based first-person dungeon explorer in the spirit of early Wolfenstein 3D. The player navigates a 20×20 grid while the engine renders corridor-style wall slices using VGA 256-color graphics (320×200).

**The Adventure** (`STONET/STONET.PAS`) — a point-and-click RPG with mouse support, inventory, spells, NPCs, and puzzle chains. Pre-rendered 320×200 GIF scenes are layered with animated sprite overlays.

The original codebase includes:
- A custom raycasting engine (`ENGINE.PAS`) with EMS memory management for texture paging
- VGA 256-color graphics mode handler
- GIF image loader and layered scene compositor
- CMF/Sound Blaster FM music system
- INI-based level configuration
- 129 original GIF87a artwork files

The project was never publicly released and remains unfinished.

## Repository structure

```
index.html        — game hub / landing page
walker.html       — Dungeon Walker (first-person 3D)
adventure.html    — The Adventure (procedural graphics)
original.html     — The Adventure (original 1995 GIF artwork)
original-dos/
  stonet1/        — main game source code and assets (Turbo Pascal, ~18 MB)
    ENGINE.PAS        core rendering engine
    *.PAS             game logic iterations and utility modules
    Ini/              level configuration files
    TEXTURES/         wall texture data
    CMF/              music files (Creative Music Format)
    WIZ/              game asset directories
    STONET/           compiled game, installer, and 129 GIF artwork files
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

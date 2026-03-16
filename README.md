# Stone Towers

A Czech indie DOS game originally written in **Turbo Pascal 7** for MS-DOS, developed by **raist**, **ernie** and **dusty** throughout the 1990s.

## Play in your browser

**[hugoshamrock.github.io/stone-towers](https://hugoshamrock.github.io/stone-towers/)**

### Games

| Page | Type | Description |
|------|------|-------------|
| [**Original DOS**](https://hugoshamrock.github.io/stone-towers/dos.html) | Original executable | `STONET.EXE` (1995) running in DOSBox via WebAssembly (js-dos). Full FLI intro/outro, FM music, all 129 VGA scenes. |
| [**Dungeon Walker**](https://hugoshamrock.github.io/stone-towers/walker.html) | First-person 3D | Explore a 20×20 stone maze. DDA raycasting engine based on `ENGINE.PAS`. |
| [**The Adventure**](https://hugoshamrock.github.io/stone-towers/adventure.html) | Point-and-click RPG | Navigate a dungeon, collect items, cast spells, solve puzzles. Procedural graphics. |
| [**The Adventure — Original Graphics**](https://hugoshamrock.github.io/stone-towers/original.html) | Point-and-click RPG | Same game, rendered with the authentic 1995 VGA artwork (129 GIF files from the original archive). |

### Archive

| Page | Description |
|------|-------------|
| [**The Story**](https://hugoshamrock.github.io/stone-towers/story.html) | Original game manuscript — `STONETOW.ERS`, a Czech poem by WIZ, © 1995. |
| [**Gallery**](https://hugoshamrock.github.io/stone-towers/gallery.html) | Original VGA artwork: title screen, sprite sheets (BMP), Stone Towers II character portraits and game screens (GIF). |
| [**Animations**](https://hugoshamrock.github.io/stone-towers/animations.html) | Seven FLI animations from 1992–1997, played in the browser via a JavaScript FLI decoder. |
| [**History**](https://hugoshamrock.github.io/stone-towers/history.html) | Development timeline 1992–1999, plus Stone Towers II — a complete unreleased reimagining on a new engine. |

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
- FLI animations (1992–1997)
- Stone Towers II assets: GIF artwork, 7 EXE builds, AVI clip

The project was never publicly released and remains unfinished.

## Repository structure

```
index.html        — hub / landing page
walker.html       — Dungeon Walker (first-person 3D)
adventure.html    — The Adventure (procedural graphics)
original.html     — The Adventure (original 1995 GIF artwork)
story.html        — The Story (STONETOW.ERS, © 1995 WIZ)
gallery.html      — Original artwork gallery (BMP + stonet2 GIFs)
animations.html   — FLI animation player (1992–1997)
history.html      — Development timeline + Stone Towers II
style.css         — shared styles
TODO.md           — project roadmap and archive findings
original-dos/
  stonet1/        — main game source code and assets (Turbo Pascal, ~18 MB)
    ENGINE.PAS        core rendering engine
    *.PAS             game logic iterations and utility modules
    PAS/              162 source iterations (versions 73–264)
    Ini/              level configuration files
    TEXTURES/         wall texture data
    CMF/              music files (Creative Music Format)
    WIZ/              game asset directories (FLI animations)
    BMP/              sprite sheets (monsters, characters, items)
    STONET/           compiled game, installer, 129 GIF artwork files, FLI animations
  stonet2/        — second version (1998–1999), new engine, 640×480×256 mode
    *.GIF             character portraits and game screens
    *.EXE             7 executable builds (230X–453X)
    ANIMACKA.AVI      recorded animation clip
```

## Intent

This repository preserves the original source code as-is. The web port is being developed with the assistance of **Claude AI**, using the original Pascal source as a reference for game logic and level design. The goal is to complete the gameplay that was never finished — enemies, items, combat, multiple levels — playable directly in the browser without any emulator.

See [**TODO.md**](TODO.md) for the full roadmap.

## Running the original DOS version

Requires MS-DOS or a DOS emulator such as [DOSBox](https://www.dosbox.com/).

```
dosbox original-dos/stonet1/STONET/STONET.EXE
```

## License

Original source code © raist, ernie, dusty. Published with the authors' permission for archival and educational purposes.

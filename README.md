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
| [**Hybrid 6**](https://hugoshamrock.github.io/stone-towers/hybrid6.html) ★ | First-person 3D RPG | Hybrid 5 + Level 1 rendered with authentic 1995 VGA forest scene (bare trees, night sky) from the original game archive. |
| [**Hybrid 5**](https://hugoshamrock.github.io/stone-towers/hybrid5.html) | First-person 3D RPG | Hybrid 4 + two-level dungeon: Level 1 (11×11) and Level 2 (20×20, 5× larger) with new enemies (spiders, troll, dark knight), items, and crystal quest. |
| [**Hybrid 4**](https://hugoshamrock.github.io/stone-towers/hybrid4.html) | First-person 3D RPG | 3D raycasting + 1995 GIF artwork + full RPG. Fixed fire sprite, dead creatures on floor, bat pickup disappears, skeleton lying down, iron gate at final room. |
| [**Hybrid 3**](https://hugoshamrock.github.io/stone-towers/hybrid3.html) | First-person 3D RPG | Hybrid 2 + fixed fire sprite, dead bat/goblin on floor, diamond pickup, iron gate. |
| [**Hybrid 2**](https://hugoshamrock.github.io/stone-towers/hybrid2.html) | First-person 3D RPG | Hybrid 1 + item icons from original GIFs in inventory, context-sensitive hints at crosshair. |
| [**Hybrid 1**](https://hugoshamrock.github.io/stone-towers/hybrid1.html) | First-person 3D RPG | 3D raycasting engine from Dungeon Walker combined with the original 1995 GIF artwork and full RPG mechanics from The Adventure. |
| [**Stone Towers II**](https://hugoshamrock.github.io/stone-towers/stonet2.html) | Third-person RPG | Complete reimagining on a new 640×480 engine (1998–1999, never released). Original CEL character artwork (320×200 sprites composited to 640×400), web port from Pascal source (`453x.pas`, `LOST9.PAS`). |

### Archive

| Page | Description |
|------|-------------|
| [**The Story**](https://hugoshamrock.github.io/stone-towers/story.html) | Original game manuscript — `STONETOW.ERS`, a Czech poem by WIZ, © 1995. |
| [**Gallery**](https://hugoshamrock.github.io/stone-towers/gallery.html) | Original VGA artwork: title screen, sprite sheets (BMP), Stone Towers II character portraits and game screens (GIF). Lightbox viewer. |
| [**129 VGA Scenes**](https://hugoshamrock.github.io/stone-towers/scenes.html) | All 129 original GIF87a dungeon scenes from 1995, grouped by area, with lazy loading and lightbox navigation. |
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
hybrid1.html      — Hybrid 1: 3D engine + original artwork + full RPG
hybrid2.html      — Hybrid 2: + item icons + crosshair hints
hybrid3.html      — Hybrid 3: + fire fix + dead sprites + iron gate
hybrid4.html      — Hybrid 4: + bat pickup clears sprite + skeleton lying down
hybrid5.html      — Hybrid 5: + two-level dungeon (11×11 → 20×20)
hybrid6.html      — Hybrid 6: + 1995 forest scene as Level 1 walls  ★ recommended
stonet2.html      — Stone Towers II: third-person RPG, 640×480, CEL sprites
scenes.html       — 129 original VGA scenes (1995), grouped by area, lightbox
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

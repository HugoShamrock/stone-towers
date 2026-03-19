# Stone Towers — TODO & Archive Findings

Přehled všeho nalezeného v původních zdrojácích a stav zpracování.

---

## ✅ Hotovo

### Webové porty her
- [x] **Dungeon Walker** (`walker.html`) — raycasting engine z `ENGINE.PAS`, 20×20 mapa, DDA renderer, procedurální textury, kompas HUD
- [x] **The Adventure** (`adventure.html`) — port `STONET.PAS`, inventory, HP/MP, NPCs, procedurální grafika
- [x] **The Adventure — Original Graphics** (`original.html`) — stejná hra, 129 originálních GIF87a souborů z roku 1995

### Rozcestník (`index.html`)
- [x] Karty tří her s popisem a ovládáním
- [x] **The Story** — `STONETOW.ERS` dekódováno z CP852, česky formátovaný příběh, `(c) 1995 WIZ`
- [x] **Original Artwork** — `STARTMSC.BMP` jako hero image + mřížka sprite sheetů (MONST1, MONST2, PCS, ITEM, MIXED)
- [x] **FLI Animations** — JavaScript FLI decoder (typy 0x0B palette, 0x0C LC delta, 0x0F BRUN), load-on-demand přehrávač pro 7 animací:
  - GAME6.FLI (prosinec 1992 — nejstarší prototyp)
  - ANIMACE2.FLI (prosinec 1992)
  - GM_OUT.FLI (prosinec 1992 — outro sekvence)
  - GM_FLI2.FLI (1995)
  - CRYSTAL.FLI (leden 1997 — animace krystalu)
  - STONWAT.FLI (leden 1997 — voda)
  - DEMO.FLI (březen 1997 — game demo, poslední stonet1 artefakt)
- [x] **Stone Towers II sekce** — popis + CHB1–4 portréty postav + 11 herních screenshotů ze stonet2
- [x] **Development Timeline** — 1992 → 1995 → 1996 → 1997 → 1998–99 → 2025

### Infrastruktura
- [x] `← back to menu` odkaz ve všech třech hrách
- [x] `README.md` — popis projektu, struktura repozitáře, odkaz na webovou hru, záměr

---

## 🎮 Herní obsah — dokončení hry

Hlavní záměr projektu: **dokončit hratelnost**, která v originálním kódu chybí.

- [ ] **Nepřátelé a soubojový systém** — v `STONET.PAS` jsou definovány typy nepřátel, statistiky, ale souboj nebyl implementován
- [ ] **Více úrovní (dungeonů)** — `Ini/level1.ini` je jediný existující soubor úrovně; nakonfigurovat další levely nebo je procedurálně generovat
- [ ] **Funkční předměty** — zbraně, lektvary, klíče jsou v kódu deklarovány, ale jejich efekty chybí
- [ ] **Funkční kouzla** — systém MP a 5 kouzel (`1–5`) existuje v UI, logika efektů chybí
- [ ] **NPC dialogy a obchod** — NPC jsou přítomni v mapě, ale dialogy/interakce jsou prázdné
- [ ] **Záchranné krystaly** — ústřední quest příběhu (`STONETOW.ERS`); vytvořit mechaniku hledání tří krystalů
- [ ] **Win/lose podmínky** — konec hry není implementován; `GM_OUT.FLI` naznačuje plánovanou outro sekvenci
- [ ] **Dungeon Walker: nepřátelé** — engine chodce zvládá pohyb, ale nepřátelé chybí úplně

---

## 🎵 Hudba (CMF soubory)

V `original-dos/stonet1/CMF/` jsou dva soubory:
- `ACTION.CMF` — akční/bojová hudba
- `AXEL-F.CMF` — Axel F (Beverly Hills Cop theme) — pravděpodobně testovací

CMF = Creative Music Format (Sound Blaster OPL2/OPL3 FM syntéza).
Moderní prohlížeče to nativně neumí přehrát.

- [ ] **Přehrávač CMF v prohlížeči** — implementovat JavaScript CMF/OPL emulátor (např. port knihovny `libADLMIDI` nebo `DOSBox OPL`) a přidat přehrávač na `index.html`
- [ ] **Herní hudba** — zapojit CMF přehrávač do her (ACTION.CMF během souboje, atd.)

---

## 🗺️ Konfigurace úrovní (INI)

`original-dos/stonet1/Ini/level1.ini` — jediný existující level:
- Autor: "Ernie", datum "01/04/1978" (vtip)
- 7 textur: doom01–02, wood01–03, hell01–02
- Startovní pozice: (5, 18), čelem na jih

- [ ] **Editor úrovní** — vizuální editor map pro tvorbu nových dungeonů ve formátu INI
- [ ] **Další levely** — navrhnout a implementovat level 2, 3… odpovídající příběhu (najít 3 krystaly)
- [ ] **Různé textury** — využít všechny textury z `TEXTURES/` (doom, wood, hell sety)

---

## 🎬 Animace — zbývající

- [ ] **ANIMACKA.AVI** (`original-dos/stonet2/ANIMACKA.AVI`, 1.6 MB, 320×240, 25fps) — RIFF AVI soubor ze stonet2; starý kodek, prohlížeče ho pravděpodobně nepřehrají. Možnosti: ffmpeg konverze na WebM offline, nebo zobrazit jen jako archivní položku bez přehrávače

---

## 🏰 Stone Towers II — webový port

`original-dos/stonet2/` — kompletně odlišný engine (1998–1999):
- 7 EXE buildů (230X → 453X)
- Nový engine pro 640×480×256 VGA
- CEL-formát sprity (64 KB každý)
- GIF artwork: portréty postav, herní obrazovky, 3D prototypy

- [x] **Prozkoumat stonet2 Pascal zdroje** — pochopit herní logiku v porovnání s stonet1
- [x] **Webový port stonet2** — `stonet2.html`: CEL loader + CH.COL paleta, 4×320×200 tile compositor, CHB/CHF/CHL/CHR animace, PAN UI, mini-mapa, pohyb po gridu
- [x] **Přidat kartu stonet2 na rozcestník** — karta #7

---

## 📜 Zdrojový kód — historická analýza

`original-dos/stonet1/PAS/` — 162 Pascal souborů (verze 73–264):
- Dokumentují každý krok vývoje enginu
- Obsahují experimenty, slepé větve, refaktoring

- [ ] **Diff analýza verzí** — porovnat klíčové iterace (73→150→200→264) a zdokumentovat co se kdy změnilo
- [ ] **Stránka vývojového deníku** — vizualizace evoluce kódu jako interaktivní timeline s výňatky z Pascalu

---

## 🖼️ Galerie — rozšíření

- [ ] **Lightbox pro galerii** — kliknutím na BMP/GIF zobrazit ve fullscreen překryvu
- [ ] **129 GIF souborů z roku 1995** — teď jsou použity jen ve hře; zvážit galerii všech scén (`original-dos/stonet1/STONET/*.GIF`) jako archiv herního artworu
- [ ] **stonet2 MAPA1.GIF / MAPA2.GIF** — malé soubory (1.2 KB), pravděpodobně minimapy; zobrazit s vysvětlením

---

## 🔧 Technické vylepšení webových portů

- [ ] **Save/load stavu hry** — `localStorage` pro ukládání postupu v The Adventure
- [ ] **Mobilní ovládání** — dotykové šipky pro hráče na telefonu
- [ ] **Fullscreen mód** — tlačítko pro fullscreen canvas
- [ ] **Dungeon Walker: mapa** — klávesa `M` existuje, ale mapa zobrazuje jen rastr; vylepšit o viděné/neviděné místnosti
- [ ] **FLI přehrávač: smyčka / autostart** — volitelné automatické přehrávání při scrollu do view

---

## 📝 Dokumentace

- [ ] **Technický popis enginu** — jak funguje DDA raycasting z `ENGINE.PAS` (pro zájemce)
- [ ] **Popis formátu FLI** — jak decoder funguje (pro archivní/vzdělávací účely)
- [ ] **Stránka „O projektu"** — rozšíření záměru z README na web

---

*Naposledy aktualizováno: 2026-03-16*

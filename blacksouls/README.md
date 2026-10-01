# BLACK SOULS — PortMaster

RPG Maker VX Ace (RGSS3) game running on **mkxp-z**, the open-source RGSS
player. The port ships only the engine; the game files come from the user's own
copy of the game.

## Layout

mkxp-z reads `mkxp.json` from the directory holding the engine binary, and
treats that same directory as the game root. Engine and game files therefore
live side by side — a separate `gamedata/` subfolder does **not** work here
(a relative `gameFolder` is rejected, and `SRCDIR` moves the game root with it).

```
ports/
├── BLACK SOULS.sh
└── blacksouls/
    ├── mkxp-z.aarch64      engine
    ├── libs.aarch64/       libruby 3.1, libffi, libcrypt
    ├── stdlib.tar.gz       Ruby stdlib, unpacked to stdlib/ on first launch
    ├── mkxp.json           engine configuration
    ├── licenses/
    │
    ├── Game.ini            ← from here down: the game's own files
    ├── Game.rgss3a         encrypted archive (Data + Graphics)
    ├── Audio/
    ├── Graphics/
    └── Fonts/
```

`Game.exe`, `System/RGSS301.dll`, `installscript.vdf` and `Bonus/` are either
Windows-only or unused by the engine, and are not copied.

Note: both `Game.rgss3a` and the loose `Graphics/` folder must be present. Nine
assets (`IconSet.png`, `Window.png`, `BattleStart.png` and several tilesets)
exist in *both*, and the loose copies are the English release's replacements.
mkxp-z gives loose files priority over the archive, reproducing the Windows
behaviour — do not delete either copy.

## Display

The game calls `Graphics.resize_screen(640, 480)`, which matches the RG40XX H
panel exactly, so the image is 1:1 with no scaling and no letterboxing.
`smoothScaling` is off to keep it sharp on devices that do scale.

## Controls

mkxp-z reads the gamepad natively through SDL. gptokeyb is started only to
provide the PortMaster exit hotkey.

## Saves

Saves are written next to the game files as `Save01.rvdata2` … Keep them when
updating the port.

## Known issues

- `Bitmap drawText with outline and translucent text is broken` — a known
  cosmetic mkxp-z limitation, not a port fault.
- `key :apx is duplicated` — a mistake in the game's own script. Harmless.
- gptokeyb2 writes its button tracing into `log.txt`, which makes the log noisy
  but costs nothing.

## Status

Tested on an Anbernic RG40XX H (KNULLI, Allwinner H700, Mali-G31, 1 GB RAM):
the game runs, including battles, and saves correctly. Device log reports
`RGSS version 3`, `GL Renderer: Mali-G31`, OpenGL ES 3.2.

Earlier desktop testing with the x86_64 build of the same mkxp-z version
against this exact layout: all 164 game scripts load, steady 60 FPS, ~233 MB
resident set.

Resolved along the way:

- `bitmapSmoothScaling` is not a valid key in this mkxp-z build and aborts
  startup — removed.
- A relative `gameFolder` is rejected (`Failed to check current path`).
- `SRCDIR` moves the game root with it, so the engine stops finding `Game.ini`
  and the fonts. Hence the flat layout.
- `UmePlus Gothic`, requested by the name-window script, was never shipped with
  the game; `fontSub` now maps it to the bundled VL Gothic.

## Credits

- Game: OTAKU_Plan
- Engine: [mkxp-z](https://github.com/mkxp-z/mkxp-z)
- aarch64 engine build taken from the PortMaster *Last Scenario* port by Cebion.

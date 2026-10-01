# BLACK SOULS — PortMaster port

[BLACK SOULS](https://store.steampowered.com/app/1424910/BLACK_SOULS/) running
on ARM handhelds through [PortMaster](https://portmaster.games/), using
[mkxp-z](https://github.com/mkxp-z/mkxp-z) as the RPG Maker VX Ace (RGSS3)
engine.

**This repository contains the engine and launcher only.** The game is a paid
title — you supply your own copy.

## Install

1. Copy `BLACK SOULS.sh` and the `blacksouls/` folder into your device's
   `ports/` directory.
2. From your own installation of the game, copy these into `blacksouls/`,
   alongside the engine:

   ```
   Audio/   Graphics/   Fonts/   Game.ini   Game.rgss3a
   ```

   `Game.exe`, `System/` and `installscript.vdf` are Windows-only — skip them.
3. Launch "BLACK SOULS" from the Ports menu.

Keep **both** `Game.rgss3a` and the loose `Graphics/` folder. Nine assets exist
in both, and the loose copies are the English release's replacements; mkxp-z
gives loose files priority over the archive, matching Windows behaviour.

## Layout

mkxp-z reads `mkxp.json` from the engine binary's directory and uses that same
directory as the game root, so engine and game files sit together. A separate
`gamedata/` subfolder does not work — see `blacksouls/README.md` for the
details and for the other traps hit while building this.

## Tested on

Anbernic RG40XX H (KNULLI, Allwinner H700, Mali-G31, 1 GB RAM) — runs
including battles, saves correctly. The game renders at 640x480, identical to
the panel, so the image is 1:1 with no scaling.

Desktop testing against the same layout with the x86_64 build of the same
mkxp-z version: all 164 game scripts load, steady 60 FPS, ~233 MB resident set.

## Building a release

```sh
./build-release.sh
```

Produces `dist/blacksouls.zip`, and refuses to build if game files are present.

## Credits

- Game: OTAKU_Plan
- Engine: [mkxp-z](https://github.com/mkxp-z/mkxp-z)
- The aarch64 mkxp-z build is taken from the PortMaster *Last Scenario* port by
  Cebion.

## Licence

The launcher, configuration and documentation here are MIT. mkxp-z and its
bundled libraries keep their own licences — see `blacksouls/licenses/`. The
game itself is not covered and is not distributed here.

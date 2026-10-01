## Notes

Thanks to [OTAKU_Plan](https://store.steampowered.com/app/1424910/BLACK_SOULS/) for creating BLACK SOULS, a bleak retelling of Alice in Wonderland and the Brothers Grimm whose fairy tale characters hold real, tracked relationships with you that quietly reshape how the story ends.

The game is a paid title, so this port ships the engine only. Copy `Audio/`, `Graphics/`, `Fonts/`, `Game.ini` and `Game.rgss3a` from your own installation into the `blacksouls` folder, alongside the engine. `Game.exe`, `System/` and `installscript.vdf` are Windows only and are not needed.

Keep both `Game.rgss3a` and the loose `Graphics/` folder. Nine assets exist in both, and the loose copies are the English release's replacements; mkxp-z gives loose files priority over the archive, which is what the Windows build does too.

The game renders at 640x480, so it is pixel for pixel on a 640x480 panel with no scaling.

## Controls

| Button | Action |
|--|--|
| D-Pad | Move, menu navigation |
| A | Confirm |
| B | Cancel, open menu |
| X | Dash |
| Start | Open menu |

## Compile

The shipped `mkxp-z.aarch64` is the aarch64 build from the PortMaster Last Scenario port. To build the engine from source instead:

1. Build the bundled dependencies and Ruby.

```
git clone --recursive https://github.com/mkxp-z/mkxp-z.git
cd mkxp-z/linux
make -j$(nproc)
source vars.sh
```

2. Link against the system SDL2 rather than mkxp-z's own static fork. In `src/meson.build` force `dependency('SDL2', static: false)`, and in `linux/Makefile` drop `sdl2` from the `sdl2image`, `sdlsound`, `sdl2ttf` and `deps-core` prerequisite lists. Verify with `readelf -d build/mkxp-z.aarch64 | grep NEEDED`, which should list `libSDL2-2.0.so.0`.

3. Build the engine itself with the GLES backend.

```
cd ..
meson setup build -Dgfx_backend=gles -Denable-https=false --bindir=. --prefix=$PWD/build/local
cd build
ninja
ninja install
```

The Ruby standard library shipped as `stdlib.tar.gz` comes from `linux/build-<arch>/lib/ruby/3.1.0`.

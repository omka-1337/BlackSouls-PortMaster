## Notes

Thanks to [Eeny, meeny, miny, moe?](https://store.steampowered.com/app/3755860/BLACK_SOULS/) for creating BLACK SOULS, a bleak retelling of Alice in Wonderland and the Brothers Grimm whose fairy tale characters hold real, tracked relationships with you that quietly reshape how the story ends.

The game is a paid title, so this port ships the engine only. Copy `Audio/`, `Graphics/`, `Fonts/`, `Game.ini` and `Game.rgss3a` from your own installation into the `blacksouls` folder, alongside the engine. `Game.exe`, `System/` and `installscript.vdf` are Windows only and are not needed.

Copy the loose `Graphics/` folder as well. Nine assets exist both there and inside `Game.rgss3a`, and under mkxp-z the archive wins, so those loose copies are inert; they are kept only so the folder matches an untouched installation. To override anything in the archive, use `patches/` instead, as described below.

The game renders at 640x480, so it is pixel for pixel on a 640x480 panel with no scaling.

## Translations

Anything placed in `blacksouls/patches/` is mounted above `Game.rgss3a`, so a translation can replace the game's data without the archive being touched or removed. The folder is empty by default, which leaves the game in English.

To install the Russian translation, extract the contents of `BSRUv1.12.zip` into `blacksouls/patches/` so that `patches/Data/`, `patches/Graphics/` and the rest sit directly inside it. Remove them again to go back to English.

That translation ships a Steamworks achievements script which calls `Win32API` at load time and would otherwise kill the game at startup; `win32stub.rb` neutralises it.

Verified as far as the title screen and the opening scene, on the x86_64 build of the same mkxp-z version. Battles and later maps were not played through in Russian.

## Controls

| Button | Action |
|--|--|
| D-Pad | Move, menu navigation |
| B | Confirm |
| A | Cancel, open menu |
| X | Dash |
| Start | Open menu |

Face button positions vary between handhelds, so Confirm and Cancel may sit the other way round on your device. The port does not remap anything: mkxp-z reads the pad through `SDL_GameController`, and the mapping comes from the firmware's own controller database.

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

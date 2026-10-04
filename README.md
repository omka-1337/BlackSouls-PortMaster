## Notes

Thanks to [Eeny, meeny, miny, moe?](https://store.steampowered.com/app/3755860/BLACK_SOULS/) for creating BLACK SOULS, a bleak retelling of Alice in Wonderland and the Brothers Grimm whose fairy tale characters hold real, tracked relationships with you that quietly reshape how the story ends.

The game is a paid title, so this port ships the engine only. Copy `Audio/`, `Graphics/`, `Fonts/`, `Game.ini` and `Game.rgss3a` from your own installation into the `blacksouls` folder, alongside the engine. `Game.exe`, `System/` and `installscript.vdf` are Windows only and are not needed.

The Steam release ships a heavily reduced build of the game: its `Game.rgss3a` declares 21 maps where the original release has 150. The publisher offers a free official patch that restores the full game, and it has to be applied to the Steam copy before the files are worth copying here, otherwise the port faithfully runs the reduced build. A copy bought on DLsite is complete as it is. This port was built and tested against the English Steam files.

Note where the patched content ends up. If applying the patch updates `Game.rgss3a` itself, copy that archive across as usual. If it instead leaves loose `Data/`, `Graphics/` or `Audio/` folders beside the archive, those go into `patches/` rather than next to the engine: where the same file exists in both, the archive wins, so copying them alongside the engine would silently leave the reduced build running.

Copy the loose `Graphics/` folder as well. Nine assets exist both there and inside `Game.rgss3a`, and under mkxp-z the archive wins, so those loose copies are inert; they are kept only so the folder matches an untouched installation. To override anything in the archive, use `patches/` instead, as described below.

The game renders at 640x480, so it is pixel for pixel on a 640x480 panel with no scaling.

## The patches folder

`blacksouls/patches/` is mounted above `Game.rgss3a`. A loose folder next to the engine is not: where the same file exists in both, the archive wins. So anything meant to replace the game's own content goes in `patches/`, and the folder is empty by default, which leaves the game exactly as shipped.

Two things usually go in it: the publisher's free patch for the reduced Steam build, and a translation. Both arrive as a set of RPG Maker folders. Put their content folders directly inside `patches/`:

```
patches/
├── Data/
├── Graphics/
├── Audio/     (only if it ships one)
└── Fonts/     (only if it ships one)
```

Some archives wrap everything in a single top level folder, in which case copy that folder's contents rather than the folder itself. Leave out anything Windows specific: `Game.exe`, `System/`, `*.dll`, `*.vdf`, `Game.rvproj2` and its own `Game.ini` are all unused here. Delete the folders again to go back.

A save can stop loading when you change this folder. Saves sit next to the engine and are never touched by what you put here, but a save stores objects of the classes the game's scripts define, so content that adds such a class makes its saves unreadable once it is removed, and the other way round. Whether it bites depends on what you installed, and neither of the translations used here did: the same save loaded with and without them. The game stays quiet when it does bite: `DataManager.load_game` swallows the error, so the load screen buzzes and sits there as though the button did nothing. Put the folder back the way it was when the save was made and it loads. This is how the game behaves on Windows too.

Content dropped here commonly bundles RGSS scripts that call `Win32API` while loading, such as Steamworks achievements or the Fullscreen++ plugin. There is no Windows DLL to load on this platform, so those calls would kill the game before the title screen; `win32stub.rb` makes them inert. Fullscreen is handled by `mkxp.json` anyway, so losing that plugin changes nothing.

Played on an RG40XX H with two different Russian translations and with `patches/` left empty, all three fine.

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

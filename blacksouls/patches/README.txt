This folder is mounted above Game.rgss3a, so anything placed here replaces the
game's own files without the archive being removed or touched.

Leave it empty and the game runs as shipped, in English.


INSTALLING A TRANSLATION

Put the translation's content folders directly inside this folder:

    patches/
    |-- Data/
    |-- Graphics/
    |-- Audio/     (only if the translation ships one)
    `-- Fonts/     (only if the translation ships one)

Some archives wrap everything in a single top level folder. Copy that folder's
contents, not the folder itself.

Do not copy anything Windows specific. Game.exe, System/, *.dll, *.vdf,
Game.rvproj2 and the translation's own Game.ini are all unused here.

Delete these folders again to go back to English. Save files live one level up,
next to the engine, so they are not affected either way.


WHY WIN32API IS STUBBED

Translations often bundle RGSS scripts that call Win32API while loading, such as
Steamworks achievements or the Fullscreen++ plugin. There is no Windows DLL to
load on this platform, so those calls would kill the game before the title
screen. win32stub.rb, one level up, makes them inert. Fullscreen is handled by
mkxp.json anyway.

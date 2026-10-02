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

Delete these folders again to go back to English.


A SAVE CAN STOP LOADING WHEN YOU CHANGE THIS FOLDER

Save files live one level up, next to the engine, and adding or removing a
translation never touches them. A save does store objects of the classes the
game's scripts define, though, so a translation that adds such a class makes its
saves unreadable once it is removed, and the other way round.

Whether it bites depends on the translation. Both Russian ones tested here add
nothing that reaches a save, so the same save loaded fine with and without them.

When it does bite the game says nothing. It plays a buzzer on the load screen
and stays where it is, which looks like the button did nothing. Put the
translation back the way it was when the save was made and it will load.

So before changing this folder, either finish what you are playing or keep a
copy of the saves.


WHY WIN32API IS STUBBED

Translations often bundle RGSS scripts that call Win32API while loading, such as
Steamworks achievements or the Fullscreen++ plugin. There is no Windows DLL to
load on this platform, so those calls would kill the game before the title
screen. win32stub.rb, one level up, makes them inert. Fullscreen is handled by
mkxp.json anyway.

#!/bin/bash
# PORTMASTER: blacksouls.zip, BLACK SOULS.sh

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

GAMEDIR="/$directory/ports/blacksouls"
# Fallback for setups where $directory does not resolve to this card.
[ -d "$GAMEDIR" ] || GAMEDIR="$(dirname "$(realpath "$0")")/blacksouls"

BINARY="mkxp-z.aarch64"

> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1

echo "GAMEDIR: $GAMEDIR"
echo "ARCH:    ${DEVICE_ARCH:-unset}"

if [ ! -f "$GAMEDIR/Game.rgss3a" ]; then
  echo "ERROR: game data missing. Expected $GAMEDIR/Game.rgss3a"
  echo "See README.md for how to supply the game files."
  sleep 5
  exit 1
fi

# Ruby standard library ships packed to keep the file count down.
if [ ! -d "$GAMEDIR/stdlib" ]; then
  echo "First run: unpacking Ruby stdlib..."
  tar -xzf "$GAMEDIR/stdlib.tar.gz" -C "$GAMEDIR" || { echo "ERROR: stdlib unpack failed"; sleep 5; exit 1; }
fi

chmod +x "$GAMEDIR/$BINARY" 2>/dev/null

export LD_LIBRARY_PATH="$GAMEDIR/libs.${DEVICE_ARCH:-aarch64}:$LD_LIBRARY_PATH"
export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"

cd "$GAMEDIR" || exit 1

# mkxp-z reads the gamepad natively; gptokeyb only provides the exit hotkey.
if [ -n "$GPTOKEYB2" ]; then
  $GPTOKEYB2 "$BINARY" &
elif [ -n "$GPTOKEYB" ]; then
  $GPTOKEYB "$BINARY" &
fi

command -v pm_platform_helper >/dev/null 2>&1 && pm_platform_helper "$GAMEDIR/$BINARY"

./"$BINARY"

pm_finish

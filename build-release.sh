#!/bin/bash
# Builds the distributable PortMaster archive.
# Ships the engine only, never the game's own files.
#
# The repository is laid out the way a PortMaster submission directory is:
# metadata at the top level, engine in blacksouls/. A released port's zip puts
# that metadata inside the port folder instead, so this stages the files into
# that shape before zipping.
set -euo pipefail

cd "$(dirname "$(realpath "$0")")"

for f in blacksouls/Game.rgss3a blacksouls/Audio blacksouls/Graphics blacksouls/Fonts; do
  if [ -e "$f" ]; then
    echo "ERROR: $f is present. The release must not contain game files."
    exit 1
  fi
done

rm -rf dist
mkdir -p dist/stage/blacksouls

cp "BLACK SOULS.sh" dist/stage/
cp port.json README.md gameinfo.xml screenshot.png dist/stage/blacksouls/
cp -r blacksouls/. dist/stage/blacksouls/
rm -rf dist/stage/blacksouls/stdlib dist/stage/blacksouls/log.txt
rm -f dist/stage/blacksouls/Save*.rvdata2

# patches/ is the user's translation slot. Ship the empty folder, never whatever
# a local install happens to have dropped into it.
rm -rf dist/stage/blacksouls/patches
mkdir -p dist/stage/blacksouls/patches
cp blacksouls/patches/README.txt dist/stage/blacksouls/patches/

python3 - <<'PY'
import os, stat, zipfile

OUT = "dist/blacksouls.zip"
entries = []
for root, dirs, files in os.walk("dist/stage"):
    for f in sorted(files):
        entries.append(os.path.join(root, f))

with zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as z:
    for p in sorted(entries):
        arc = os.path.relpath(p, "dist/stage")
        zi = zipfile.ZipInfo.from_file(p, arc)
        mode = os.stat(p).st_mode
        # Keep the executable bit; PortMaster needs it on the launcher and engine.
        if arc.endswith(".sh") or arc.endswith(".aarch64"):
            mode |= stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH
        zi.external_attr = (mode & 0xFFFF) << 16
        zi.compress_type = zipfile.ZIP_DEFLATED
        with open(p, "rb") as fh:
            z.writestr(zi, fh.read())

print(f"Built {OUT}  ({os.path.getsize(OUT)/1048576:.1f} MB, {len(entries)} files)")
PY

rm -rf dist/stage

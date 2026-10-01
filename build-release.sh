#!/bin/bash
# Builds the distributable PortMaster archive.
# Ships the engine only — no game files.
set -euo pipefail

cd "$(dirname "$(realpath "$0")")"

# Refuse to ship game data even if a working copy is lying around.
for f in blacksouls/Game.rgss3a blacksouls/Audio blacksouls/Graphics blacksouls/Fonts; do
  if [ -e "$f" ]; then
    echo "ERROR: $f is present. The release must not contain game files."
    exit 1
  fi
done

python3 - <<'PY'
import os, stat, zipfile

OUT = "dist/blacksouls.zip"
os.makedirs("dist", exist_ok=True)

SKIP_DIRS = {"stdlib"}
def skip(path):
    parts = path.split(os.sep)
    if any(p in SKIP_DIRS for p in parts):
        return True
    name = os.path.basename(path)
    return name.startswith("Save") or name == "log.txt"

entries = ["BLACK SOULS.sh"]
for root, dirs, files in os.walk("blacksouls"):
    dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
    for f in sorted(files):
        p = os.path.join(root, f)
        if not skip(p):
            entries.append(p)

with zipfile.ZipFile(OUT, "w", zipfile.ZIP_DEFLATED) as z:
    for p in entries:
        zi = zipfile.ZipInfo.from_file(p, p)
        mode = os.stat(p).st_mode
        # Keep the executable bit; PortMaster needs it on the launcher/engine.
        if p.endswith(".sh") or p.endswith(".aarch64"):
            mode |= stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH
        zi.external_attr = (mode & 0xFFFF) << 16
        zi.compress_type = zipfile.ZIP_DEFLATED
        with open(p, "rb") as fh:
            z.writestr(zi, fh.read())

size = os.path.getsize(OUT)
print(f"Built {OUT}  ({size/1048576:.1f} MB, {len(entries)} files)")
PY

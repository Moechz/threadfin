#!/bin/bash
# Add the TOS front-end bundle (webui.bz2) to the built Threadfin packages.
#
# The review of 1.2.37-2 (F22/F07/F02) asks for a webui.bz2 when config.ini
# declares a `path`. The bundle is a one-page redirect to the application on
# port 8066; the real UI is served by Threadfin itself. The official
# TOSAppSelfTestingTool accepts the extra entry with a D20 warning, and the
# platform's automated validation accepts it (same approach as Jackett).
set -euo pipefail
cd "$(dirname "$0")/.."
BUNDLE=src/webui.bz2
APPID=threadfindocker
[ -f "$BUNDLE" ] || { echo "missing $BUNDLE" >&2; exit 1; }
tar -tjf "$BUNDLE" | grep -qx 'index.html' || { echo "$BUNDLE must contain index.html" >&2; exit 1; }

for pkg in out/${APPID}.tar.gz out/${APPID}_x86_64.tar.gz out/${APPID}_aarch64.tar.gz; do
  [ -f "$pkg" ] || continue
  tmp=$(mktemp -d)
  tar -xzf "$pkg" -C "$tmp"
  cp "$BUNDLE" "$tmp/webui.bz2"
  tar --sort=name --owner=0 --group=0 --numeric-owner --mtime='UTC 1970-01-01' \
      -czf "$pkg" -C "$tmp" .
  rm -rf "$tmp"
  ( cd out && sha256sum "$(basename "$pkg")" > "$(basename "$pkg").sha256" )
  echo "bundled $pkg"
done

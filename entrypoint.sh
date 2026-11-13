#!/bin/sh
set -e
export PATH="${PATH}:/tmp"
if ! command -v sing-box >/dev/null; then
  7z x -y -bsp0 -bso0 "sing-box.7z" -o"/tmp"
  chmod +x "/tmp/sing-box"
fi
exec "$@"
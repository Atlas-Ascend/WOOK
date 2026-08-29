#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail
GA="$HOME/.ghost-atlas"; SRC="$GA/runtime/gb-studio-source"; VER="4.3.2"
if ! proot-distro login ubuntu -- /bin/true >/dev/null 2>&1; then proot-distro install ubuntu; fi
proot-distro login ubuntu --shared-tmp --bind "$GA:/root/.ghost-atlas" -- /bin/bash -lc '
set -Eeuo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y git curl ca-certificates build-essential python3 pkg-config
MAJOR="$(node -p "process.versions.node.split(\".\")[0]" 2>/dev/null || echo 0)"
if [ "$MAJOR" != "24" ]; then
  curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
  apt-get install -y nodejs
fi
corepack enable
SRC="/root/.ghost-atlas/runtime/gb-studio-source"
if [ ! -d "$SRC/.git" ]; then
  rm -rf "$SRC"
  git clone --branch v4.3.2 --depth 1 --recurse-submodules https://github.com/chrismaltby/gb-studio.git "$SRC"
fi
cd "$SRC"
git checkout v4.3.2
git submodule update --init --recursive
yarn install --immutable || yarn install
npm run fetch-deps
npm run make:cli
CLI="$(find "$SRC" -type f \( -name gb-studio-cli -o -name gb-studio-cli.js \) 2>/dev/null | head -1)"
test -n "$CLI"
if [[ "$CLI" == *.js ]]; then
  printf "#!/bin/bash\nexec node %q \"\$@\"\n" "$CLI" > /usr/local/bin/gb-studio-cli
else
  printf "#!/bin/bash\nexec %q \"\$@\"\n" "$CLI" > /usr/local/bin/gb-studio-cli
fi
chmod +x /usr/local/bin/gb-studio-cli
command -v gb-studio-cli
echo GB_STUDIO_CLI=PASS
'

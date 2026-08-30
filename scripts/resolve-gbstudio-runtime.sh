#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

###############################################################################
# WOOK // GB STUDIO RUNTIME RESOLVER
# Resolves only the execution seams required by already-proven production.
###############################################################################

GA="${GA_ROOT:-$HOME/.ghost-atlas}"
DISTRO="ubuntu"
CLI_JS="$GA/runtime/gb-studio-source/out/cli/gb-studio-cli.js"

echo "=== WOOK GB STUDIO RUNTIME RESOLVER ==="

# Native Termux content-build dependencies. Character/UI/prop generators use
# Pillow before handing the project to the Ubuntu-hosted GB Studio compiler.
if ! command -v python >/dev/null 2>&1; then
  echo "TERMUX_PYTHON=MISSING"
  pkg install -y python
fi
if ! python -c 'from PIL import Image' >/dev/null 2>&1; then
  echo "TERMUX_PILLOW=MISSING"
  pkg install -y python-pillow || python -m pip install --user pillow
fi
python -c 'from PIL import Image' >/dev/null 2>&1 || { echo "TERMUX_PILLOW=FAIL"; exit 40; }
echo "TERMUX_PYTHON_IMAGING=PASS"

if ! command -v proot-distro >/dev/null 2>&1; then
  echo "PROOT_DISTRO=MISSING"
  echo "ACTION=INSTALL_TERMUX_TRANSPORT"
  pkg install -y proot-distro
fi
command -v proot-distro >/dev/null 2>&1 || { echo "PROOT_DISTRO=FAIL"; exit 41; }
echo "PROOT_DISTRO=PASS"

if ! proot-distro login "$DISTRO" -- /bin/true >/dev/null 2>&1; then
  echo "UBUNTU_RUNTIME=MISSING"
  echo "ACTION=INSTALL_UBUNTU_TRANSPORT_RUNTIME"
  proot-distro install "$DISTRO"
fi
proot-distro login "$DISTRO" -- /bin/true >/dev/null 2>&1 || { echo "UBUNTU_RUNTIME=FAIL"; exit 42; }
echo "UBUNTU_RUNTIME=PASS"

# Fast path: reuse the already-proven compiler factory exactly as-is.
if proot-distro login "$DISTRO" --shared-tmp --bind "$GA:/root/.ghost-atlas" -- /bin/bash -lc 'command -v gb-studio-cli >/dev/null 2>&1 && gb-studio-cli -V'; then
  echo "GB_STUDIO_CLI=PASS"
  echo "RUNTIME_RESOLUTION=PASS_EXISTING_FACTORY"
  exit 0
fi

echo "GB_STUDIO_CLI_WRAPPER=MISSING_OR_BROKEN"

# Repair invocation wrapper only. No source checkout, migration, or project reset.
if [ ! -s "$CLI_JS" ]; then
  echo "GB_STUDIO_CLI_SOURCE=MISSING:$CLI_JS"
  echo "RUNTIME_RESOLUTION=FAIL_FACTORY_ARTIFACT_MISSING"
  exit 43
fi

proot-distro login "$DISTRO" --shared-tmp --bind "$GA:/root/.ghost-atlas" -- /bin/bash -lc '
set -Eeuo pipefail
export DEBIAN_FRONTEND=noninteractive
CLI="/root/.ghost-atlas/runtime/gb-studio-source/out/cli/gb-studio-cli.js"
if ! command -v node >/dev/null 2>&1; then
  echo "UBUNTU_NODE=MISSING"
  apt-get update
  apt-get install -y curl ca-certificates build-essential python3 pkg-config
  curl -fsSL https://deb.nodesource.com/setup_24.x | bash -
  apt-get install -y nodejs
fi
test -s "$CLI"
cat > /usr/local/bin/gb-studio-cli <<WRAPPER
#!/bin/bash
exec node "$CLI" "\$@"
WRAPPER
chmod +x /usr/local/bin/gb-studio-cli
command -v gb-studio-cli
gb-studio-cli -V
'

echo "GB_STUDIO_CLI=PASS"
echo "RUNTIME_RESOLUTION=PASS_WRAPPER_REPAIRED"

#!/data/data/com.termux/files/usr/bin/bash
set -Eeuo pipefail

###############################################################################
# WOOK // GB STUDIO RUNTIME RESOLVER
#
# Resolves only the transport/runtime seam needed to reach the already-proven
# GB Studio factory. It does not recreate the WOOK project, regenerate game
# content, rewrite Git history, or rebuild GB Studio unless a later explicit
# recovery packet is invoked.
###############################################################################

GA="${GA_ROOT:-$HOME/.ghost-atlas}"
DISTRO="ubuntu"
CLI_JS="$GA/runtime/gb-studio-source/out/cli/gb-studio-cli.js"

echo "=== WOOK GB STUDIO RUNTIME RESOLVER ==="

if ! command -v proot-distro >/dev/null 2>&1; then
  echo "PROOT_DISTRO=MISSING"
  echo "ACTION=INSTALL_TERMUX_TRANSPORT"
  pkg install -y proot-distro
fi
command -v proot-distro >/dev/null 2>&1 || {
  echo "PROOT_DISTRO=FAIL"
  exit 41
}
echo "PROOT_DISTRO=PASS"

if ! proot-distro login "$DISTRO" -- /bin/true >/dev/null 2>&1; then
  echo "UBUNTU_RUNTIME=MISSING"
  echo "ACTION=INSTALL_UBUNTU_TRANSPORT_RUNTIME"
  proot-distro install "$DISTRO"
fi

proot-distro login "$DISTRO" -- /bin/true >/dev/null 2>&1 || {
  echo "UBUNTU_RUNTIME=FAIL"
  exit 42
}
echo "UBUNTU_RUNTIME=PASS"

# Fast path: preserve and reuse the already-proven CLI exactly as-is.
if proot-distro login "$DISTRO" \
  --shared-tmp \
  --bind "$GA:/root/.ghost-atlas" \
  -- /bin/bash -lc 'command -v gb-studio-cli >/dev/null 2>&1 && gb-studio-cli -V' ; then
  echo "GB_STUDIO_CLI=PASS"
  echo "RUNTIME_RESOLUTION=PASS_EXISTING_FACTORY"
  exit 0
fi

echo "GB_STUDIO_CLI_WRAPPER=MISSING_OR_BROKEN"

# Repair the wrapper from the already-built CLI bundle if it exists. This does
# not rebuild GB Studio; it restores only the invocation bridge inside Ubuntu.
if [ ! -s "$CLI_JS" ]; then
  echo "GB_STUDIO_CLI_SOURCE=MISSING:$CLI_JS"
  echo "RUNTIME_RESOLUTION=FAIL_FACTORY_ARTIFACT_MISSING"
  exit 43
fi

proot-distro login "$DISTRO" \
  --shared-tmp \
  --bind "$GA:/root/.ghost-atlas" \
  -- /bin/bash -lc '
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

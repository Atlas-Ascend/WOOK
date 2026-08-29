#!/data/data/com.termux/files/usr/bin/bash
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
echo "WOOK DOCTOR"
for f in "$ROOT/site/index.html" "$ROOT/game/project/WOOK.gbsproj" "$ROOT/docs/visual-contract/WOOK-VISUAL-CONTRACT-001.png"; do
  [ -s "$f" ] && echo "PASS $f" || echo "FAIL $f"
done
command -v gh >/dev/null && echo "PASS gh" || echo "FAIL gh"
proot-distro login ubuntu -- /bin/true >/dev/null 2>&1 && echo "PASS ubuntu" || echo "FAIL ubuntu"

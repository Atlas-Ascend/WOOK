# WOOK Command-to-Proof Contract

## Gates
1. PAYLOAD_PASS — campaign payload present and hashed.
2. VISUAL_CONTRACT_PASS — canonical WOOK image present and hashed.
3. TERMUX_PASS — required Android shell dependencies installed.
4. UBUNTU_PASS — proot Ubuntu available.
5. GB_STUDIO_RUNTIME_PASS — native ARM64 GB Studio or CLI available.
6. GB_STUDIO_SOURCE_PASS — `.gbsproj` exists and parses.
7. GB_STUDIO_BUILD_PASS — `make:rom` and `make:web` both succeed.
8. SITE_PASS — playable web entry exists.
9. GIT_PASS — source committed.
10. GITHUB_PASS — remote repo exists and commit matches.
11. GITHACK_PASS — public URL returns HTTP 200.
12. RECEIPT_PASS — receipt records exact hashes, commit, URLs and gates.

No script may emit `COMMAND_TO_PROOF=PASS` unless required truth gates are green.

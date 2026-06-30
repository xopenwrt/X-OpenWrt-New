# x86_64 X/Y/Z Config Optimization Todo

Updated: 2026-06-29

## Scope

- `Configs/x86_64-X`
- `Configs/x86_64-Y`
- `Configs/x86_64-Z`
- `.github/workflows/X-x86_64_X.yml`
- `.github/workflows/X-x86_64_Y.yml`
- `.github/workflows/X-x86_64_Z.yml`

## Current Profile Notes

- X: broad x86_64 profile with SmartDNS, Docker, WiFi firmware/drivers, IPv6, storage/network modules, and a larger LuCI package set.
- Y: service-heavy x86_64 profile with SmartDNS, Passwall, AdGuardHome, Docker/Diskman, IPv6, and standard x86 image outputs.
- Z: compact x86_64 profile with Passwall, AdGuardHome, Diskman/Netdata, standard x86 image outputs, and Image Builder enabled.

## Todo

- [ ] Extract shared target/image basics into one common x86_64 fragment, then keep X/Y/Z as small profile fragments.
- [ ] After a successful build, run OpenWrt `scripts/diffconfig.sh` for X/Y/Z and remove redundant selected dependencies.
- [ ] Decide the Z Image Builder policy: upload generated Image Builder artifacts, intentionally ignore them, or disable `CONFIG_IB`/`CONFIG_IB_STANDALONE`.
- [ ] Standardize line endings and final newlines for `Configs/x86_64-Y` and `Configs/x86_64-Z` in a dedicated formatting-only commit.
- [ ] Build a profile matrix that records intentional package deltas between X, Y, and Z.
- [ ] Remove or relocate stale `KERNEL_PATCHVER` comments because they do not affect OpenWrt `.config` behavior.
- [ ] Confirm each profile's `CONFIG_GRUB_IMAGES`, `CONFIG_VMDK_IMAGES`, `CONFIG_VDI_IMAGES`, `CONFIG_VHDX_IMAGES`, and upload globs still match the intended release artifacts.
- [ ] Keep `CONFIG_DEVEL`, `CONFIG_CCACHE`, and other CI-only build toggles out of tracked config files.
- [ ] If config fragments are introduced, add a small generation/check script so committed full configs can be reproduced.
- [ ] Re-test X/Y/Z after cleanup with `make defconfig` and compare generated `.config` changes before committing behavior changes.

## Do Not Mix

- Do not normalize CRLF/LF while changing config semantics.
- Do not remove dependency-selected `CONFIG_PACKAGE_*` lines until a successful `diffconfig.sh` pass proves they are redundant.
- Do not change package selections in the same commit as documentation-only comment updates.

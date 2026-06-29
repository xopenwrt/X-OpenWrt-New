# AI Modification Log: CI Config Mutation

Date: 2026-06-29

## Change

- Updated X/Y/Z `Run Diy Scripts` steps so CI-only `CONFIG_DEVEL` and `CONFIG_CCACHE` settings are appended to `openwrt/.config` instead of `$GITHUB_WORKSPACE/Configs/$CONFIG_FILE`.
- Re-applied those CI-only settings after `.config` is regenerated before `Firmware_Diy_Main`.

## Reason

The workflow previously mutated tracked config files during CI runs. Writing CI-only options to `.config` keeps repository configs clean while preserving the intended build-time ccache/devel settings.

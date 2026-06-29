# AI Modification Log: Autoupdate Config Target

Date: 2026-06-29

## Change

- Updated `Scripts/AutoBuild_Function.sh` so `CONFIG_PACKAGE_luci-app-autoupdate=y` is appended to `${CONFIG_TEMP}`.

## Reason

`Firmware_Diy_Main` runs after changing into the OpenWrt worktree. Appending to `${CONFIG_FILE}` can create or edit a file named after the config profile inside `openwrt`; `${CONFIG_TEMP}` points to the active `.config` generated for the build.

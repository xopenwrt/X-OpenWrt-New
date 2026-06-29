# AI Modification Log: OpenWrt Clone Workdir

Date: 2026-06-29

## Change

- Updated X/Y/Z workflows to clone OpenWrt source into `/workdir/openwrt`.
- Kept `$GITHUB_WORKSPACE/openwrt` as a symlink to `/workdir/openwrt` for existing later steps.

## Reason

The workflows created `/workdir` but cloned into the workspace. The symlink then pointed at `/workdir/openwrt`, which did not contain the clone. Cloning directly into `/workdir/openwrt` makes the workspace symlink and subsequent `openwrt` paths consistent.

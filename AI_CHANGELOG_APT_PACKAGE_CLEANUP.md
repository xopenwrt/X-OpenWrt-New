# AI Modification Log: Apt Package Cleanup

Date: 2026-06-29

## Change

- Removed duplicate `zlib1g-dev` and duplicate `git` entries from X/Y/Z workflow apt package lists.
- Removed interactive/debug utilities that are not needed in CI package installation: `vim`, `nano`, and `lrzsz`.

## Reason

The package list had duplicate entries and editor/transfer tools that add install time without supporting the automated build path.

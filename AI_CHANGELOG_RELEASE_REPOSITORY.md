# AI Modification Log: Release Repository Selection

Date: 2026-06-29

## Change

- Updated `Scripts/AutoBuild_Upcheck.sh` to use `${GITHUB_REPOSITORY}` for release history and previous package-version downloads.
- Kept `X-OpenWrt/X-OpenWrt-Dev` as a fallback when the script is run outside GitHub Actions.

## Reason

The workflows upload releases to the current repository, but the update checker fetched release history and previous logs from a hard-coded repository. Using `${GITHUB_REPOSITORY}` keeps the checker aligned with the workflow repository.

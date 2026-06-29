# AI Modification Log: Release Tag Comparison

Date: 2026-06-29

## Change

- Updated `Scripts/AutoBuild_Upcheck.sh` release tag selection to filter tags as `vYYYY-MM-DD`.
- Sorted release tags with `sort -V` and selected the latest tag older than `${NOW_DATA_VERSION}`.
- Normalized the fallback tag to `v2023-01-01`.

## Reason

The old logic compared release tags lexically and used a non-normalized `v2023-1-1` fallback. Filtering and version sorting make date-tag selection predictable.

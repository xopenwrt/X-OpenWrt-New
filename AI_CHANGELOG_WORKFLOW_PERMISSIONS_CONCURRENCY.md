# AI Modification Log: Workflow Permissions And Concurrency

Date: 2026-06-29

## Change

- Added explicit workflow permissions to X/Y/Z workflows:
  - `contents: write`
  - `actions: write`
- Added workflow-level concurrency grouped by `openwrt-release-${{ github.ref }}`.
- Set `cancel-in-progress: false` so existing long-running builds are not cancelled automatically.

## Reason

Release uploads need content write permission, and workflow-run cleanup needs actions write permission. Concurrency prevents multiple runs of the same workflow/ref from racing on shared release tags and dated upload paths.

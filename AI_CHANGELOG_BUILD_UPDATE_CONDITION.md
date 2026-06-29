# AI Modification Log: Build Update Condition

Date: 2026-06-29

## Change

- Added an `if` condition to the `Check Build Update` step in X/Y/Z workflows.
- The step now runs only when the build succeeded, release upload is enabled, and the workflow was not cancelled.

## Reason

The update checker depends on the build log and release metadata. Running it after a failed build or when release upload is disabled can cause unnecessary failures or remote API work.

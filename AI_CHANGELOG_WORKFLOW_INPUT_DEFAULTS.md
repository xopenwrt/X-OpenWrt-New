# AI Modification Log: Workflow Input Defaults

Date: 2026-06-29

## Change

- Added `type: boolean` to the `Release` and `SharePoint` workflow dispatch inputs in X/Y/Z workflows.
- Changed env export lines to default `Release` and `SharePoint` to `true` when `github.event.inputs` is absent, such as repository dispatch runs.

## Reason

The workflows also support `repository_dispatch`, where `github.event.inputs` is not populated. Without explicit fallback values, release and SharePoint conditions can see empty strings and skip expected upload steps.

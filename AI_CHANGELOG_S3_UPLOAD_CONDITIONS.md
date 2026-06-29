# AI Modification Log: S3 Upload Conditions

Date: 2026-06-29

## Change

- Added `if: env.SharePoint == 'true' && env.Result == 'true' && !cancelled()` to enabled S3 upload steps in:
  - `.github/workflows/X-x86_64_X.yml`
  - `.github/workflows/X-x86_64_Y.yml`
  - `.github/workflows/X-x86_64_Z.yml`

## Reason

The S3 upload steps used the SharePoint/S3 upload path but did not honor the `SharePoint` input or the build `Result`. The new condition prevents uploads when SharePoint upload is disabled, the build failed, or the workflow was cancelled.

# AI Modification Log: Workflow Parallelism Variables

Date: 2026-06-29

## Change

- Added `DOWNLOAD_JOBS: 8` and `BUILD_JOBS: 4` to X/Y/Z workflow env blocks.
- Replaced hard-coded `make download -j32` / `-j8` and `make -j4` with those variables.

## Reason

X/Y/Z had drifted download parallelism while sharing the same build logic. Central variables keep the workflows consistent and make later tuning explicit.

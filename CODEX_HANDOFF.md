# Codex Handoff

Last updated: 2026-06-29

## Purpose

This file is the stable restart point for future Codex sessions in this repository. If a session is closed, the next session should read this file first, then continue from the listed state and backlog.

## Current State

- Repository: `X-OpenWrt-New`
- Branch: `master`
- Latest completed task batch: continued the GitHub Actions X/Y/Z optimization backlog through multiple high-priority and low-risk maintainability/script items.
- Latest task commit at handoff update time: `5f3650c validate workflow dispatch inputs`
- Backlog file: `NOTES_GHA_XYZ_OPTIMIZATION.md`

## Completed Backlog Items

Completed in this task series:

- #1: Fixed Z workflow S3 upload path typo.
- #2: Added S3 upload `if` conditions.
- #3: Fixed `make | tee` build result detection.
- #4: Moved Z mosdns `sed` fix before build.
- #5: Stopped CI from mutating tracked `Configs/*` for ccache/devel options.
- #6: Fixed autoupdate config append target in `Firmware_Diy_Main`.
- #7: Fixed OpenWrt clone path/workdir usage.
- #8: Made `Check Build Update` conditional.
- #9: Removed hard-coded release repository from update checker.
- #10: Replaced deprecated `::set-output`.
- #11: Added explicit workflow permissions.
- #12: Added workflow concurrency.
- #14: Pinned moving-branch workflow actions to commit SHAs.
- #15: Added typed boolean workflow inputs and defaults for repository dispatch.
- #16: Added validation for config, IP, and flag dispatch inputs.
- #20: Removed Z-only debug/noise commands.
- #21: Normalized workflow download/build parallelism variables.
- #22: Trimmed duplicate/unneeded apt packages.
- #27: Fixed `Get_Release_Info` command substitution bug.
- #28: Made diagnostic external IP lookup non-blocking.
- #30: Improved release tag comparison.

Each code fix has a corresponding `AI_CHANGELOG_*.md` file.

## Remaining Work

The next unresolved backlog items need broader design or more careful behavior decisions:

- #13: Consolidate X/Y/Z workflows. This is a large refactor; prefer a reusable workflow or matrix workflow with a separate review pass.
- #17: Replace repeated S3 upload steps with a loop or matrix.
- #18: Make firmware glob handling robust with `nullglob`/arrays and missing-file skips.
- #23: Move package replacement before defconfig/download where possible.
- #24: Pin or document external package repositories such as golang/passwall/xopenwrt package sources.
- #25/#26/#29: Larger shell robustness cleanup in `Scripts/AutoBuild_*.sh`.
- #31/#32: Rework x86_64 config maintenance and shrink configs with OpenWrt diffconfig; needs a successful build environment.
- #33: Decide whether Z Image Builder artifacts should be uploaded, ignored, or disabled.
- #34: Clean stale kernel comments in config files.

## Continuation Rule

When continuing this work, start with:

```bash
git status --short
git log --oneline -10
sed -n '1,220p' CODEX_HANDOFF.md
sed -n '1,260p' NOTES_GHA_XYZ_OPTIMIZATION.md
```

Then choose the next remaining item based on risk. For a small next step, #18 is a good candidate because it is scoped to firmware file detection/upload preparation. For a structural next step, start with #13 but plan it as a larger workflow refactor.

## Commit Discipline

- Fix one backlog issue per commit unless the user asks for a batch.
- Keep each fix scoped to the files required for that issue.
- Add a separate `AI_CHANGELOG_*.md` file for each AI-made fix.
- Do not revert unrelated user changes.
- Before committing, check `git status --short` and staged diff.
- For workflow edits, run YAML parsing and whitespace checks. Remember that Y/Z currently use CRLF line endings.

## Suggested Prompt For Next Session

```text
继续之前的任务。请先读取 CODEX_HANDOFF.md 和 NOTES_GHA_XYZ_OPTIMIZATION.md，从 Remaining Work 中选择下一个合适的问题修复，并为本次修复创建单独的 AI 修改日志和合适的 commit。
```

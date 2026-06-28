# Codex Handoff

Last updated: 2026-06-28

## Purpose

This file is the stable restart point for future Codex sessions in this repository. If a session is closed, the next session should read this file first, then continue from the listed state and backlog.

## Current State

- Repository: `X-OpenWrt-New`
- Branch: `master`
- Latest completed task: fixed the Z workflow UEFI VMDK S3 upload path typo.
- Latest task commit: `175b268 fix z s3 upload path`
- AI log for that fix: `AI_CHANGELOG_Z_S3_UPLOAD_PATH.md`
- Backlog file: `NOTES_GHA_XYZ_OPTIMIZATION.md`

## Continuation Rule

When continuing this work, start with:

```bash
git status --short
git log --oneline -5
sed -n '1,140p' CODEX_HANDOFF.md
sed -n '1,180p' NOTES_GHA_XYZ_OPTIMIZATION.md
```

Then continue from the next unresolved high-priority backlog item.

## Next Work

The first backlog item is already fixed in commit `175b268`.

Next unresolved high-priority item:

1. Add `if` conditions to all S3/SharePoint upload steps in:
   - `.github/workflows/X-x86_64_X.yml`
   - `.github/workflows/X-x86_64_Y.yml`
   - `.github/workflows/X-x86_64_Z.yml`

Expected condition:

```yaml
if: env.SharePoint == 'true' && env.Result == 'true' && !cancelled()
```

## Commit Discipline

- Fix one backlog issue per commit unless the user asks for a batch.
- Keep each fix scoped to the files required for that issue.
- Add a separate `AI_CHANGELOG_*.md` file for each AI-made fix.
- Do not revert unrelated user changes.
- Before committing, check `git status --short` and staged diff.

## Suggested Prompt For Next Session

```text
继续之前的任务。请先读取 CODEX_HANDOFF.md 和 NOTES_GHA_XYZ_OPTIMIZATION.md，从下一个未解决的 High Priority 问题开始修复，并为本次修复创建单独的 AI 修改日志和合适的 commit。
```

# GitHub Actions X/Y/Z Scan Notes

Scan date: 2026-06-28

## Scope

Target GitHub Actions:

- `.github/workflows/X-x86_64_X.yml`
- `.github/workflows/X-x86_64_Y.yml`
- `.github/workflows/X-x86_64_Z.yml`

Target OpenWrt config files:

- `Configs/x86_64-X`
- `Configs/x86_64-Y`
- `Configs/x86_64-Z`

Build scripts used by these workflows:

- `Scripts/AutoBuild_Getenv.sh`
- `Scripts/AutoBuild_DiyScript.sh`
- `Scripts/AutoBuild_Function.sh`
- `Scripts/AutoBuild_Upcheck.sh`

Related directories:

- `.github/workflows`: GitHub Actions workflow definitions.
- `Configs`: OpenWrt `.config` profiles.
- `Scripts`: shared build/env/update helper scripts.
- `CustomFiles`: patches, dependency files and Kconfig fragments injected by scripts.

## Optimization Backlog

### High Priority

1. Fix Z workflow S3 upload path typo.
   - File: `.github/workflows/X-x86_64_Z.yml`
   - Location: around line 322
   - Problem: `FILE: ./${{ steps.date.outputs.date }}e/${{ env.SP_UEFI_VMDK }}` has an extra `e`, so UEFI VMDK upload will look in the wrong directory.

2. Add `if` conditions to all S3/SharePoint upload steps.
   - Files: `.github/workflows/X-x86_64_X.yml`, `.github/workflows/X-x86_64_Y.yml`, `.github/workflows/X-x86_64_Z.yml`
   - Locations: X around lines 316-350, Y around lines 311-345, Z around lines 310-366
   - Problem: `SharePoint` input is written to `$GITHUB_ENV`, but these upload steps do not check `env.SharePoint == 'true'` or `env.Result == 'true'`.
   - Suggested condition: `if: env.SharePoint == 'true' && env.Result == 'true' && !cancelled()`.

3. Fix build result detection for `make | tee`.
   - Files: all X/Y/Z workflows
   - Locations: X around line 223, Y around line 220, Z around lines 217-220
   - Problems:
     - X/Y use `make -j4 | tee ... || make -j1 V=s`; without `set -o pipefail`, the pipeline can succeed because `tee` succeeds even when `make` fails.
     - Z adds `pipefail`, but then runs `sed` after `make`; `$?` is likely checking `sed`, not the build.
   - Suggested pattern: run `set -o pipefail`, run primary build, run fallback build on failure, store the build exit code immediately, then write `Result=true/false`.

4. Move Z mosdns `sed` fix before build.
   - File: `.github/workflows/X-x86_64_Z.yml`
   - Location: around lines 217-219
   - Problem: `sed -i 's/CGO_ENABLED=0/CGO_ENABLED=1/g' feeds/packages/net/mosdns/Makefile` is after `make`, so the intended fix is applied too late. X/Y apply it before `make`.

5. Stop mutating tracked config files during workflow execution.
   - Files: all X/Y/Z workflows
   - Locations: X around lines 191-195, Y around lines 188-192, Z around lines 187-191
   - Problem: `CONFIG_DEVEL` and `CONFIG_CCACHE` are appended to `$GITHUB_WORKSPACE/Configs/$CONFIG_FILE`. This mutates the checked-out repo copy and can duplicate lines during reruns or debugging.
   - Suggested fix: copy the selected config to a temp file or `.config` first, then append CI-only options there.

6. Fix likely wrong config append in `Firmware_Diy_Main`.
   - File: `Scripts/AutoBuild_Function.sh`
   - Location: around line 133
   - Problem: `echo -e "\nCONFIG_PACKAGE_luci-app-autoupdate=y" >> ${CONFIG_FILE}` runs after `cd openwrt`; `${CONFIG_FILE}` is the config name such as `x86_64-Z`, not `.config` or the full config path. This probably creates/edits an unintended file under `openwrt`.
   - Suggested target: `${CONFIG_TEMP}` or the generated `.config`.

7. Fix clone path/workdir usage.
   - Files: all X/Y/Z workflows
   - Locations: X around lines 160-163, Y around lines 157-160, Z around lines 156-159
   - Problem: `/workdir` is created, but `git clone ... openwrt` clones into the workspace, then `ln -sf /workdir/openwrt $GITHUB_WORKSPACE/openwrt` does not move the clone into `/workdir`.
   - Suggested fix: `git clone -b "$REPO_BRANCH" "$REPO_URL" /workdir/openwrt` then symlink `/workdir/openwrt` into `$GITHUB_WORKSPACE/openwrt`, or remove `/workdir` entirely.

8. Make `Check Build Update` conditional.
   - Files: all X/Y/Z workflows
   - Locations: X around lines 228-232, Y around lines 224-228, Z around lines 222-226
   - Problem: update checking runs even if the build failed or release upload is disabled. It depends on `openwrt/build_log.log` and remote release files.
   - Suggested condition: `if: env.Result == 'true' && env.Release == 'true' && env.UPLOAD_RELEASES == 'true' && !cancelled()`.

9. Remove hard-coded release repository from update checker.
   - File: `Scripts/AutoBuild_Upcheck.sh`
   - Locations: around lines 97 and 114
   - Problem: release history is fetched from `X-OpenWrt/X-OpenWrt-Dev`, while workflows upload to `${{ github.repository }}`.
   - Suggested fix: use `${GITHUB_REPOSITORY}` or pass the repository as an argument.

10. Replace deprecated `::set-output`.
    - Files: all X/Y/Z workflows
    - Locations: X around line 68, Y around line 83, Z around line 84
    - Problem: `::set-output` is deprecated.
    - Suggested fix: `echo "date=$(date +'%Y-%m-%d')" >> "$GITHUB_OUTPUT"`.

11. Add explicit workflow permissions.
    - Files: all X/Y/Z workflows
    - Problem: releases and workflow-run deletion need write permissions. Current workflows rely on defaults.
    - Suggested block: `permissions: contents: write, actions: write` with the minimum needed per workflow.

12. Add concurrency control.
    - Files: all X/Y/Z workflows
    - Problem: multiple runs can upload to the same `AutoUpdate` tag and same date tag, causing races and overwrites.
    - Suggested fix: add `concurrency` keyed by workflow/config, or include run id in per-run release tags.

### Maintainability

13. Consolidate X/Y/Z workflows.
    - Files: all X/Y/Z workflows
    - Problem: the three files are mostly copies, and drift has already produced Z-only bugs.
    - Suggested fix: create one reusable workflow with `config_file` and `flag` inputs, or one matrix workflow for X/Y/Z.

14. Pin actions to stable versions or SHAs.
    - Files: all X/Y/Z workflows
    - Examples: `actions/checkout@main`, `actions/upload-artifact@main`, `easimon/maximize-build-space@master`, `klever1988/cachewrtbuild@main`, `GitRML/delete-workflow-runs@main`, `xopenwrt/s3-upload-github-action@master`
    - Problem: moving branches reduce reproducibility and increase supply-chain risk.
    - Suggested fix: use versioned tags such as `actions/checkout@v4`, `actions/upload-artifact@v4`, or commit SHAs for third-party actions.

15. Use typed `workflow_dispatch` inputs and normalize defaults.
    - Files: all X/Y/Z workflows
    - Locations: inputs around lines 14-28
    - Problems:
      - `Release` and `SharePoint` are free-form strings.
      - `repository_dispatch` has no `github.event.inputs`, so manual defaults may not apply.
      - `Tempoary_*` is misspelled and spread across workflows/scripts.
    - Suggested fix: use boolean typed inputs where possible; add safe defaults in shell; keep old `Tempoary_*` as compatibility aliases if renaming.

16. Validate user inputs before using them in shell.
    - Files: all X/Y/Z workflows and `Scripts/AutoBuild_Function.sh`
    - Problems: dispatch inputs are interpolated directly into shell blocks and `$GITHUB_ENV`.
    - Suggested fix: pass inputs through `env:`, quote variables, validate config names against `Configs/*`, validate IP by regex plus octet range, and restrict flag characters.

17. Replace repeated S3 upload steps with a loop or matrix.
    - Files: all X/Y/Z workflows
    - Problem: four nearly identical upload steps make path/name mistakes easy.
    - Suggested fix: generate a list of existing firmware files and upload in a small script, or use a matrix with `FILE` values.

18. Make firmware glob handling robust.
    - Files: all X/Y/Z workflows
    - Locations: `Download Github Release API` step, X around lines 279-314, Y around lines 274-309, Z around lines 273-308
    - Problem: if a glob has no match, the literal pattern can be exported and uploaded.
    - Suggested fix: use `shopt -s nullglob`, arrays, and skip missing files explicitly.

19. Normalize line endings and final newlines.
    - Files: `.github/workflows/X-x86_64_Y.yml`, `.github/workflows/X-x86_64_Z.yml`, `Configs/x86_64-Y`, `Configs/x86_64-Z`
    - Problem: diff showed CRLF-style content and missing newline at EOF in config files.
    - Suggested fix: standardize on LF and add final newline.

20. Remove debug/noise differences between X/Y/Z.
    - File: `.github/workflows/X-x86_64_Z.yml`
    - Examples: `docker images` around line 150, extra `ls` around lines 254 and 394
    - Problem: useful while debugging, but causes drift and noisy logs if kept permanently.

### Build Efficiency

21. Revisit download/build parallelism.
    - Files: X/Y/Z workflows
    - Examples: X uses `make download -j32`; Y/Z use `-j8`; all build with `make -j4`.
    - Suggested fix: use a shared variable such as `BUILD_JOBS: $(nproc)` or a conservative configured number, then keep all workflows consistent.

22. Trim duplicate and unnecessary apt packages.
    - Files: all X/Y/Z workflows
    - Locations: init environment package list
    - Examples: `zlib1g-dev` and `git` appear more than once; editors like `vim`, `nano`, `lrzsz` are probably unnecessary in CI.
    - Suggested fix: keep only required build dependencies and split comments by category.

23. Move package replacement before defconfig/download where possible.
    - Files: all X/Y/Z workflows
    - Locations: adguardhome/passwall package deletion and symlink in build step
    - Problem: package replacement happens after `feeds install`, `make defconfig`, and `make download`; selected package metadata/download behavior may drift from the package actually built.
    - Suggested fix: perform package overrides before final `make defconfig` and `make download`.

24. Pin external package repositories or document why moving branches are used.
    - Files: workflows and `Scripts/AutoBuild_DiyScript.sh`
    - Examples: `sbwml/packages_lang_golang -b 26.x`, `OpenWrt-Passwall main`, `fw876 master`, `xopenwrt master`
    - Problem: builds can change without repo changes.
    - Suggested fix: pin to commits/tags for reproducible builds, or accept moving branches but document it.

### Script Robustness

25. Add stricter error handling carefully to scripts.
    - Files: `Scripts/AutoBuild_*.sh`
    - Problem: helper functions often log failures but return success, so missing packages/files can be hidden.
    - Suggested fix: introduce `set -euo pipefail` only after auditing expected non-fatal commands, or make critical helpers return non-zero on failure.

26. Quote variables in shell scripts.
    - Files: `Scripts/AutoBuild_Function.sh`, `Scripts/AutoBuild_Upcheck.sh`, `Scripts/AutoBuild_DiyScript.sh`
    - Examples: `cd $1`, `grep $1`, `find $2`, `rm ${SVN_REPO_NAME} -rf`, many `cat openwrt/${build_pkg_dir}/Makefile`
    - Problem: spaces, glob characters, or empty variables can cause unintended behavior.

27. Fix `Get_Release_Info`.
    - File: `Scripts/AutoBuild_Getenv.sh`
    - Location: around line 28
    - Problem: backticks around `cat ... | grep ...` execute the grep output as a command.
    - Suggested fix: `grep 'KERNEL_PATCHVER:=' "${OPENWRT_BUILD_DIR}/target/linux/x86/Makefile"`.

28. Make external IP lookup non-blocking.
    - File: `Scripts/AutoBuild_Getenv.sh`
    - Locations: around lines 18-21
    - Problem: build info step depends on external APIs for logging.
    - Suggested fix: add `curl --connect-timeout 5 --max-time 10` and tolerate failures.

29. Improve `AutoBuild_Upcheck.sh` parsing.
    - File: `Scripts/AutoBuild_Upcheck.sh`
    - Locations: around lines 23-93
    - Problems: parses build logs with multiple `cat | grep` chains, assumes Makefiles exist, and may duplicate package entries.
    - Suggested fix: use `awk/sort -u`, quote paths, skip missing Makefiles, and record warnings.

30. Improve release tag comparison.
    - File: `Scripts/AutoBuild_Upcheck.sh`
    - Locations: around lines 97-114
    - Problem: date tags are compared lexically and initialized with `v2023-1-1`.
    - Suggested fix: normalize tags to `vYYYY-MM-DD`, sort with `sort -V` or parse dates explicitly.

### Config Maintenance

31. Split common x86_64 config fragments from X/Y/Z differences.
    - Files: `Configs/x86_64-X`, `Configs/x86_64-Y`, `Configs/x86_64-Z`
    - Problem: target/image/IPv6/theme/base package settings are repeated, while X/Y/Z differ mainly by feature level.
    - Suggested fix: maintain `x86_64-common`, `x86_64-X.fragment`, `x86_64-Y.fragment`, `x86_64-Z.fragment`, then concatenate into `.config` in the workflow.

32. Shrink configs with OpenWrt diffconfig.
    - Files: `Configs/x86_64-X`, `Configs/x86_64-Y`, `Configs/x86_64-Z`
    - Problem: configs include redundant selected dependencies and stale comments.
    - Suggested fix: after a successful build, use OpenWrt `scripts/diffconfig.sh` to keep only meaningful deltas.

33. Re-check Z Image Builder expectations.
    - File: `Configs/x86_64-Z`
    - Locations: around lines 8-10
    - Problem: Z enables `CONFIG_IB` and `CONFIG_IB_STANDALONE`, but the workflow still processes/uploads only firmware image patterns.
    - Suggested fix: decide whether Image Builder artifacts should be uploaded, ignored, or disabled.

34. Clean stale kernel comments.
    - Files: `Configs/x86_64-X`, `Configs/x86_64-Y`, `Configs/x86_64-Z`
    - Problem: commented `KERNEL_PATCHVER` lines do not affect OpenWrt config and can mislead later edits.
    - Suggested fix: remove stale comments or move kernel selection into the correct build mechanism.

## Suggested First Fix Batch

1. Fix Z upload path typo and Z mosdns build-order issue.
2. Add S3 upload `if` conditions using `SharePoint`, `Result`, and `!cancelled()`.
3. Replace all build commands with a shared pipefail-safe result pattern.
4. Stop appending CI-only config options to tracked `Configs/*`.
5. Replace deprecated `set-output` with `$GITHUB_OUTPUT`.


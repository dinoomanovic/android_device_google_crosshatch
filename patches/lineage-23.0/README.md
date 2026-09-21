# LineageOS 23.0 crosshatch companion patches

These eight patches preserve the companion changes used by this device branch,
including the secure UI vendor binary fixup. They are published here so the
complete set of changes is available from the device repository. The companion
branches themselves have not been pushed to separate forks.

`series.json` records each repository, upstream URL, exact base commit, source
commit, patch filename, and SHA-256 checksum. Apply each patch to its recorded
base for the reviewed result. Other base revisions may need conflict resolution.

## Applying on another checkout

Do not apply these again to the original workspace: it already contains all
eight commits. On another checkout, first obtain the repositories at the base
commits in `series.json`. Keep local work committed or stashed and create a
working branch in each repository before applying.

From the Android source root, run:

```bash
patch_dir="$PWD/device/google/crosshatch/patches/lineage-23.0"
git -C build/soong am "$patch_dir/01-build-soong.patch"
git -C frameworks/native am "$patch_dir/02-frameworks-native.patch"
git -C hardware/qcom/audio am "$patch_dir/03-hardware-qcom-audio.patch"
git -C packages/modules/Connectivity am "$patch_dir/04-packages-modules-Connectivity.patch"
git -C packages/modules/DnsResolver am "$patch_dir/05-packages-modules-DnsResolver.patch"
git -C system/netd am "$patch_dir/06-system-netd.patch"
git -C vendor/lineage am "$patch_dir/07-vendor-lineage.patch"
git -C vendor/google/crosshatch am "$patch_dir/08-vendor-google-crosshatch.patch"
```

Run the commands individually and stop if one fails. Resolve that repository's
conflict and use `git am --continue`, or use `git am --abort` to cancel that
patch application.

## Validation and limitations

Each patch was applied to a temporary Git index containing its recorded base.
The resulting Git tree was checked against the corresponding source commit,
including the patched vendor binary. No source working trees were changed by
this verification.

This is a development checkpoint. See [BRINGUP.md](../../BRINGUP.md) for known
issues and previous build evidence. Publishing these patches does not resolve
the runtime issues or constitute a fresh build or device test. Generated kernel
output is intentionally excluded.

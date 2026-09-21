# LineageOS 23.0 crosshatch development checkpoint

This branch contains development bring-up settings. It is not a release-ready
configuration. The current changes retain permissive SELinux, unauthenticated
ADB, a development ADB public key, and forced ADB USB configuration.

## Device configuration

- `BoardConfig-common.mk` requests permissive SELinux on the kernel command line.
- `device-lineage.mk` installs `adbkey.pub` and sets `ro.adb.secure=0`.
  The public key is not a private credential, but preauthorizes its holder on
  builds that install it and use ADB authentication.
- `init.hardware.usb.rc` starts ADB at boot and configures an ADB-only gadget
  whenever `sys.usb.ffs.ready=1`. This trigger does not check the requested USB
  mode and can interfere with file transfer, tethering, or other USB functions.
- `device.mk` sets `ro.bpf.kver_override=5.4.186` in both vendor and product
  properties. The kernel source remains Linux 4.9; overriding the version does
  not supply missing kernel features.

## Companion source changes

The local build also uses companion commits in the following repositories, on
local branches named `lineage-23.0-crosshatch`. All eight companion changes are
published in this device repository as [patches](patches/lineage-23.0/README.md),
with exact base revisions and application instructions. Apply them to the
corresponding repositories when reproducing this checkout. The companion
branches have not been pushed to separate forks.

| Repository | Local change |
| --- | --- |
| `build/soong` | Go runtime environment and memory/GC defaults |
| `frameworks/native` | Skip GPU work tracking when its BPF map is absent |
| `hardware/qcom/audio` | Correct Cirrus pthread callback signatures |
| `packages/modules/Connectivity` | Bypass BPF failures and use in-memory map fallbacks |
| `packages/modules/DnsResolver` | Continue without DNS UID blocking after helper initialization fails |
| `system/netd` | Continue after bandwidth controller initialization fails |
| `vendor/lineage` | Respect disabled LLVM binutils when choosing the kernel linker |
| `vendor/google/crosshatch` | Add the secure UI JNI blob and Soong dependency on `libgui_shim` |

### Companion commit IDs

- `build/soong`: `ebc94359e055811fad74749d60fbe062b16908c1`
- `frameworks/native`: `0d066df3ed62005da5a74ce24d0f9a907ca2538f`
- `hardware/qcom/audio`: `c07932cf9cd69eacf16f74867f2681b9dbeba00b`
- `packages/modules/Connectivity`: `12741629dfeb1ab940457749686c6b190d1320ba`
- `packages/modules/DnsResolver`: `090cf19a04d0010ab5a4e4d49a9b66a40c8cf46a`
- `system/netd`: `d8c142a05e5af45a922d5cd5e42a6e6433b562c1`
- `vendor/lineage`: `7d9d2300b16af7e41b31b561790fc83606b4072a`
- `vendor/google/crosshatch`: `66d1aabb5bed79f9dac9f402474c5794aca5b5b1`

## Review findings still to resolve

- The in-memory BPF maps do not enforce kernel networking rules. Firewall,
  Data Saver, UID permissions, and port-blocking operations can appear successful
  without enforcing their policy. Missing statistics maps also produce zero or
  empty data rather than working traffic accounting. A working kernel or an
  actual enforcement/accounting fallback is required for release.
- `BpfRingbufBase` now continues after initialization failure, but `isEmpty()`
  and `ConsumeAll()` still dereference the producer and consumer pointers.
  Callers can crash when the ring buffer is unavailable.
- `BpfMapRO::abortOnMismatch()` no longer rejects incompatible key/value sizes.
  A valid descriptor for an incompatible map can remain usable, allowing kernel
  map operations to read or write beyond the supplied typed buffer.
- The GPU work map check runs before the existing BPF startup wait. It can
  disable tracking on supported kernels when initialization runs before the
  loader creates the map.
- The networking error bypasses apply globally, including to supported kernels;
  they need an explicit, limited compatibility policy and runtime validation.

## Validation recorded on 2026-09-21

- All eight modified source repositories passed `git diff --check`.
- `host_init_verifier` accepted the device USB init script in single-script mode.
- The development ADB public key decoded as an Android RSA-2048 public key.
- Existing `out/soong.log` records a successful `systemimage` build at 23:36.
  This review did not run a new full build or test a physical device.
- The available OTA ZIP is dated 2026-09-20, before the latest source changes.
  A fresh complete build and device tests are still needed, including SELinux,
  ADB authentication, USB modes, networking policy, traffic accounting, DNS,
  IPv6-only connectivity, tethering, calls, audio, camera, and OTA installation.

# Recovery Quickstart (Pixel 10 / KSU-Next)

## When to use
- Bootloop
- Root lost after reboot
- Severe instability after changing modules/settings

## Immediate actions
1. Stop making further changes.
2. Note last single change.
3. Boot to bootloader.
4. Check active slot:
   - `fastboot getvar current-slot`
5. Reflash known-good patched `init_boot` to active slot.
6. Reboot and verify root.

## If still broken
1. Reflash known-good `boot`/`init_boot` pair from same build.
2. If unresolved, flash factory image (wipe as needed).

## Never do during incident
- Do not change manager version.
- Do not switch MetaModule mode.
- Do not apply multiple fixes at once.

## Minimal verification after recovery
- `su -c id` returns uid=0
- Reboot twice
- BindHosts still enabled
- Daily apps launch normally

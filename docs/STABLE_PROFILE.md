# Stable Profile (Daily Use) — Pixel 10 / KernelSU-Next

This profile is for **daily stability first**.
Keep experiments separate.

## Core policy
- Use one stable kernel/manager combination.
- Do not change multiple knobs at once.
- Keep rollback assets ready (`init_boot.img`, `boot.img`).
- **BindHosts must stay enabled** (do not remove/disable).

## Fixed baseline
- Workflow: `kernel-a15-6.6.yml` (KernelSU-Next only, Generic fixed)
- Manager: pinned stable version (ignore update prompts unless planned test)
- MetaModule mode: keep current stable mode (do not switch casually)
- SuSFS controller: keep stable values
- Zygisk: keep current stable state
- **BindHosts: always ON**

## Do NOT change on daily profile
- Kernel name/identity tweaks during stable period
- Manager upgrades/downgrades
- MetaModule mode switching (NoMount/OverlayFS/ZeroMount)
- Large SuSFS preset changes
- Multiple changes in one reboot cycle

## Safe change protocol (if needed)
1. Change **one** item only.
2. Backup before reboot:
   - current `init_boot.img`
   - current `boot.img`
   - screenshots of current settings
3. Reboot and test 10–15 min.
4. Reboot again and confirm.
5. Only then proceed to next change.

## 30-second pre-reboot checklist
- [ ] Current slot known (`a`/`b`)
- [ ] Single change only
- [ ] BindHosts still enabled
- [ ] Rollback images ready
- [ ] Recovery plan ready

## Emergency rollback
If bootloop/root-loss/heavy instability:
1. Stop further changes.
2. Revert the last single change.
3. Reflash known-good `init_boot` for active slot.
4. If still broken, restore known-good boot chain / factory image.

## Split-lane operation
- **Daily lane (this profile):** stability only
- **Research lane:** experimental kernel/module tests
- Promote to daily lane only after repeated reboot-stable validation

## Run log template
- Date/Time:
- Current Slot:
- Kernel build:
- Manager version:
- MetaModule mode:
- SuSFS changes:
- BindHosts status:
- Single change made:
- Reboot #1 result:
- Reboot #2 result:
- Final status:

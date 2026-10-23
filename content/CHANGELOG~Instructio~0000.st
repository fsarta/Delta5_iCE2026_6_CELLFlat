(*
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Guiding Principles
- Changelogs are for humans, not machines.
- The latest version comes first.
- Group changes by type under these headings:
  - `Added` for new features.
  - `Changed` for changes in existing functionality.
  - `Deprecated` for soon-to-be removed features.
  - `Removed` for now removed features.
  - `Fixed` for any bug fixes.
  - `Security` in case of vulnerabilities.

---

EXAMPLE

## [2.0.0] - 2025-11-07

# Added
- Added new Function Block `FB_EnergyMonitoring` to track power consumption for main drives (Ref: TICKET-130).
- Implemented new `FB_OEE_Calculator` to provide overall equipment effectiveness data.
- Added "Maintenance" and "Cleaning" modes to the machine's main state machine (`CASE` statement in `FB_MachineMode`).
- New HMI diagnostics screen for the hydraulic power unit.

# Changed
- **BREAKING CHANGE:** Reworked `FB_MotorControl` interface. The `bStart` and `bStop` inputs (BOOL) have been replaced with a single `iMode` input (INT) to allow for more commands (e.g., Jog, E-Stop).
- Updated `OB1` cycle time from 50ms to 20ms to improve PID loop response.
- Modified the UDT `UDT_Recipe` to include new parameters for `MixerSpeed` and `BakeTime`.
- Alarm texts for the "Conveyor" group have been updated for clarity.

# Deprecated
- The old Function Block `FB_Motor_V1` is now deprecated and will be removed in v3.0.0. Please migrate all instances to the new `FB_MotorControl` (v2.0).
- The global variable `g_bManualModeActive` is deprecated and will be removed. Please use `FB_MachineMode.bManualActive` instead.

# Removed
- **BREAKING CHANGE:** Removed the obsolete `FB_OldConveyorLogic` and its instance DB. This functionality is now handled by the `FB_MaterialHandling` FB.
- Removed unused global data block `DB_TempCalculations`.
- Deleted several unused variables (tags) from the default HMI tag table.

# Fixed
- Corrected a race condition in `FB_Sequencer` where Step 10 and Step 20 could occasionally become active simultaneously.
- Fixed a calculation error in `FB_FlowTotalizer` that caused rounding errors when the flow rate was low.
- Resolved an issue where the "E-Stop" alarm would not latch correctly and would clear automatically after reset (Ref: TICKET-125).

# Security
- Forced a mandatory password change for all HMI users with 'Administrator' level access upon first login after the update.
- Disabled the unencrypted (non-secure) PG/PC communication access on the PLC's Ethernet port.
- Patched a vulnerability where an HMI user could access engineering screens by manipulating panel URLs (Ref: CVE-2025-XXXXX).

*)
---
objective: "Make active enemy hit feedback visually consistent and replace the gameplay background with coherent native-resolution art while preserving gameplay."
status: in-progress
---

# Plan: Enemy sprite consistency and background rework

## Overview

| Field | Value |
| --- | --- |
| **Goal** | Complete the sprite replacement checkup, harmonize active enemy impacts, and rework the background with verified in-game readability. |
| **Source** | Maintainer request on 2026-09-20: check replacement sprites, address inconsistent enemy hit animations, use Aseprite if useful, and rework the background. |

The read-only checkup is recorded in [checkup.md](./checkup.md). This plan does not implement or approve another gameplay-roadmap phase. Only an explicitly requested phase may be implemented, and each must pass before the next starts. Existing staged changes are the working baseline and must be preserved. No commit or publication is requested.

Scope: inspect all currently used replacement-art families; implement corrections for the seven active enemy/hazard families, inherited mounted turrets, their existing elite presentation, and the shared background. Record unrelated player, weapon, shield and pickup findings without silently broadening implementation. Exclude new enemy roles, bosses, attack telegraphs, progression, new gameplay effects and balance changes.

Background working assumption, pending maintainer preference: dark industrial space, restrained stars, distant matter and peripheral wreckage, with an uncluttered combat area. Phase 1 makes this concrete before asset production. Current dimensions are 640 × 400, not the historical 1066 × 800 or 1920 × 1080 examples. Lost Warden 64 is the current palette; older 24-color references are historical.

## Phases

| # | Phase | File |
| --- | --- | --- |
| 1 | Confirm the active asset inventory and visual contract | [phase-1.md](./phase-1.md) |
| 2 | Harmonize active enemy art and hit feedback | [phase-2.md](./phase-2.md) |
| 3 | Produce and integrate the native background | [phase-3.md](./phase-3.md) |
| 4 | Verify the combined result and reconcile documentation | [phase-4.md](./phase-4.md) |

## Decisions

| Decision | Why |
| --- | --- |
| Preserve damage, motion and cadence; keep the carrier's 32 × 64 authored grid and present the complete assembly at 64 × 128. | Two maintainer reviews found the 16 × 32 legacy hull and then the scale-one replacement too small in game. The 2× assembly is a bounded capital-ship exception; other actors retain their geometry. |
| Keep editable Aseprite sources and runtime exports synchronized, with explicit frame mapping. | File names alone do not establish source provenance; the interceptor and carrier already expose mismatches. |
| Extend the existing shared enemy feedback and three-layer background implementation. | These already provide the required runtime mechanisms; replacing them with a general animation framework or nine-layer environment system adds unnecessary scope. |

# Phase 1 Playtest Record

Status: pending hands-on solo and local co-op sessions. This record does not approve Phase 1.

Runtime smoke check (2026-09-22): Godot 4.7.2 opened the main scene without reported startup errors; solo and local co-op both reached the world scene. This does not assess combat feel or wave readability.

## Setup

- Run the current project in a Godot debug build with the GL Compatibility renderer.
- Test solo first, then local co-op. Use F2 to advance one wave and F1 to return one wave; verify the HUD wave number after each jump. Restart between modes.
- At each target wave, play long enough to see the full formation and its exit. Record the build revision, display size, input devices, and any issue with a timestamp or screenshot.

| Wave | Solo | Co-op | Main observation |
| --- | --- | --- | --- |
| 1–3 | Pending | Pending | Drone arcs, initial pace, projectile visibility |
| 6 | Pending | Pending | Lane spacing and collision readability |
| 9 | Pending | Pending | Turret telegraphs and aimed/radial shots |
| 12 | Pending | Pending | Mother ship arrival, modules, and shot density |
| 15 | Pending | Pending | Mixed enemy paths and pickup visibility |
| 18 | Pending | Pending | Dense combat, elite recognition, and performance |

## Checks in each mode

- Move idle, while firing, and while using the beam. Note whether the 0.88 weapon speed feels controllable and whether damage feedback obscures movement.
- Collect plasma cells, activate the beam above the minimum reserve, release it early, and try a full-reserve overdrive. Note whether the primary cannon remains useful.
- Watch enemy paths, shot glows, foreground streaks, hit flashes, and camera shake together. Note unclear collisions or shots lost against the background.
- In co-op, check that both players remain distinguishable and can read their own plasma, hits, and weapon fire during crowded formations.

## Decision

Record observations and any required fixes here after the hands-on sessions. Approve Phase 1 only after the solo and co-op checks pass; the visual production phase follows that approval.

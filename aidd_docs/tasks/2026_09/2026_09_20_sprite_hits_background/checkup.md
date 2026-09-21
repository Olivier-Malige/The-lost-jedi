# Sprite and background checkup — 2026-09-20

## Initial planning method and limits

Read-only review of the current working tree, including staged enemy hit-flash changes. Inspected scene references and animation tracks, enemy damage dispatch, palette and roadmap documents, source metadata through the Aseprite MCP, and exported pixels through Pillow. Visually inspected the interceptor sheet, current carrier sheet, native background and background variant comparison.

No game session or runtime test was executed during planning. The maintainer's missing-hit observation is not yet reproduced in a recorded gameplay sequence. Asset differences and shader parameters are not proof of visible feedback. No runtime code or art was modified.

## Confirmed findings

1. All seven active families declare hit tracks. The working tree adds a common shader flash: 40 ms hold, 80 ms fade, strength 0.6. Positive damage triggers it; ordinary impacts also play hit frames and apply existing recoil. Beam damage with `impact_feedback = false` flashes without playing the hit animation or recoil. These two routes need separate visual validation.
2. Every current hit/return frame pair has different visible pixels. This rules out identical frame pairs as a universal explanation; it does not prove the selected pose or flash is perceptually correct.
3. `mother_ship.tscn` still uses `mother_ship.png`, a legacy-looking 176 × 32 export with eleven 16 × 32 cells. The same-name `.ase` has ten frames and no tags. The prepared `grave_carrier_32x64.ase` has eleven 32 × 64 frames, authored hit/damage states, independent turret layers and a different frame contract. Direct substitution would change footprint and assembly.
4. The interceptor export has eleven 32 × 32 cells; its same-name source has ten frames. Its hit tag still points to the expected fourth frame, so this mismatch alone does not establish the cause of the missing-hit observation. Reconcile the full source/export sequence before editing or re-exporting.
5. Active elite presentation is runtime `self_modulate` plus an indicator. Prepared elite sheets are not selected by `enemy.gd`. Mounted turrets inherit `turret.tscn`; they are an additional integration case, not a separate omitted sprite family.
6. The current background uses two 600 × 450 exports over three ParallaxLayers, repeats at 600 × 450, and has ratios 1.1 / 0.8 / 0.5. Its source textures are sparse stars. The nine-layer 1600 × 1200 Aseprite environment and prepared variants are separate, unintegrated assets. The viewport is now 640 × 400, making full-width coverage and repeat behavior explicit validation requirements.
7. `docs/background_variants.md`, `docs/display_layout.md` and parts of `docs/graphics_replacement_readiness.md` describe earlier states. Current player scenes already reference Nomad art and an animation-rework destruction sheet. `docs/color_palette.md` now specifies Lost Warden 64. Do not use old readiness statements as evidence of current integration.
8. Projectile replacement is mixed: fighter and side shots use newly staged SVG lasers, while interceptor/carrier shots and turret shots still reference older PNGs. Record these in the broader inventory; this plan does not automatically replace them.

## Current hit mapping

Indices below are Godot zero-based indices. Aseprite MCP tags are one-based. Counts compare visible RGBA pixels between the hit frame and the return frame in the current export, not source frames.

| Scene | Current frame footprint | Hit → return | Changed visible pixels |
| --- | --- | --- | --- |
| drone | 32 × 32 | 1 → 0 | 195 |
| tie | 32 × 32 | 4 → 2 | 202 |
| interceptor | 32 × 32 | 3 → 0 | 184 |
| turret | 32 × 32 | 1 → 0 | 211 |
| mother_ship | 16 × 32 | 1 → 0 | 374 |
| asteroid | 32 × 32 | 1 → 0; 3 → 2; 5 → 4 | 102; 105; 116 |
| big_asteroid | 32 × 32, current root scale 2 | 1 → 0; 10 → 9; 12 → 11; 14 → 13 | 142; 142; 141; 141 |

All current hit animations last 120 ms and switch back at 50 ms. The larger asteroid's integer root scale is an existing explicit exception in `tests/test_native_scale.gd`; preserve it.

## Feasibility evidence

| Source | What it settles |
| --- | --- |
| `scenes/enemies/enemy.gd`, `scenes/effects/enemy_hit_flash.gdshader`, `enemy_hit_flash.tres` | Shared per-instance flash already exists; extend it rather than duplicating seven controllers. Check lethal-hit cleanup and tint interactions visually. |
| Seven `scenes/enemies/*.tscn` and `mother_ship_turret.tscn` | Active atlas layouts, hit indices, inherited turret scene and scale exceptions. |
| Aseprite MCP `get_sprite_info` on drone, tie_sheet, interceptor, turret, mother_ship, asteroid_sheet, big_asteroid and grave_carrier_32x64 sources | Editable sources are accessible; source dimensions/tags expose carrier and interceptor synchronization work. No source changes were made. |
| `tests/test_enemy_feedback.gd` | Tests immediate/fading/repeated per-instance flash and beam recoil exclusion. Does not verify actual rendered pixels, all asteroid variants, mounted turrets, real elite setup or lethal transitions. |
| `scenes/world/background.gd`, `background.tscn`, `project.godot` | Existing parallax, event-driven speed response of 30–50 around 40, scene starting speed 0, actual viewport and filtering. |
| `scenes/main/main.tscn`, `scenes/world/world.tscn`, `scenes/main/star_field.gd` | Background is shared by loader and gameplay; additional menu particles need a contrast check after integration. |
| Aseprite MCP on `space_background_parallax.ase`; `docs/background_variants.md` | Nine editable source layers exist, but prepared formats and palette exceptions require native recomposition. |
| `docs/color_palette.md`, `docs/palette_audit.md`, `scripts/art/audit_palette.py` | Lost Warden 64 is current; historical global palette failures must be distinguished from regressions in changed assets. |
| `docs/gameplay_rework_plan.md`, `AGENTS.md`, `tests/test_native_scale.gd` | Visual scope, phase sequencing, unchanged gameplay, source preservation and current presentation constraints. |

## Applicable rules and risks

- Preserve staged changes and existing node names. New files use snake_case; documentation uses English. No commits are authorized.
- Use source/export pairs, explicit atlas indices and nearest filtering. Do not bulk-import eight-column animation-rework atlases into horizontal scene layouts.
- Keep damage, cadence, collision shapes, spawn data, movement, pooling and Events boundaries unchanged. Maintain deferred physics-safe collision shutdown.
- Retain F1–F6/debug behavior and the current solo/co-op presentation. No later gameplay-roadmap phase starts through this plan.
- A flash can pass a numeric test but remain invisible in dense combat, tinted elite states, carrier materialization or a one-shot kill. Verify each route in context.
- Editing the carrier risks duplicate drawn turrets and incorrect muzzle anchors. Produce a native hull adaptation using the approved carrier visual language and existing independently targetable turret nodes.
- Palette conformity alone cannot establish visual consistency. Large scene lighting changes, low-alpha compositing, saturated stars and dense wreckage can compete with shots.
- Equal seam pixels do not establish good scrolling. Verify coverage and repetition over multiple full cycles with current camera shake and speed response.
- Final background direction remains a working assumption until the maintainer responds or reviews the concrete phase-1 reference.

## Phase 1 follow-up — authorized and completed on 2026-09-20

The initial planning-only limitations above are superseded for the controlled cases below. See [visual_contract.md](./visual_contract.md) for the complete active inventory, current source mappings and proposed visual targets. The [baseline board](../../../../assets/art/sprite_references/sprite_hits_background/baseline.png) contains actual Godot renders at native scale, not a simulated shader preview.

### Rendered feedback investigation

Godot 4.7.2/OpenGL Compatibility ran 18 controlled targets: five ordinary ship families, all three small-rock and four large-rock alternatives, an inherited mounted turret, and five elites configured through the real spawn context. Both carriers retained their mounted children. Fixtures used fixed positions, survivable health, stopped attacks/movement and disabled contacts, with carrier arrival advanced to its active state. The existing damage methods and feedback/destruction code ran unchanged. A temporary Node2D stage inside a SubViewport supplied the proper parent contract for debris; no test harness was added to the game.

| Observation / assertion | Result |
| --- | --- |
| Single positive damage | All 18 set per-instance flash to 1; ordinary hit poses visibly render. |
| Settled single hit | All 18 return to flash 0 and the appropriate start/variant animation. |
| Beam-style positive damage | All 18 flash; all positions match their pre-beam positions. |
| Two additional impacts 40 ms apart | All 18 restart at flash 1 and settle back to 0. |
| Real elite tint | Unchanged after the sequence. |
| Lethal hit | All 18 enter `explode`, with destruction taking priority over surviving-hit return. |
| After destruction | All 18 original targets are freed after the 1.25-second observation wait; spawned rock fragments are separate objects. |
| Existing feedback test | `godot --headless --path . --script res://tests/test_enemy_feedback.gd --log-file /tmp/lost_warden_phase1/feedback_test.log`: PASS, exit 0. |
| Existing native-scale test | `godot --headless --path . --script res://tests/test_native_scale.gd --log-file /tmp/lost_warden_phase1/native_test.log`: PASS, exit 0. |

No missing dispatch or stuck-hit state was reproduced in these cases. **Weak carrier-hull readability was observed**: the body flash is largely obscured by independently damageable mounted turrets that do not flash on hull damage. In contrast, large asteroids produce a very broad white peak. Harmonization must address what the assembled objects communicate, not just whether every node has a `hit` animation. Direct damage probes do not prove all real projectile contacts, arrival states, sustained-beam brightness or dense-wave conditions.

### Source/export verification and additional inventory findings

Eighteen Aseprite sources were opened and rendered without saving them. Same-index visible pixel comparisons passed in full for drone (11 frames), fighter (13), turret (11), small rock (11), large rock (18), primary and side pulse masters (5 each, with packed team rows), beam (20), shield (24), pickups (8), and player destruction (9 authored frames). Both energy and reactor team-layer exports were separately rendered and matched.

- Interceptor source/export frames 0–3, including the hit pose, match exactly; mismatches start at frame 4. The source is ten frames and the runtime export eleven. This rules out a stale hit pose as the specific consequence of that mismatch.
- None of the old carrier source's ten frames matches its current export at the same index. The prepared Grave Carrier source remains a different 32 × 64 asset.
- Current Nomad team exports are 6 × 6 atlases. The documented 13-frame source and inspected 19-frame animation-rework source do not establish their full production mapping. This is a recorded player-source follow-up, not authorization to modify the player.
- Staged hostile SVG lasers use three RGB colors outside Lost Warden 64. Older active interceptor/turret PNG shots and current starfield exports also contain palette exceptions. The inventory distinguishes these active cases from unused libraries.
- World `background.tscn` instances have different initial speeds: the base/loader scene starts at 0, while `world.tscn` explicitly overrides it to 40. Preserve this distinction during integration.

### Scope and final verification

Phase 1 produces only this updated checkup, `visual_contract.md`, the native comparison board, and phase status changes. All previously tracked files were compared by SHA-256 against a start-of-phase snapshot: no changes. The staged patch was compared byte-for-byte: preserved. The final successful visual probe exited cleanly, all temporary game processes completed, and the editor-run cleanup reported no project left running. No art source, runtime export, scene, script, gameplay resource or commit was changed.

The proposed background remains dark industrial space with sparse peripheral debris, three 640 × 450 layers and a protected central combat band. Final color-variant preference is explicitly open. Dense solo/co-op validation belongs to later implementation phases.

## Maintainer scale feedback after phase 1

The maintainer identified the carrier's size as incorrect. Reinspection confirms a 16 × 32 runtime hull with two 32 × 32 mounted turret sprites, versus the prepared carrier's intended 32 × 64 hull. The earlier recommendation to redraw the carrier into the old footprint is superseded. Phase 2 now proposes native 32 × 64 integration and explicit hull/turret geometry and anchor alignment; damage, movement and cadence stay unchanged. This is a plan correction only; no runtime scale or collision was changed.

## Carrier scale implementation after rebase — 2026-09-21

The rebase retained the 32 × 64 replacement, but its scale-one presentation still read like a regular enemy. The complete carrier assembly now displays at 2×, giving it a 64 × 128 footprint while keeping the Sprite2D at scale one for nearest-neighbor sampling. The hull collision scales to 48 × 108 world pixels. Idle frames 0–2 and authored hit frame 3 are restored; destruction remains frames 5–10. Dedicated port/starboard turret components scale with the carrier and remain independently targetable.

A focused Godot capture compared the assembled carrier with the 32 × 32 Nomad player and confirmed the intended capital-ship hierarchy. `test_native_scale.gd` and `test_enemy_feedback.gd` pass. The broader collision-alignment test still reports pre-existing pickup collision failures unrelated to this carrier change.

The same rebase left literal conflict markers in `export.cfg`; they were resolved in favor of the newer `a5.1` version values. No other conflict markers remain in the inspected project text files.

## Phase 2 completion — 2026-09-21

The interceptor source now contains the missing fifth `damaged` frame as an explicit `Runtime Damaged Reference` layer. It exports to the existing 352 × 32 runtime sheet with zero visible-pixel differences, preserving every active idle, hit and explosion cell.

The carrier’s mounted turrets now use dedicated 14 × 18 armored twin-barrel art with independent hit frames. Their 12 × 13 local housing collision, 14 × 18 visibility region and `(0, 10)` muzzle marker align with the new pixels and the carrier’s 2× assembly scale.

`test_enemy_feedback.gd` now exercises all three small-rock and four large-rock variants, the five configured elite families, an independently mounted turret, repeated/beam impacts and lethal transitions. The feedback and native-scale tests pass. The general collision-alignment test also passes for the updated carrier parts; its remaining seven `power_up.tscn` assertions predate this phase and are outside its scope.

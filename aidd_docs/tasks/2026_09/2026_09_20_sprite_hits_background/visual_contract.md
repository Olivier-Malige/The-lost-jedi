# Active sprite inventory and visual contract

Date: 2026-09-20. Phase 1 only. The implementation plan is approved; the visual targets below are a concrete proposal for the subsequent art phases, not a claim of final aesthetic approval.

## Baseline and evidence

- Branch: `feat/rework-graphic`. Existing staged changes, including the shared hit flash, are part of the inspected baseline.
- Engine: Godot 4.7.2, OpenGL Compatibility, NVIDIA RTX 3060. Runtime viewport: 640 × 400. No gameplay resources or native art sources were edited.
- [Native comparison board](../../../../assets/art/sprite_references/sprite_hits_background/baseline.png): idle, first rendered surviving-hit frame, return after a 170 ms wait, and the current game. Each panel is an unscaled 640 × 400 capture; labels are outside the game panels. The board is 1280 × 856.
- Eighteen controlled cases: five ordinary ship families, three small asteroid alternatives, four large asteroid alternatives, one mounted turret, and five real elite-configured ship families. Carriers retain their independently instantiated turret children.
- Controlled targets use survivable health, fixed positions, stopped movement/shooting and disabled physical contacts. Carrier arrival is advanced to its active state. Real `_hit_something` dispatch, animation players, shaders, elite setup and destruction code run unchanged. Single hit, beam-style damage, two rapid hits 40 ms apart and lethal damage are observed. These are rendered feedback probes, not a simulation of every projectile collision or dense wave.
- Final probe completed without script errors. All 18 targets flashed on positive damage, settled to zero flash, restarted on rapid damage and were freed after lethal damage. Beam-style damage preserved positions. Elite tint was unchanged. Existing `test_enemy_feedback.gd` and `test_native_scale.gd` both passed.
- Temporary probe setup errors were corrected before the successful run; they were invalid test-parent/API assumptions, not game defects. No probe script or test override is installed in the repository.

## Finding that changes the implementation priority

The observed complaint is **not reproduced as a missing dispatch or missing hit animation** in the 18 controlled cases. It **is reproduced as weak carrier-hull feedback within the assembled carrier**: the hull changes while the two mounted turrets remain visually unchanged. Their 32 × 32 sprites, centered at x = −8.5 and +8.5, cover much of the 16 × 32 hull. The board makes this visible for ordinary and elite carriers. This follows the independently damageable parts, but the assembled silhouette communicates the hit poorly.

The other families produce very bright near-white whole-body peaks; large asteroids become large bright masses. Elite halos remain red/violet and elite hulls are darker at rest. The shared timing is consistent, but the material and brightness response still need visual harmonization. This is a perceptual finding, not a missing-method bug.

Lethal damage correctly chooses `explode`; it does not need to play a complete surviving-hit pose first. Tests did not reproduce a stuck flash, wrong asteroid return variant, lost elite tint or a failure to finish destruction. Sustained full-wave readability, repeated beam duty-cycle brightness, carrier arrival-state readability and real shot-contact coverage remain later integration checks.

## Inventory conventions

- `S/` = `assets/sources/`; `R/` = `assets/sprites/`. All frame indices in this document are **zero-based**, including source tags translated from the Aseprite MCP's one-based values.
- “Equal” means visible RGBA pixels match after reshaping the atlas into source frames, ignoring RGB under fully transparent pixels. It does not imply timing or scene integration is correct.
- Palette checks compare visible texture RGB against `assets/palettes/lost_warden_64.gpl`. Shader output, node modulation and alpha compositing can legitimately create intermediate displayed colors; counts below describe authored pixels.

## Active enemy and hazard inventory

Scene names are relative to `scenes/enemies/`. Export names are relative to `R/enemies/`; source names to `S/enemies/`.

| Family / scene | Active export and layout | Editable source and zero-based tags | Current scene mapping | Palette / source status |
| --- | --- | --- | --- | --- |
| Razor Wing / `drone.tscn` | `drone.png`, 352 × 32, 11 horizontal 32 × 32 cells; flipped vertically | `drone.ase`, idle 0, hit 1, explode 2–10 | start 0; hit 1 → 0; explode 2–10 | Palette pass; all 11 frames equal. |
| Razor Fighter / `tie.tscn` | `tie_sheet.png`, 416 × 32, 13 horizontal 32 × 32 cells; flipped vertically | `tie_sheet.ase`, idle 1–3, hit 4, damaged 5, explode 6–12 | looping start 1,2,3,2,1; hit 4 → 2; explode 6–12 | Palette pass; all 13 frames equal. Frame 5 exists as a damaged pose, not a newly implemented health state. |
| Talon / `interceptor.tscn` | `interceptor.png`, 352 × 32, 11 horizontal 32 × 32 cells; flipped vertically | `interceptor.ase`, 10 frames: idle 0–2, hit 3, explode 4–9 | start 0,1,2,1,0; hit 3 → 0; explode 5,6,7,7,8,9,10 | Palette pass; frames 0–3 equal; source/export differences begin at index 4. Do not overwrite runtime from this source without reconciliation. |
| Siege / `turret.tscn` | `turret.png`, 352 × 32, 11 horizontal 32 × 32 cells | `turret.ase`, idle 0, hit 1, explode 2–10 | start 0; hit 1 → 0; explode 2–10 | Palette pass; all 11 frames equal. Attack telegraph modulation is separate from hit art. |
| Carrier / `mother_ship.tscn` | `mother_ship.png`, 176 × 32, 11 horizontal 16 × 32 cells | `mother_ship.ase`, 10 frames, no tags; prepared replacement is `grave_carrier_32x64.ase`, 11 frames, idle 0–2, hit 3, damaged 4, explode 5–10 | current start 0; hit 1 → 0; explode 2–10 | Current export: 10 of 11 visible RGB colors outside palette. None of the ten same-index source frames equals the current export. Prepared 32 × 64 hull is not integrated. |
| Small rock / `asteroid.tscn` | `asteroid_sheet.png`, 352 × 32, eleven 32 × 32 cells | `asteroid_sheet.ase`, rotations 0/2/4, hits 1/3/5, breakup 6–10 | hit1 1 → 0; hit2 3 → 2; hit3 5 → 4 | Palette pass; all 11 frames equal. Selected Dark Slate layer is authoritative. |
| Large rock / `big_asteroid.tscn` | `big_asteroid_sheet.png`, 288 × 64, 9 × 2 cells of 32 × 32; root scale 2 gives 64 × 64 | `big_asteroid.ase`, 18 frames: rotations 0/9/11/13; hits 1/10/12/14; breakup 3–8; debris tail 15–17 | four matching hit/return pairs; explode 3–8 | Palette pass; all 18 frames equal. Preserve the existing root-scale exception and collision radius 26 in world units. |
| Mounted siege / `mother_ship_turret.tscn` | Inherits `turret.png` and its 32 × 32 frames | Inherits `turret.ase`; no independent source needed | Inherits start/hit/explode; mounted position restored after impact | Palette/source pass through inheritance. Hitbox is independently defined as 24 × 22. |
| Existing elites | Same five ship exports as ordinary enemies | Prepared elite `.ase` sources exist but are not selected by `enemy.gd` | Ordinary hit tracks plus `_setup_elite_indicator`, `self_modulate` tint and health indicator | No active elite-sheet replacement. The test used real `EnemySpawnContext` and `elite_definition.tres`, not a manually assigned tint. |

All current surviving-hit clips last 120 ms, returning to the ordinary pose at 50 ms. Shader envelope is 40 ms hold plus 80 ms fade, strength 0.6. The fighter subsequently resumes its three-frame idle cycle, so the settled frame need not be exactly the intermediate return frame 2.

## Active player, weapon, pickup and supporting inventory

| Family and actual runtime reference | Export layout / active mapping | Source and tags | Palette / synchronization / integration |
| --- | --- | --- | --- |
| Nomad teams: `player.gd` selects `PLAYER_ONE_TEXTURE` / `PLAYER_TWO_TEXTURE`; `player.tscn` supplies the red default | `R/player/nomad-red.png`, `nomad-blue.png`, both 192 × 192, 6 × 6 cells of 32 × 32. Idle 0; left 6–8; right 12–14. | Documented `S/player/ship_banking_master.aseprite` has 13 frames: idle 0, left 1–3, return 4–6, right 7–9, return 10–12. Alternative `animation_rework/nomad.ase` has 19 frames and a different tag layout. | Both exports pass palette and are integrated. Documented 13-frame source does not reproduce the current red atlas at the same indices. Neither inspected source establishes the complete 36-cell production mapping. Source provenance is a follow-up; do not regenerate or replace the player in this phase. |
| Player destruction: `player.tscn` ExplosionSprite | `R/effects/animation_rework/nomad_explosion_sheet.png`, 256 × 64, 8 × 2 cells of 32 × 32; scene plays 0–8 | `S/effects/animation_rework/nomad_explosion.ase`, nine frames, explode 0–8 | Palette pass; all nine authored frames equal. Remaining atlas cells are packing capacity, not extra animation. Integrated. |
| Primary pulse: `player_shot.tscn` | `R/player/player_shot.png`, 80 × 16; Godot 5 × 2 cells of 16 × 8. Red power tiers 0–4, blue 5–9. | `S/player/pulse_shot_primary_master.ase`, five 16 × 16 frames containing both team rows; small/normal/big/large/full at 0/1/2/3/4 | Palette pass; all five combined source frames equal. Select power/team cells, never animate through power levels. Integrated. |
| Side pulse: `player_side_shot.tscn` | `R/player/player_side_shot.png`, 30 × 16; Godot 5 × 2 cells of 6 × 8; same team/tier mapping | `S/player/pulse_shot_side_master.ase`, five 6 × 16 combined-team frames, same five static tags | Palette pass; all five source frames equal. Integrated. |
| Continuous beam: `beam/continuous_beam.tscn` and `beam_flow.gdshader` | `R/player/beam.png`, 320 × 16; twenty 16 × 16 source tiles, each containing two 8-pixel team rows. Shader uses normal tier 2 (tiles 8–11) or overdrive tier 4 (16–19), widths 8/16. | `S/player/plasma_beam_master.ase`, 20 frames, five four-frame tags: 0–3 / 4–7 / 8–11 / 12–15 / 16–19 | Palette pass; all twenty source frames equal. Integrated through shader sampling, not Sprite2D hframes. |
| Shield and throwback echo: `shield.tscn`, `shield.gd` | `R/player/shield.png`, 96 × 40, 6 × 4 cells of 16 × 10. Team-one idle 0–5, hit 6–11; team-two idle 12–17, hit 18–23. Hit returns to matching charge level; echo uses hit cell. | `S/player/nomad_shield_master.ase`, 24 frames, matching four six-cell tags | Palette pass; all 24 source frames equal. Existing throwback work is preserved; extended animation library is not active. |
| Player reactor/team particles: `player.gd` dynamically loads `id_Player + "_particle.png"`; `reactor_particles.tscn`, enemy reactor scene | `R/player/player1_particle.png`, `player2_particle.png`, 32 × 32 static images | `S/player/player_reactors_master.ase`, one frame, red/blue layer visibility exports | Palette pass; both isolated team-layer renders equal exports. Integrated; historical claims of missing dynamic assets do not apply. |
| Energy pips: `hud.gd` dynamically loads `player_id + "_energy.tscn"` | `assets/ui/player1_energy.png`, `player2_energy.png`, 32 × 32 static icons at sprite scale one | `S/player/player_energy_master.ase`, one frame, team-layer visibility exports | Palette pass; both team renders equal exports. Control minimum is 12 × 6 while sprite is 32 × 32; verify stacking/readability in a separate HUD scope. |
| Upgrade and plasma pickups: `scenes/ui/power_up.tscn`, `plasma_cell.tscn` | `R/pickups/power_up.png`, 128 × 16, eight 16 × 16 cells at scale one. Damage/speed/repair/side/shield/beam-slot/fire-rate/plasma = 0–7. | `S/pickups/power_up_master.ase`, eight static tags matching that order | Palette pass; all eight frames equal. Current direct upgrade pool excludes beam slot 5; plasma uses 7. Integrated. |
| Fighter / side hostile laser: `tie_shot.tscn`, `interceptor_side_shot.tscn` | `R/combat/enemy_laser.svg`, `enemy_side_laser.svg`, static native textures | SVGs are themselves editable vector sources; no Aseprite tag contract | Newly staged and integrated; authored colors `#16834a`, `#49ff74`, `#edfff0` are all outside Lost Warden 64. Record for a later projectile pass, do not undo current changes. |
| Interceptor / carrier hostile shot: `interceptor_shot.tscn`, `mother_ship_shot.tscn` | `R/combat/interceptor_laser.png`, static 5 × 5 | No synchronized native master established. Prepared `S/combat/enemy_shot_interceptor.ase` and its newer sheet are separate assets. | Three of three RGB colors outside palette. Legacy PNG still active. |
| Turret hostile shot: `turret_shot.tscn` | `R/combat/turret_shot.png`, static 4 × 4 | No synchronized native master established. Prepared `S/combat/enemy_shot_turret.ase` is not this runtime texture. | Two of two RGB colors outside palette. Legacy PNG still active. |
| Shared world background: `scenes/world/background.tscn`, referenced by world and main loader | `R/world/background_native.png` and `background_2_native.png`, 600 × 450 static images, three repeated planes | Documented derivation from original `background.png` / `background_2.png` at 0.375 scale. `S/world/space_background_parallax.ase` is a separate 1600 × 1200, one-frame, nine-layer alternative. | Six/six and five/five visible RGB colors outside current palette. Active exports are sparse stars; layered environments remain unintegrated. |
| Title stars: `scenes/main/star_field.gd` | `R/world/light.png`, 16 × 16 static texture with particle scaling/modulation | Native source not established; procedural particle behavior is in script | One RGB color outside palette. Title star overlay remains separate from the shared world background. |
| Player glow primitive: `player.tscn` | `assets/ui/reactor_pixel.png`, static 8 × 8 | Native source not established; used by procedural effects | One RGB color outside palette. Technical glow primitive; record separately from authored hull art. |
| Foreground speed streaks / combat and elite overlays | `foreground_speed_particles.tscn/.gd`, `combat_feedback.gd`, `elite_indicator.gd`, projectile glow code | Procedural effects; no sprite atlas or Aseprite source/tag requirement | Active supporting visuals. Preserve behavior; assess their combined brightness with the new background later. |

Future enemy roles, boss art, alternate backgrounds and the rest of `animation_rework` remain available libraries, not automatic replacement candidates. File presence does not imply scene integration.

## Enemy visual target for phase 2

### Concrete references

- Preserve ordinary fighter/drone/interceptor/turret silhouettes and the material treatment in [Armored Depth comparison](../../../../assets/art/sprite_references/armored_depth_comparison.png).
- Use [the prepared Grave Carrier](../../../../assets/sprites/enemies/grave_carrier_32x64_sheet.png) and `S/enemies/grave_carrier_32x64.ase` as material/shape references. Use the intended 32 × 64 native hull. The maintainer's scale feedback supersedes the initial proposal to compress it into 16 × 32.
- Use the [runtime baseline board](../../../../assets/art/sprite_references/sprite_hits_background/baseline.png) to compare timing, obscured carrier feedback and current elite appearance.

### Shared treatment

1. Keep Lost Warden 64 material ramps: dark hull panels, restrained steel edges, existing faction/team accents. Impacts use a brief ivory/light-steel accent; avoid bleaching the entire hull so strongly that identity disappears.
2. Retain the 120 ms total feedback budget initially. The first visible frame must acknowledge positive damage; the final state must restore the correct idle/variant/tint. Tune authored hit pixels and shader strength together, using existing mechanisms.
3. Keep independent per-instance feedback. A hit to a mounted turret flashes that turret. A hull hit must become legible through the visible hull region without implying that untouched turrets received damage. Do not broaden health propagation or flash every child indiscriminately.
4. Carrier contract, revised after maintainer scale feedback: use the intended 32 × 64 hull at scale one, with a centered origin. Current 12 × 28 collision, shot marker `(0, 12)` and turret mounts `(−8.5, 1)` / `(8.5, 1)` are baseline measurements, not target geometry. During phase 2, align hull and turret collision shapes, mounting points and shot origins to the authored assembly. Use the carrier's dedicated turret components rather than overlaying two 32 × 32 standalone ships; retain independent targetability and visibly exposed hull impact accents. Damage, attack cadence and movement remain unchanged.
5. Beam-style positive damage remains visible without positional recoil or forced attack-state interruption. Repeated damage refreshes feedback; lethal damage prioritizes destruction and never returns to idle.
6. Preserve authored asteroid alternatives and their current size distinction. Rock impacts share timing and light color but retain darker surface detail rather than becoming featureless disks.
7. Keep the current elite tint/indicator mechanism in scope. Do not silently integrate new elite sheets, remove halos or change elite mechanics. Check that the revised flash still communicates the elite silhouette.

## Background production contract for phase 3

Direction proposed from the approved plan's assumption: **dark industrial space, quiet center, sparse peripheral debris and layered depth**. The maintainer has not separately selected a final color variant. This is the sole remaining artistic preference, not a technical blocker for this inventory phase.

Concrete references: [existing three-way background comparison](../../../../assets/art/sprite_references/background_variants/comparison.png) for depth and peripheral placement; prefer the restrained dark/cold treatment as a starting point. The dense colored edge banks are reference material, not approved runtime density. Do not paste or uniformly downscale a complete 1600 × 1200/1920 × 1080 composition.

| Contract | Target |
| --- | --- |
| Native source | `assets/sources/world/gameplay_background.aseprite`, 640 × 450, one frame, three named editable layers: Far, Mid, Near. |
| Exports | `assets/sprites/world/gameplay_background/far.png`, `mid.png`, `near.png`; all 640 × 450, full canvas, transparent, no trimming. |
| Existing nodes | Keep b3/b2/b1 and assign Far/Mid/Near respectively; sprite scale one and nearest filtering. |
| Repeat | 640 × 450 per layer. Validate both axes where mirrored and under camera offsets; matching border pixels alone does not pass. |
| Palette | Lost Warden 64 RGB. Binary alpha for discrete stars/debris; controlled partial alpha for distant haze. Review normal-alpha composition over Void `#06070c`. |
| Far plane | Sparse one/two-pixel stars; no bright projectile-shaped clusters or repeated vertical star columns. |
| Mid plane | Very subdued blue-gray matter and occasional distant structure; no full-screen cloud wall. |
| Near plane | Sparse wreck fragments, predominantly peripheral, with the same pixel/material language as hulls; never collision-like foreground obstacles. |
| Protected space | Current HUD rails x = 0–103 and 536–639; active central band x = 104–535. Decorative matter may sit behind rails but must not compete with text or the central shot lanes. No HUD geometry change. |
| Brightness review | Background must remain subordinate to shots and 120 ms hit peaks at actual 640 × 400 scale. Reject comparable bright cores, busy silhouettes behind enemies or isolated decorations readable as pickups. Palette membership alone is insufficient. |
| Motion | Preserve b3/b2/b1 ratios 0.5/0.8/1.1 and `background.gd` response 30–50 around 40. World instance explicitly overrides starting speed to 40; base/loader scene starts at 0. |
| Loop verification | At least three far-plane cycles at maximum existing speed: 54 seconds for a 450-pixel period at 25 px/s. Include normal movement, co-op averaging, pause/resume, restart and current camera shake. |
| Integration boundary | Preserve separate title particles and foreground streak behavior. No theme randomizer, nine-layer runtime system, new scrolling mechanic or gameplay RNG dependency. |

## Follow-up boundaries and acceptance

- Phase 2 owns carrier adaptation, source/export repair for affected enemies, and impact readability. No phase-2 implementation occurred here.
- Phase 3 owns native background production and integration. No new runtime background exists yet.
- Nomad source provenance, hostile projectile palette/replacement, HUD energy stacking and procedural color exceptions are recorded follow-ups. They do not authorize changes to those systems.
- All phase-1 criteria are met: the active families and dynamic references are inventoried; rendered hit cases distinguish working dispatch from weak assembled-carrier feedback; concrete art references, dimensions, palette and background assumptions are documented.
- This phase does not approve the final look or certify dense solo/co-op combat. Those reviews remain in the owning implementation phases.

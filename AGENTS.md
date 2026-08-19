# Agent guide — The-lost-jedi

Godot **4.7** shmup. Follow this file for layout, naming, and runtime rules. Keep changes small (KISS, DRY, YAGNI).

Reply to the maintainer in **French**. All repo docs, new comments, and `class_name` docs are **English**.

## Layout

Do **not** bring back `src/`, `Scripts/`, `Scenes/`, `Prefabs/`, `Fonts/`, `Sounds/`, or a Unity-style split.

| Path | Role |
|------|------|
| `scenes/<domain>/` | Scene + script together (`player.tscn` + `player.gd`) |
| `data/<domain>/` | `.tres` resources + their scripts |
| `core/` | Autoloads with no scene (`global`, `Events`, `save_service`) |
| `assets/` | Media, grouped like scenes (`sprites/player`, `audio/sfx/…`) |

Main scene: `res://scenes/main/main.tscn`.  
Committed autoloads: `global` → `core/global.gd`, `Events` → `core/events.gd`.

## Naming

- Files and folders: `snake_case` (`player_shot.tscn`, `hi_score.gd`)
- Scene **nodes**: `PascalCase` (`Player`, `WaveSpawner`) — do not rename existing nodes to snake_case
- `class_name`: `PascalCase` (`Player`, `Enemy`, `Shot`)
- Do not mass-rename GDScript identifiers (`id_Player`, `goto_Next_Wave`) unless asked

## Architecture

- HUD and combat talk through `Events` (`score_changed`, `wave_changed`, `energy_changed`, `player_died`, `game_over_requested`, `powerup_collected`). Do not recouple HUD to player nodes.
- Waves: edit `data/waves/*.tres` / `wave_catalog.tres`; runtime is `scenes/waves/wave_spawner.gd`.
- Weapons and upgrades are resources (`WeaponDefinition`, `UpgradeDefinition`, `PlayerLoadout`). Prefer data over hardcoded stats.
- Player logic stays split: `player.gd`, `player_weapons.gd`, `player_vitals.gd`, `player_loadout.gd`.
- Shots go through `ProjectilePool` (`scenes/combat/projectile_pool.gd`).
- Collision layers are named in `project.godot` (`player`, `enemy`, `player_shot`, `enemy_shot`, `pickup`, `asteroid`).
- Keep `global.Debug` and F1–F6 debug actions.

`global.gd` preloads save with `const _Save := preload("res://core/save_service.gd")` — do not put `class_name` on that autoload helper if parse order breaks.

## Physics and pooling

Godot forbids removing or freeing a `CollisionObject2D` during a physics callback (`area_entered`, etc.).

- Pool shots with deferred reparent (`call_deferred` / `_park`). Never `remove_child` / `queue_free` an `Area2D` inside `area_entered`.
- Ignore a second `despawn` while a shot is already pooled (`pooled` meta). `screen_exited` must not recycle a hidden parked shot.
- On enemy explode / player death: `set_deferred("disabled", true)` on the shape (and monitoring), not `queue_free()` on the collider during the flush.
- After a pooled shot is back in the tree, play animations with `play()`, not `set_autoplay()`.

## Resources and editor

Godot may rewrite `.tres` and drop export values equal to script defaults. If that happens, restore the explicit values from git — do not commit stripped data by accident.

Dynamic asset paths (keep filenames in sync):

- `scenes/player/player.gd`: `res://assets/sprites/player/` + `id_Player` + `_particle.png`
- `scenes/ui/hud.gd`: `res://scenes/player/` + `player_id` + `_energy.tscn`

Leave `default_bus_layout.tres` at the repo root.

## Code style

- Comment in English, and only on **new** functions or classes. Do not delete existing comments unless asked.
- Do not add per-file license headers. `LICENSE.txt` at the repo root is enough.
- Prefer a few clear lines over clever abstractions.
- Do not add features that were not requested.

## Git

Commits follow [Conventional Commits](https://www.conventionalcommits.org/), in **English**:

```
<type>(optional-scope): <imperative summary>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`.

- One concern per commit (do not mix a player fix with a docs rewrite)
- Subject: English, imperative, lowercase after the colon, no trailing period
- Body: explain why when it is not obvious, still English
- License is MIT ([LICENSE.txt](LICENSE.txt)). Do not relicense. Keep the copyright year range current when doing substantial work
- The Godot AI MCP addon is part of the repo (`addons/godot_ai/`, autoload `_mcp_game_helper`, editor plugin in `project.godot`)
- Do not squash or merge this work to `master` until the maintainer says so
- Do not commit unless asked. Never force-push `master`

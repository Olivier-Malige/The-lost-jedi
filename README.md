# The-lost-jedi

Shmup 8-bit (sprites 8×8, palette Pico-8) né à la jam OFFGame 2017. Prototype Phaser abandonné, repris sous Godot. Survivre des vagues d’ennemis, empiler les power-ups, maximiser le score.

**Moteur :** Godot **4.7** (GL Compatibility)  
**Scène principale :** `res://scenes/main/main.tscn`  
**Source :** https://github.com/Arknoid/The-lost-jedi

## Lancer le projet

1. Installer [Godot 4.7](https://godotengine.org/download).
2. Importer le dossier du dépôt (ou ouvrir `project.godot`).
3. F5 — la scène principale se lance toute seule.

## Structure

```
scenes/main/      entrée, loader, star field, lumières
scenes/world/     monde de jeu, fond
scenes/menu/      menu, start, game over, hi-score
scenes/player/    vaisseau, bouclier, beam
scenes/enemies/   TIE, interceptor, turret, mother ship, astéroïdes
scenes/combat/    tirs ennemis, pool de projectiles
scenes/ui/        HUD, pause, power-ups
scenes/waves/     spawner de vagues
data/player/      stats joueur
data/weapons/     définitions d’armes (.tres)
data/upgrades/    définitions de power-ups
data/waves/       catalogue + définitions de vagues
core/             autoloads et sauvegarde
assets/           sprites, audio, fonts, ui, art, sources
```

Scripts colocalisés avec les scènes. Resources (`class_name` + `.tres`) à côté de leurs scripts dans `data/`.

## Architecture

**Autoloads** (dans `project.godot`) :

| Nom | Script |
|-----|--------|
| `global` | `core/global.gd` — score, vague, config, sauvegarde |
| `Events` | `core/events.gd` — bus d’événements |

Sauvegarde JSON via `core/save_service.gd` (`user://data.json`).

**EventBus** (`Events`) :

- `score_changed(score)`
- `wave_changed(wave)`
- `energy_changed(player_id, energy)`
- `player_died`
- `game_over_requested`
- `powerup_collected(upgrade)`

**Vagues data-driven :** `data/waves/wave_catalog.tres` (liste de `WaveDefinition` + `SpawnRule`). Runtime : `scenes/waves/wave_spawner.gd`.

**Armes / upgrades :** `WeaponDefinition`, `UpgradeDefinition`, `UpgradeTable` dans `data/`. Loadout runtime : `PlayerLoadout`.

**Joueur :** `player.gd` + `player_weapons.gd` + `player_vitals.gd` + `player_loadout.gd`.

**Projectiles :** pool dans `scenes/combat/projectile_pool.gd`.

**Collisions** (`project.godot`) : `player`, `enemy`, `player_shot`, `enemy_shot`, `pickup`, `asteroid`.

**Debug :** `global.Debug` (défaut `false`). Si `true`, F1–F6 en jeu : vague précédente / suivante, speed, dégâts, tir latéral, bouclier.

## Conventions

- Fichiers et dossiers : `snake_case`
- Nœuds de scène et `class_name` : `PascalCase`
- Scripts à côté de la scène ; resources à côté du `.tres`

## Contrôles

Clavier (AZERTY / QWERTY / flèches) + Espace (ou pavé `+` / Insert).  
Manette : stick / D-pad + boutons face. Pause : Entrée, R, ou Start / L1.

En coop, P1 = manette 0, P2 = clavier (modifiable dans `global.saveData.config`).

## Licence

MIT — voir [LICENSE.txt](LICENSE.txt).

## Crédits

Jam OFFGame 2017 — Max, Dicard, Mike (O’clock). Suite Godot : Arknoid / Olivier Malige.

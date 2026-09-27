# Display Layout

## Target canvas

The logical combat canvas is 640 by 400 pixels. Wider windows preserve this fixed central composition and reveal additional parallax background on both sides.

The active combat rectangle is the centered 432 by 400 area. Player bounds include a small safety margin inside it, from `(112.5, 12)` to `(527.5, 392)`. Enemy spawn lanes are distributed between the HUD rails and start above the visible area.

Gameplay does not use a camera zoom. The larger logical canvas reveals more space for large encounters while the HUD remains pixel-stable on its own canvas layer.

| Region | Logical rectangle | Purpose |
|---|---:|---|
| Left rail | `0, 0, 104, 400` | Player one energy, score, and run information |
| Playfield | `104, 0, 432, 400` | Player movement, enemies, projectiles, and encounters |
| Right rail | `536, 0, 104, 400` | Player two energy, wave, danger, and boss status |

The rails are non-playable interface space. They must not look like obstacles and must not contain decorative computer frames or legacy franchise silhouettes.

On wide displays, the rail backgrounds extend to the window edges while their labels, gauges, and inner gold boundaries remain aligned with the fixed central combat canvas.

Gameplay and title screens retain their parallax origin on wide displays, so the repeated background remains outside the central composition.

## Scaling rules

- Use `viewport` stretching with aspect `expand`.
- Keep the 640 by 400 combat canvas centered while the parallax background fills extra horizontal space.
- Never extend player or enemy movement into the HUD rails.
- On wide displays, retain the fixed combat bounds and reveal only additional background beside the HUD rails.
- The Web export uses Godot's adaptive canvas resize policy.
- Browser fullscreen is only entered from the explicit menu action.

## Screen placement

Title, high-score, pause, game-over, and gameplay scenes use the same 640 by 400 logical composition. No camera zoom is used.

Backgrounds may render behind the rails, but gameplay sprites must remain inside the central square. HUD text must retain clear contrast against the background.

## Background motion

All retained parallax backgrounds use a base scroll speed of 60 logical pixels per second. The nearest layer uses a 1.1 motion scale for a subtle 66-pixel-per-second foreground drift, while the middle and far layers retain their original 48 and 30-pixel-per-second speeds. Star sprites render at 75% scale, with matching parallax tiling, and the background script applies velocity once per frame to avoid accumulated acceleration.

Background motion is visual feedback only. It stays independent from gameplay RNG, player speed, enemy movement, and encounter timing.

Do not raise this value as part of the Phase 1 pace increase without a separate visual-readability review.

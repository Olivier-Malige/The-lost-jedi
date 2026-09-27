# Sound Design — Suno Production and Interactive Music

## Status and scope

Planning approved: 2026-09-27. Production and implementation: not started.

The maintainer still needs a Suno subscription for the planned production workflow. Prompt preparation and source analysis can proceed without it. Confirm access to Sounds and the required Studio editing/export tools before production; do not purchase a subscription on the maintainer's behalf.

This document is the dedicated Sound Design phase linked from the [gameplay roadmap](gameplay_rework_plan.md). Execute only the explicitly requested subphase and verify it before starting the next. This plan does not authorize unrelated gameplay phases, new enemies or bosses, meta-progression, publication, or a push.

## Approved creative direction

- Instrumental retro synthwave with a strong 8-bit arcade identity: warm synthesizers, pulsing bass, crisp electronic drums, chiptune arpeggios, synthesizer solos, and melodic electric guitar solos.
- `assets/audio/music/game.ogg` is the original melodic reference. The local `assets/audio/music/game.mp3` is the preferred Suno remix to develop, preserving its sonic direction. It is currently untracked and is not included in this documentation commit; production requires the maintainer's copy.
- Gameplay gets a 6–8 minute listening arrangement, then independently usable sections. A run is not constrained to the listening arrangement's length or fixed sequence.
- Loader, title, and high scores share a different, more atmospheric theme: spacious pads, sparse arpeggios, an airy melody, and restrained percussion. High scores sound brighter and relaxed.
- Game over reprises the gameplay theme melancholically and prepares a return to the atmospheric title theme.
- All themes share a compatible production palette. Prefer a common musical pulse with half-time arrangement for menus, rather than assuming that calmer music requires a slower tempo.
- Tempo, key, and the existing remix's structure have not yet been measured or auditioned by the agent. Do not invent those values or claim the source has been analyzed.

## Phase 1 — Source analysis and prompt catalog

1. Listen to and analyze both gameplay references. Record the original motif, actual tempo and any drift, key, chord changes, structure, existing solos, and passages worth preserving.
2. Derive the fixed working tempo from the remix. Use a common 4/4 production grid; fit the atmospheric theme harmonically to the planned transition into gameplay.
3. Create an English prompt catalog with a separate copy-ready prompt for each music section, transition, effect, and spoken announcement. Each entry records its reference, intent, instrumentation, duration or bar count, loop requirements, entry/exit requirements, and selection criteria. Fill measured musical values before generating assets.
4. Produce the first trial only after Suno access is available: loader → title → gameplay plus “Speed up!”. Validate the sound and editing workflow with the maintainer before producing the entire library.

Acceptance: source analysis and catalog are complete; the trial demonstrates the chosen musical identity and clean transitions. Subscription availability and artistic selection are explicit production dependencies, not reasons to modify unrelated game systems.

## Phase 2 — Music production and editing

| Asset | Required material |
| --- | --- |
| Loader | Short atmospheric introduction with an early exit |
| Title | Loopable development of the atmospheric theme |
| High scores | Bright, relaxed variation of that theme |
| Gameplay entry | One-bar bridge into the action theme |
| Gameplay | Main theme, development, synth solo, breathing section, guitar solo, intense reprise with synth/guitar dialogue |
| Game over | Immediate defeat punctuation, musical transition, melancholic loop |
| Return to title | Prepared bridge back to the atmospheric theme |

- Develop the remix from its audio reference and edit related sections in one musical project, rather than relying on unrelated generations to match.
- Build 8- or 16-bar gameplay sections with harmonically compatible exits every eight bars. Each solo leads into an accompaniment loop so it need not repeat continuously while the wave tier remains unchanged.
- Prepare screen transition exits at bar boundaries and a defeat transition usable from any action section. Check actual chord compatibility; matching BPM alone is insufficient.
- Keep WAV masters and available stems. Deliver Ogg Vorbis music and WAV short effects for the game, with snake_case filenames.
- Align first beats, fixed tempo, exact musical lengths, and loop boundaries. Preserve reverb tails through appropriate edits or transition assets, remove clicks and unwanted silence, and match perceived levels.
- Retain the complete 6–8 minute listening arrangement separately from game sections. Do not require the runtime to play it linearly.

Acceptance: the maintainer accepts both themes and solos; all intended joins and loops pass listening checks. Prompts are creative instructions, not guarantees of precise tempo, duration, stems, or seamless loops.

## Phase 3 — Sound effects and robotic announcements

Inventory actual audio triggers before replacement and map every active sound to its approved asset. Do not add mechanics merely to use new sounds.

| Family | Coverage |
| --- | --- |
| Interface | Navigation, confirmation, back, launch |
| Player | Main fire, damage, destruction, shield reflection |
| Beam | Start, looped sustain, stop; distinguish reinforced mode |
| Enemies | Existing families' fire, damage, and explosions |
| Asteroids | Impacts and small/large explosions |
| Pickups | Immediate collection cue and six announcements |

Use a hybrid arcade palette with clear 8-bit attacks and richer sci-fi texture. Keep frequent sounds short. Produce three variants of repeated impacts and explosions, avoiding long tails that obscure combat.

Exact announcements: “Speed up!”, “Damage up!”, “Fire rate up!”, “Side shot!”, “Shield up!”, and “Energy up!”. Use one consistent robotic arcade voice with light vocoder coloration, clear consonants, spoken delivery, no music, and no pronounced echo. Target approximately one second while prioritizing intelligibility.

Prompt baseline, replacing only the spoken phrase:

> Single robotic arcade announcer voice saying exactly "Speed up!" once. Retro-futuristic 8-bit sci-fi character, crisp consonants, light vocoder coloration, punchy delivery. Spoken, not sung. No music, no background sound, no echo. Very short, clean isolated voice.

Acceptance: every existing trigger has a mapping; repeated effects remain comfortable; each announcement says the exact words clearly. Validate Suno's spoken output on the trial before scaling production.

## Phase 4 — Persistent music and screen transitions

### Ownership and interfaces

- Add a `MusicDirector` component under the persistent main scene, with scene and script together under `scenes/audio/`. Remove autonomous music playback from loader, title, and world when the replacement is ready.
- Store section definitions, musical metadata, transition rules, and wave mappings as resources under `data/audio/`; keep media under `assets/audio/`.
- Use `AudioStreamInteractive` and `AudioStreamPlaybackInteractive` for clips and beat/bar-based transitions. Use premixed sections for this version; retain stems for editing. Runtime vertical mixing with `AudioStreamSynchronized` is deferred.
- The minimal component contract requests a music state, requests a wave tier, and reports actual entry into a section. Main owns screen changes; the music component does not manipulate player or HUD nodes. Reuse `Events` for existing lifecycle and wave notifications.
- Configure BPM, beat count, and bar metadata from the verified exports. Godot does not repair drift merely because BPM metadata is present.

### Transition behavior

| Situation | Required behavior |
| --- | --- |
| Loader completes or is skipped | One idempotent request; enter title at the next bar |
| Title → gameplay | Immediate selection feedback; play bridge; reveal/start gameplay at action section entry |
| Title ↔ high scores | Start visual transition immediately; change screen at the musical join |
| Defeat | Stop gameplay immediately, play defeat punctuation, begin the musical exit on the next beat |
| Game over → title | Return at the next compatible bar |
| Music disabled/unavailable | Complete screen transition without waiting for audio |

- Keep normal screen bridges short: one bar. Do not wait for a complete long phrase or solo when navigating screens.
- Follow actual audio playback for screen synchronization, accounting for output latency where available; do not use an independent timer that assumes music started. Verify clip-entry detection in the native engine and Web build.
- Unify loader completion and skip paths. Its current nine-second visual sequence becomes driven by the approved introduction length.
- Lock duplicate confirmation during a pending transition and release held gameplay inputs before starting the world. The destination screen must not free the music owner.
- During pause, continue music at reduced volume and restore it on resume. Restart clears pending transitions and announcement state. Scene reload must recreate a single music owner without stale callbacks.
- Handle Web audio activation after user interaction. Missing playback or blocked autoplay must never strand the player in a transition; resume from a coherent state after activation.

Acceptance: all navigation paths use one music owner and work with enabled, muted, and unavailable audio. No doubles, hanging transitions, or gameplay activity during launch anticipation.

## Phase 5 — Wave-driven arrangements

Use `Events.wave_changed` with an editable resource mapping:

| Waves | Target section |
| --- | --- |
| 1–3 | Main theme |
| 4–6 | Development |
| 7–9 | Synth solo |
| 10–12 | Breathing section with maintained pulse |
| 13–15 | Guitar solo |
| 16–18 | Intense reprise and synth/guitar dialogue |

- Request ordinary musical changes at eight-bar phrase exits. After a solo, advance to its accompaniment loop without restarting the solo for each wave in the same tier.
- If waves change repeatedly before an exit, retain only the latest requested target. Do not restart a section already active.
- Endless cycles reuse the mapping for the actual emitted wave number. Preserve existing wave duration and spawning behavior.
- Defeat and screen exits override pending wave transitions. Debug navigation must remain usable.

Acceptance: wave transitions preserve phrases, latest requests win, solos do not repeat unnecessarily, and infinite progression remains coherent without changing gameplay timing.

## Phase 6 — Effects integration and mixing

- Preserve `Music` and `Sounds` settings and root `default_bus_layout.tres`. Route a `Voice` child bus to `Sounds` so existing mute behavior includes announcements.
- Play collection effects immediately. Trigger an upgrade announcement only when the upgrade actually applies; capped pickups retain collection feedback without a false increase announcement.
- Centralize announcement playback so pickup removal does not cut voices. Use one voice at a time, at most three waiting announcements, grouped duplicates, and discard queued announcements older than two seconds. Clear the queue on gameplay exit.
- Respect solo and co-op behavior. Do not delay collection mechanics to serialize voices.
- Limit simultaneous identical effects, preserve important feedback, and validate beam start/sustain/stop cleanup. Retain deferred collision cleanup requirements when updating pickups.
- Mix effects and announcements to remain intelligible during solos without clipping or excessive repeated transients.

Acceptance: announcements remain intelligible under simultaneous collection, capped pickups do not lie, voices survive pickup deletion, and the beam never remains audible after stopping or leaving gameplay.

## Validation and deliverables

- Listen to every allowed join at several source positions, including defeat midway through each solo. Reject unwanted silence, clicks, tempo drift, and incompatible harmonies.
- Run music loops for ten minutes to assess continuity and fatigue.
- Exercise complete/skipped loader, solo/co-op launch, scores and return, game over and return, pause/resume/restart, mute/unmute, rapid debug wave changes, and the endless cycle.
- Test simultaneous pickups, capped upgrades, deleted pickup nodes, sustained beam cleanup, and busy combat.
- Verify desktop and Web, including blocked autoplay. Add meaningful automated checks for resource mappings, missing assets, transition priorities, and announcement queue policy; complete them with real listening tests.
- Deliver the English prompt catalog, source analysis, masters and edited exports, six voice announcements, Godot resources/components, and a validation report.
- Keep each implementation subphase playable. Preserve existing user edits and candidate assets. No unrelated renaming, new gameplay phases, commits, or publishing as an implicit part of production.

## Technical references

- [Suno Sounds: one-shots and loops](https://suno.com/release-notes/make-loops-and-samples-from-scratch-with-sounds)
- [Suno Studio introduction](https://help.suno.com/en/articles/7940161)
- [Godot AudioStreamInteractive](https://docs.godotengine.org/en/stable/classes/class_audiostreaminteractive.html)
- [Godot AudioStreamPlaybackInteractive](https://docs.godotengine.org/en/stable/classes/class_audiostreamplaybackinteractive.html)
- [Godot AudioStreamSynchronized](https://docs.godotengine.org/en/stable/classes/class_audiostreamsynchronized.html)

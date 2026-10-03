# Suno Prompt Catalog — Lost Warden

## How to use this catalog

For the gameplay extension, upload `assets/audio/music/game.mp3` as the audio reference and use Extend or the relevant section editor. Keep the source version untouched so generated alternatives can be compared against it. Ask for instrumental output unless a prompt explicitly requests spoken words.

Suno may not follow exact duration, loop, instrument, or spoken-word instructions. Generate alternatives, choose by listening, and verify tempo, cuts, and loops during the audio-preparation phase. Replace no source assets until a candidate is selected and exported.

## First trial

Generate these three items first and review them together:

1. Extend the gameplay remix using prompt G1 below.
2. Generate the atmospheric menu theme using prompt M1 below.
3. Generate only “Speed up!” using prompt V1 below.

This first pass checks the musical direction, whether the remix extension retains the source identity, and whether the robotic voice is intelligible.

## Music

### G1 — Extend the gameplay remix

**Use:** Upload `game.mp3` as the reference; extend from a musical point that lets the original theme resolve naturally. Request a longer instrumental arrangement, aiming for a 6–8 minute complete listening version.

```text
Extend this instrumental track while preserving its recognizable original melody, retro synthwave character, 8-bit arcade identity, sound palette, and established musical feel. Do not replace the main theme with a new melody. Develop it into a longer video-game action score with clear sections: a confident main-theme statement, a stronger rhythmic development, an expressive synthesizer solo, a short lower-density breathing section that keeps the pulse, a melodic electric-guitar solo, and an energetic final reprise where synth and guitar answer each other. Keep the transitions musical and the instrumental arrangement coherent with the reference. No vocals, no lyrics, no spoken words. Aim for a complete extended arrangement around six to eight minutes; prioritize a satisfying musical arc over exact duration. End with a clear, usable musical resolution.
```

### G2 — Add another synth solo

**Use:** Select a suitable instrumental passage in the song editor and replace or extend that passage.

```text
Keep the surrounding song, tempo, harmony, sound palette, and main theme consistent with the supplied track. Add a memorable instrumental synthesizer lead solo that develops the existing musical identity, with a clear beginning, a melodic build, and a phrase that resolves naturally back into the following section. Keep the retro synthwave and 8-bit arcade character. No vocals, no lyrics, no spoken words.
```

### G3 — Add another electric-guitar solo

```text
Keep the surrounding song, tempo, harmony, main theme, and production consistent with the supplied track. Add a melodic electric-guitar solo with expressive bends and a strong singable phrase, supported by retro synthesizers and driving electronic drums. Build intensity, then resolve cleanly into the following section. The guitar should complement the synth lead rather than change the song's identity. No vocals, no lyrics, no spoken words.
```

### M1 — Atmospheric menu theme

**Use:** Create a separate instrumental theme. This theme is for the loader and title screen.

```text
Instrumental retro-futuristic synthwave theme for a pixel-art 8-bit space arcade game. Atmospheric, spacious, slightly mysterious, warm and memorable. Use soft analog synthesizer pads, a few widely spaced chiptune arpeggios, a gentle pulsing bass, and a simple airy melodic motif. Keep the percussion restrained and sparse so the music feels calm and open rather than like combat music. Create a natural opening suitable for a game loading screen, develop the same motif into a title-screen theme, and leave a smooth musical ending or transition point. No vocals, no lyrics, no spoken words, no aggressive drums, no cinematic orchestra.
```

### M2 — High-score variation

```text
Create an instrumental variation of the supplied atmospheric retro synthwave menu theme for a pixel-art 8-bit space arcade game. Preserve its main melodic identity and sound palette, but make this version a little brighter, more relaxed, and quietly rewarding for a high-score screen. Use spacious analog pads, sparse chiptune arpeggios, a gentle bass pulse, and minimal percussion. Keep it calm and loop-friendly, with no dramatic build or combat intensity. No vocals, no lyrics, no spoken words.
```

### M3 — Game-over variation

```text
Create a melancholic instrumental game-over variation of the supplied retro synthwave action theme. Let a short, restrained arcade defeat impact lead into a spacious and reflective arrangement. Preserve a recognizable hint of the original melody, using softened analog synths, a subdued pulse, and a sparse 8-bit motif. Make the result somber but not horror-like, with a natural ending that can transition back to the atmospheric title theme. No vocals, no lyrics, no spoken words.
```

## Musical transition prompts

Use these with a reference clip or the relevant source sections. Each bridge should be short and resolve into the destination theme. Verify musical alignment after generation.

### T1 — Loader to title

```text
Create a short instrumental continuation from this atmospheric retro synthwave loading introduction into the supplied title-screen theme. Preserve the melody, harmony, tone, and spacious 8-bit arcade character. Gradually reveal the title motif, keep percussion restrained, and finish exactly as the title theme is ready to continue. No new section, no vocals, no spoken words.
```

### T2 — Title to gameplay

```text
Create a brief instrumental transition from this spacious atmospheric 8-bit synthwave title theme into the supplied energetic gameplay remix. Preserve compatible harmony and the recognizable game motif. Build anticipation with a rising synth pulse and a compact arcade drum fill, then resolve strongly into the gameplay theme. No vocals, no spoken words.
```

### T3 — Title to high scores and return

```text
Create a short, gentle instrumental bridge between these two related atmospheric retro synthwave menu themes. Preserve their shared motif and harmony, use sparse 8-bit arpeggios and soft pads, and make the ending connect naturally back to the destination theme. No percussion build, no vocals, no spoken words.
```

### T4 — Gameplay to game over

```text
Create a short instrumental transition from the supplied energetic retro synthwave gameplay music into its melancholic game-over variation. Begin with one compact electronic arcade defeat impact, then let the action energy fall away into the same recognizable motif in a reflective, spacious form. Keep the transition clear and emotionally restrained. No vocals, no spoken words.
```

### T5 — Game over to title

```text
Create a short instrumental bridge from this melancholic game-over variation back to the supplied atmospheric title-screen theme. Gradually brighten the shared melodic motif and resolve gently into the title arrangement. Keep the retro synthwave and 8-bit sound palette, with no sudden loud impact. No vocals, no spoken words.
```

## Sound effects

Use **One Shot** for individual effects. Keep prompts concise and ask for a clean isolated effect without music. Generate two alternatives and select the clearest one.

### S1 — Menu confirmation and launch

```text
One short, clean 8-bit sci-fi arcade menu confirmation sound: bright two-note digital synth chime with a compact low pulse, crisp attack, and very short tail. Isolated sound effect only, no music, no ambience, no voice. Under half a second.
```

### S2 — Menu navigation and back

```text
One short retro 8-bit space-arcade menu navigation sound: soft crisp digital tick with a tiny synth blip, distinct from a confirmation cue, no harsh high frequencies. Isolated effect only, no music, no ambience, no voice. Under half a second.
```

### S3 — Player laser shot

```text
One short, punchy retro sci-fi player laser shot for an 8-bit arcade shooter: bright electronic zap with a tight low-end body and a quick falling pitch. Clean transient, short tail, easy to hear repeatedly. Isolated sound effect only, no music, no ambience, no voice. Under half a second.
```

### S4 — Enemy laser shot

```text
One short enemy laser shot for a retro 8-bit sci-fi arcade game, darker and lower-pitched than the player's shot, with a sharp digital attack and compact descending zap. Distinct, readable, and repeatable. Isolated sound effect only, no music, no ambience, no voice. Under half a second.
```

### S5 — Player hit

```text
One brief player damage cue for a retro 8-bit space shooter: crisp electronic impact, small low thump, and a short unstable synth flicker. Urgent but not painfully loud. Isolated effect only, no music, no ambience, no voice. Under half a second.
```

### S6 — Standard enemy hit

```text
One brief sci-fi enemy armor impact for an 8-bit arcade shooter: tight metallic-electronic tick, compact crunchy burst, and very short digital tail. Readable under busy combat and suitable for repeated use. Isolated effect only, no music, no ambience, no voice. Under half a second.
```

### S7 — Enemy explosion

```text
One compact retro sci-fi arcade enemy explosion: sharp energy crack, warm low burst, a few falling 8-bit pixels of sound, and a short controlled tail. Punchy without excessive bass or long reverb. Isolated effect only, no music, no ambience, no voice. About one second.
```

### S8 — Large enemy explosion

```text
One larger boss-scale retro sci-fi explosion for a pixel-art arcade game: broad low impact, layered electronic crackle, bright energy breakup, and a controlled short decay. Clearly bigger than a standard enemy explosion while leaving room for gameplay audio. Isolated effect only, no music, no ambience, no voice. About one to two seconds.
```

### S9 — Asteroid impact and break

```text
One rocky asteroid impact and break for a retro space arcade shooter: gritty stone crack, compact low thud, and a few sharp debris fragments with subtle electronic color. Keep it brief and readable. Isolated effect only, no music, no ambience, no voice. About one second.
```

### S10 — Shield reflection

```text
One retro sci-fi energy shield deflection: a crisp bright metallic-electronic ping, short upward shimmer, and a tight reflected-energy snap. Distinct from a damage impact and clean at low volume. Isolated effect only, no music, no ambience, no voice. Under one second.
```

### S11 — Power-up collection cue

```text
One satisfying 8-bit arcade power-up collection sound: ascending three-note digital synth flourish, bright but soft attack, clean short finish. Keep it brief so a spoken announcement can follow clearly. Isolated effect only, no music, no ambience, no voice. Under one second.
```

### S12 — Continuous beam loop

**Use:** Select Loop; create a seamless repeating bed.

```text
Seamless short loop of a sustained retro sci-fi energy beam for an 8-bit arcade shooter: steady soft electrical buzz, subtle pulsing synth harmonics, restrained high-frequency shimmer, no attack or ending, consistent loudness. Instrumental sound effect only, no speech, no background music. Designed to repeat without a click.
```

### S13 — Beam start and stop

```text
One short retro sci-fi energy-beam activation and shutdown accent: quick rising electronic charge into a focused laser onset, then a clean falling power-down tail. This is a one-shot transition, not a sustained loop. Isolated sound effect only, no music, no ambience, no voice. About one second.
```

### S14 — Upgrade notification accent

```text
One short, positive 8-bit sci-fi upgrade confirmation blip: a clear rising digital synth interval with a compact warm pulse, designed to sit quietly under a robotic spoken announcement. Isolated sound effect only, no music, no ambience, no voice. Under half a second.
```

## Robotic upgrade announcements

Use one consistent light vocoder character across all six lines. Select spoken output; if Suno sings the phrase, regenerate or use a clean recording/editing workflow. Leave a small gap after the pickup cue so the words stay intelligible.

### V1 — “Speed up!” — first trial

```text
Single robotic arcade announcer voice saying exactly: “Speed up!” Say the words once, clearly and energetically. Retro-futuristic 8-bit sci-fi voice, light vocoder coloration, crisp consonants, short punchy delivery. Spoken, not sung. No extra words, no music, no background sound, no echo. Clean isolated voice, about one second.
```

### V2 — “Damage up!”

```text
Single robotic arcade announcer voice saying exactly: “Damage up!” Match the same speaker, pitch, accent, and light vocoder character as the supplied “Speed up!” voice. Clear consonants, short confident spoken delivery. Spoken, not sung. No extra words, no music, no background sound, no echo. Clean isolated voice, about one second.
```

### V3 — “Fire rate up!”

```text
Single robotic arcade announcer voice saying exactly: “Fire rate up!” Match the same speaker, pitch, accent, and light vocoder character as the supplied power-up announcement. Keep every word intelligible and the delivery concise. Spoken, not sung. No extra words, no music, no background sound, no echo. Clean isolated voice, about one second.
```

### V4 — “Side shot!”

```text
Single robotic arcade announcer voice saying exactly: “Side shot!” Match the same speaker, pitch, accent, and light vocoder character as the supplied power-up announcement. Clear, upbeat, concise spoken delivery. Spoken, not sung. No extra words, no music, no background sound, no echo. Clean isolated voice, about one second.
```

### V5 — “Shield up!”

```text
Single robotic arcade announcer voice saying exactly: “Shield up!” Match the same speaker, pitch, accent, and light vocoder character as the supplied power-up announcement. Clear, protective, confident spoken delivery. Spoken, not sung. No extra words, no music, no background sound, no echo. Clean isolated voice, about one second.
```

### V6 — “Energy up!”

```text
Single robotic arcade announcer voice saying exactly: “Energy up!” Match the same speaker, pitch, accent, and light vocoder character as the supplied power-up announcement. Clear, upbeat, concise spoken delivery. Spoken, not sung. No extra words, no music, no background sound, no echo. Clean isolated voice, about one second.
```

## Selection notes

- First compare several G1 continuations against the source remix. Keep the recognizable melody and preferred style above exact length.
- Select M1 independently; it is intentionally calmer than the action track while retaining the same retro-futuristic world.
- Check voice intelligibility on small speakers and during gameplay music before generating all six variants.
- Keep approved candidates in Suno until the maintainer chooses exports. Record chosen titles and export filenames before integrating them into the game.

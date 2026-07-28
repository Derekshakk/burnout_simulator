---
name: add-scenario
description: Add a new GameScenario to the burnout simulator. Use when the user asks to create a new scene, situation, or decision point for the game.
---

You are adding a new scenario to `lib/data/demo_scenarios.dart`. Follow this exact pattern.

## Step 1 — Read the existing data file

Read `lib/data/demo_scenarios.dart` in full before writing anything. Understand the current scenario count and the last `timeLabel` so the new scenario fits the day's timeline.

Also read `lib/models/game_choice.dart` and `lib/models/game_scenario.dart` to confirm the current field signatures.

## Step 2 — Design the scenario

Confirm with the user (or infer from $ARGUMENTS):
- **Title** — short name (e.g., "Lunch Break", "After-School Meeting")
- **Time label** — 12-hour clock string (e.g., "12:30 PM")
- **Scene tone** — one of: `'morning'`, `'class'`, `'evening'` (controls the pixel art scene shown in the simulation)
- **Situation** — 2–3 sentence description of what Alex is facing
- **Narration** — Alex's inner voice, in quotes, 1–2 sentences
- **Choices** — exactly 2 or 3 choices, each with:
  - `label` — short action phrase (the button text)
  - `description` — 1 sentence expanding on what Alex does
  - Stat deltas (use realistic values; see existing choices for scale — typical deltas are ±5 to ±25)
  - `taskCompleted` — optional short string if the choice completes something
  - `educationalFeedback` — 2–4 sentences, nonjudgmental, explaining what happened and why

## Step 3 — Validate educational language

Before writing, check every `educationalFeedback` string:
- No "good choice" / "bad choice" language
- Rest is framed as necessary, not lazy
- Include at least one of: "Different people...", "This reflects...", "This is not a personal failing.", or similar hedging language
- Reference the specific mechanic affected (energy, stress, self-advocacy, etc.)

## Step 4 — Write the scenario

Add the new `GameScenario(...)` to the `demoScenarios` list in `lib/data/demo_scenarios.dart`. Place it in chronological order by time.

**Do not** add a `burnoutDelta` field — burnout is derived from the meter values automatically.

All string fields use single quotes. The list uses `const`.

## Step 5 — Run checks

```bash
dart format lib/data/demo_scenarios.dart
flutter analyze
flutter test
```

Fix any issues before reporting done.

## Step 6 — Report

Tell the user:
- The new scenario title and position in the sequence
- A brief summary of each choice and its primary stat effect
- The updated total scenario count

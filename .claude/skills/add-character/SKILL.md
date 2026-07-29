---
name: add-character
description: Add a new CharacterProfile to the burnout simulator. Use when the user wants to create an ADHD, autism, AuDHD, or other neurodivergent character variant beyond the current demo character (Alex).
---

You are adding a new character to `lib/data/`. Follow this pattern.

## Step 1 — Read existing character files

Read `lib/data/demo_character.dart` and `lib/models/character_profile.dart` in full. Understand every field of `CharacterProfile` before writing anything.

## Step 2 — Gather character details

Confirm with the user (or infer from $ARGUMENTS):
- **Name** — fictional first name only
- **Age** — a plausible school-age integer
- **Context** — use the exact format `"High school student"` for high school characters. Do **not** use year labels (freshman, sophomore, junior, senior). Only use a different value if the character is genuinely outside high school (e.g., "Middle school student", "College student").
- **Gender and pronouns** — provide both values for the shared `CharacterProfile` identity fields. These are displayed dynamically on the character-selection card, so use the character's stated identity and do not rely on accent color alone.
- **Short description** — 1–2 sentences on their specific profile (attention regulation, sensory sensitivities, executive function patterns, etc.)
- **Strengths** — 3–5 items, positive framing
- **Supportive strategies** — 3–5 strategies that work for this character specifically
- **Low-energy activity** — a restorative, lower-demand favourite
- **High-energy activity** — a higher-demand favourite that may become unavailable at high burnout
- **Neurodivergent framing** — which experience is this character primarily representing? (ADHD, autism, AuDHD, other)

## Step 3 — Write the disclaimer

Every character **must** include a `disclaimer` field stating:
- The character is fictional and educational
- They do not represent all people with [condition]
- Experiences vary widely

Model it on the existing disclaimer in `demo_character.dart`.

## Step 4 — Create the file

Create `lib/data/<snake_case_name>_character.dart` (e.g., `lib/data/maya_character.dart`).

Export a `const` instance named after the character:
```dart
const <name>Character = CharacterProfile(
  name: '...',
  gender: '...',
  pronouns: '...',
  // all fields
);
```

## Step 5 — Wire it up (if requested)

If the user wants to make this character selectable in the app:
- Note that character selection UI does not exist yet in Phase 1
- Propose adding a character picker screen as a separate task
- Do not silently create screens or routing changes for character selection

## Step 6 — Run checks

```bash
dart format lib/data/<file>.dart
flutter analyze
flutter test
```

## Step 7 — Report

Tell the user:
- The file created and the character name
- A one-line summary of the character's profile
- Whether character selection UI needs a separate implementation step

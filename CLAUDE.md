# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Educational Flutter web simulation about neurodivergent (ADHD/autism) burnout. Prototype for SNP-REACH 2026. Primary target is **Flutter web**; secondary targets are mobile and desktop.

## Commands

```bash
flutter run -d chrome          # preferred dev workflow (web)
flutter build web              # production build
dart format .                  # format all Dart (not flutter format)
flutter analyze                # static analysis
flutter test                   # run tests
```

## Architecture

**State**: One `GameState extends ChangeNotifier` is created in `BurnoutSimulatorApp` (`lib/app/app.dart`) and passed to every screen via constructor. Never create a new `GameState` instance elsewhere; never add Riverpod, Bloc, or Provider — the lightweight ChangeNotifier approach is intentional for this phase.

**Routing**: Manual `onGenerateRoute` in `MaterialApp`. Route constants are in `lib/app/routes.dart`. Navigate with `Navigator.pushNamed` / `pushReplacementNamed`.

**Folder conventions**:
- `lib/models/` — data classes and GameState
- `lib/data/` — all hardcoded content: scenarios, characters, educational feedback strings. Keep educational text here, not in widgets or screens.
- `lib/widgets/` — reusable widgets (pixel_panel, status_meter, choice_button, etc.)
- `lib/screens/` — one file per route
- `lib/app/` — app root, routes, theme

## Key gotchas

**Burnout is derived, never set directly.** `burnoutLevel` is a computed getter on `GameState` combining energy (35%), stress (35%), motivation (20%), and selfAdvocacy (10%). Do not add a `burnoutDelta` field to `GameChoice` — adjust the underlying meters instead.

**ChangeNotifier listener pattern.** Register in `initState`, unregister in `dispose`:
```dart
@override
void initState() {
  super.initState();
  widget.gameState.addListener(_onStateChanged);
}
@override
void dispose() {
  widget.gameState.removeListener(_onStateChanged);
  super.dispose();
}
```

**All meter values are clamped 0–100** via `.clamp(0, 100)` in `GameState.applyChoice`. Do not rely on raw delta arithmetic in tests.

**No persistence layer yet.** `GameState` resets every session. `SharedPreferences` or similar has not been added.

**Scenarios are hardcoded** in `lib/data/demo_scenarios.dart` as a `const List<GameScenario>`. See `/add-scenario` skill for the correct way to extend them.

**Character names in shared UI are dynamic.** All shared UI and scenario text must reference the active character dynamically. Never hard-code Alex, Jordan, or another character name outside character-specific data files.

**Character subtitle format.** The `context` field of `CharacterProfile` must follow the format `'[age] · High school student'` — do not use year labels like freshman, sophomore, junior, or senior. This ensures consistent card presentation across all characters. Only deviate if a future character is genuinely outside high school (e.g., college, middle school).

**Character identity fields.** Every `CharacterProfile` must include a visible `gender` and `pronouns` value. The character-selection card renders these dynamically, so do not hard-code identity labels or character names in shared UI.

## Educational language rules

Use supportive, nonjudgmental wording in all user-facing text. Avoid "good choice" / "bad choice". Prefer: "This choice reduced immediate demands." Frame rest as necessary, not as failure. State that experiences vary. See existing `educationalFeedback` strings in `demo_scenarios.dart` for reference tone.

## Theme

Dark theme only (`lib/app/theme.dart`). Color constants are in `AppColors`. Do not use raw `Color(0x...)` literals in new widgets — use `AppColors.*` names.

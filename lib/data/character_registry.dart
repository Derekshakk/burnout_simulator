import '../models/character_profile.dart';
import '../models/game_scenario.dart';
import 'alex_scenarios.dart';
import 'demo_character.dart';
import 'jordan_character.dart';
import 'jordan_scenarios.dart';
import 'maya_character.dart';
import 'maya_scenarios.dart';
import 'shared_scenarios.dart';

/// The complete set of playable characters.
///
/// Keeping the profile and its scenarios together makes selection and test
/// coverage data-driven: adding a character here automatically adds it to
/// every registry-based lifecycle test.
///
/// Each character's scenario list is assembled from character-specific const
/// scenarios and shared runtime scenarios. Shared scenarios receive the
/// character profile at build time so they can vary text and delta values
/// by character without duplicating the choice structure.
class RegisteredCharacter {
  final CharacterProfile profile;
  final List<GameScenario> scenarios;

  const RegisteredCharacter({required this.profile, required this.scenarios});
}

// Alex: 4 character-specific + 1 shared (Study Breaks / Socialising)
// Slot 4 (11:30 AM) — buildLunchBreakScenario replaces the former
// character-specific lunch_recovery scenario.
List<GameScenario> _buildAlexScenarios() => [
  alexScenarios[0], // S1 morning_planning         8:00 AM
  alexScenarios[1], // S2 sensory_hallway           9:30 AM
  alexScenarios[2], // S3 class_restlessness       10:00 AM
  buildLunchBreakScenario(demoCharacter), //  S4   11:30 AM (shared)
  alexScenarios[3], // S5 end_of_day                2:00 PM
];

// Jordan: 4 character-specific + 1 shared (Academic Accommodations)
// Slot 5 (2:00 PM) — buildAccommodationsScenario replaces the former
// character-specific evening_decompression scenario.
List<GameScenario> _buildJordanScenarios() => [
  jordanScenarios[0], // S1 routine_disruption         8:30 AM
  jordanScenarios[1], // S2 group_work_ambiguous        9:00 AM
  jordanScenarios[2], // S3 lunch_conversation         11:30 AM
  jordanScenarios[3], // S4 classroom_sensory_overload  1:00 PM
  buildAccommodationsScenario(jordanCharacter), // S5 2:00 PM (shared)
];

// Maya: 3 character-specific + 2 shared (Study Breaks + Accommodations)
// Slot 3 (11:00 AM) — buildLunchBreakScenario replaces maya_lunch_reset.
// Slot 5 (2:30 PM) — buildAccommodationsScenario replaces maya_evening.
List<GameScenario> _buildMayaScenarios() => [
  mayaScenarios[0], // S1 maya_schedule_change  8:30 AM
  mayaScenarios[1], // S2 maya_online_class      9:00 AM
  buildLunchBreakScenario(mayaCharacter), // S3   11:00 AM (shared)
  mayaScenarios[2], // S4 maya_critique           1:00 PM
  buildAccommodationsScenario(mayaCharacter), //  S5 2:30 PM (shared)
];

final registeredCharacters = <RegisteredCharacter>[
  RegisteredCharacter(profile: demoCharacter, scenarios: _buildAlexScenarios()),
  RegisteredCharacter(
    profile: jordanCharacter,
    scenarios: _buildJordanScenarios(),
  ),
  RegisteredCharacter(profile: mayaCharacter, scenarios: _buildMayaScenarios()),
];

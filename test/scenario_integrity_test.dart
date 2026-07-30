import 'package:burnout_simulator/data/character_registry.dart';
import 'package:burnout_simulator/models/game_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final registration in registeredCharacters) {
    test(
      '${registration.profile.name} scenarios keep time moving forward on every playable path',
      () => _expectNoBackwardTime(registration),
    );

    test(
      '${registration.profile.name} starts at the first scheduled scenario',
      () {
        final gameState = GameState();
        gameState.selectCharacter(registration.profile, registration.scenarios);

        expect(
          _minutesFromTimeLabel(gameState.currentTimeLabel),
          _minutesFromTimeLabel(registration.scenarios.first.timeLabel),
        );
      },
    );

    test(
      '${registration.profile.name} carryover notes reference earlier tags',
      () {
        final earlierTags = <String>{};
        for (final scenario in registration.scenarios) {
          for (final tag in scenario.carryoverNotes?.keys ?? const <String>[]) {
            expect(
              earlierTags,
              contains(tag),
              reason:
                  '${scenario.id} has carryover for $tag, but no earlier choice can set it',
            );
          }
          earlierTags.addAll(
            scenario.choices.map((choice) => choice.tag).whereType<String>(),
          );
        }
      },
    );

    test(
      '${registration.profile.name} explicit time-to-next-class copy matches the schedule',
      () => _expectExplicitScheduleCopyToMatch(registration),
    );
  }
}

void _expectNoBackwardTime(RegisteredCharacter registration) {
  void visit(List<int> path) {
    final gameState = GameState();
    gameState.selectCharacter(registration.profile, registration.scenarios);

    for (final choiceIndex in path) {
      final scenario =
          gameState.activeScenarios[gameState.currentScenarioIndex];
      final choice = scenario.choices[choiceIndex];
      if (!gameState.isChoiceAvailable(choice)) return;

      gameState.applyChoice(choice);
      final timeBeforeTransition = gameState.timeMinutes;
      gameState.advanceScenario();
      expect(
        gameState.timeMinutes,
        greaterThanOrEqualTo(timeBeforeTransition),
        reason:
            '${registration.profile.name} moved backward after ${scenario.id}/${choice.id}',
      );
    }

    if (gameState.hasCompletedGame) {
      expect(gameState.currentTimeLabel, '03:00 PM');
      return;
    }

    final scenario = gameState.activeScenarios[gameState.currentScenarioIndex];
    for (var i = 0; i < scenario.choices.length; i++) {
      visit([...path, i]);
    }
  }

  visit(const []);
}

void _expectExplicitScheduleCopyToMatch(RegisteredCharacter registration) {
  final scenarios = registration.scenarios;
  final timeClaim = RegExp(
    r'(\d+) minutes before the next class',
    caseSensitive: false,
  );

  for (var index = 0; index < scenarios.length - 1; index++) {
    final scenario = scenarios[index];
    final match = timeClaim.firstMatch(scenario.description);
    if (match == null) continue;

    final claimedMinutes = int.parse(match.group(1)!);
    final scheduledMinutes =
        _minutesFromTimeLabel(scenarios[index + 1].timeLabel) -
        _minutesFromTimeLabel(scenario.timeLabel);
    expect(
      claimedMinutes,
      scheduledMinutes,
      reason:
          '${registration.profile.name}: ${scenario.id} says $claimedMinutes minutes until the next class, but the schedule shows $scheduledMinutes.',
    );
  }
}

int _minutesFromTimeLabel(String label) {
  final match = RegExp(r'^(\d{1,2}):(\d{2}) (AM|PM)$').firstMatch(label);
  if (match == null) throw ArgumentError.value(label, 'label');

  var hour = int.parse(match.group(1)!);
  if (hour == 12) hour = 0;
  if (match.group(3) == 'PM') hour += 12;
  return hour * 60 + int.parse(match.group(2)!);
}

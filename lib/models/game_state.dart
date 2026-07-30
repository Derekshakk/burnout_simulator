import 'package:flutter/foundation.dart';
import 'character_profile.dart';
import 'game_choice.dart';
import 'game_scenario.dart';

enum GameSessionStatus { unselected, playing, completed }

class GameState extends ChangeNotifier {
  CharacterProfile? _selectedCharacter;
  List<GameScenario> _activeScenarios = const [];

  int _timeMinutes = 480;
  double _energy = 80;
  double _focus = 70;
  double _stress = 20;
  double _motivation = 75;
  double _lifeSatisfaction = 70;
  double _selfAdvocacy = 50;
  final List<String> _completedTasks = [];
  final List<String> _selectedChoiceHistory = [];
  final Set<String> _appliedTags = {};
  bool _isFinished = false;
  GameSessionStatus _sessionStatus = GameSessionStatus.unselected;
  bool _reduceVisualEffects = false;
  int _currentScenarioIndex = 0;
  String? _pendingFeedback;
  String? _lastChoiceLabel;

  CharacterProfile? get selectedCharacter => _selectedCharacter;
  List<GameScenario> get activeScenarios => List.unmodifiable(_activeScenarios);
  int get timeMinutes => _timeMinutes;
  double get energy => _energy;
  double get focus => _focus;
  double get stress => _stress;
  double get motivation => _motivation;
  double get lifeSatisfaction => _lifeSatisfaction;
  double get selfAdvocacy => _selfAdvocacy;
  List<String> get completedTasks => List.unmodifiable(_completedTasks);
  List<String> get selectedChoiceHistory =>
      List.unmodifiable(_selectedChoiceHistory);
  Set<String> get appliedTags => Set.unmodifiable(_appliedTags);
  bool get isFinished => _isFinished;
  GameSessionStatus get sessionStatus => _sessionStatus;
  bool get isPlaying => _sessionStatus == GameSessionStatus.playing;
  bool get hasCompletedGame => _sessionStatus == GameSessionStatus.completed;
  bool get reduceVisualEffects => _reduceVisualEffects;
  int get currentScenarioIndex => _currentScenarioIndex;
  String? get pendingFeedback => _pendingFeedback;
  String? get lastChoiceLabel => _lastChoiceLabel;

  /// Resolves lifecycle-protected routes without changing session state.
  String routeFor(String requestedRoute) {
    switch (requestedRoute) {
      case '/play':
        if (_selectedCharacter == null || _activeScenarios.isEmpty) {
          return '/select';
        }
        return hasCompletedGame ? '/results' : '/play';
      case '/results':
        if (hasCompletedGame) return '/results';
        return isPlaying ? '/play' : '/select';
      default:
        return requestedRoute;
    }
  }

  double get burnoutLevel {
    double burnout = 0;
    burnout += (100 - _energy) * 0.35;
    burnout += _stress * 0.35;
    burnout += (100 - _motivation) * 0.20;
    burnout += (100 - _selfAdvocacy) * 0.10;
    return burnout.clamp(0, 100);
  }

  String get burnoutRange {
    final b = burnoutLevel;
    if (b < 40) return 'low';
    if (b < 70) return 'elevated';
    return 'high';
  }

  bool get hasSensoryOverload => burnoutLevel >= 80;
  bool get hasSevereOverload => burnoutLevel >= 90;

  String get currentTimeLabel {
    final hours = _timeMinutes ~/ 60;
    final minutes = _timeMinutes % 60;
    final amPm = hours >= 12 ? 'PM' : 'AM';
    final displayHour = hours > 12 ? hours - 12 : (hours == 0 ? 12 : hours);
    return '${displayHour.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $amPm';
  }

  bool get canDoHighEnergyActivity => burnoutLevel < 70 && _energy > 30;
  bool get canDoLowEnergyActivity => burnoutLevel < 85 && _energy > 10;

  bool isChoiceAvailable(GameChoice choice) {
    if (choice.minEnergyRequired != null &&
        _energy < choice.minEnergyRequired!) {
      return false;
    }
    if (choice.maxBurnoutAllowed != null &&
        burnoutLevel > choice.maxBurnoutAllowed!) {
      return false;
    }
    return true;
  }

  String? carryoverNote(GameScenario scenario) {
    if (scenario.carryoverNotes == null || _appliedTags.isEmpty) return null;
    // More than one earlier choice can be relevant. Keep the presentation to
    // one note, but let the most recent matching choice take precedence so an
    // older tag cannot hide the immediate carryover from the preceding scene.
    for (final tag in _appliedTags.toList().reversed) {
      final note = scenario.carryoverNotes![tag];
      if (note != null) return note;
    }
    return null;
  }

  void selectCharacter(
    CharacterProfile character,
    List<GameScenario> scenarios,
  ) {
    if (scenarios.isEmpty) {
      throw ArgumentError.value(scenarios, 'scenarios', 'Must not be empty');
    }
    _selectedCharacter = character;
    _activeScenarios = List.unmodifiable(scenarios);
    _resetProgress();
    _sessionStatus = GameSessionStatus.playing;
    notifyListeners();
  }

  void applyChoice(GameChoice choice) {
    if (!isPlaying || _pendingFeedback != null) return;
    final currentScenario = _activeScenarios[_currentScenarioIndex];
    if (!currentScenario.choices.contains(choice) ||
        !isChoiceAvailable(choice)) {
      return;
    }
    _energy = (_energy + choice.energyDelta).clamp(0, 100);
    _focus = (_focus + choice.focusDelta).clamp(0, 100);
    _stress = (_stress + choice.stressDelta).clamp(0, 100);
    _motivation = (_motivation + choice.motivationDelta).clamp(0, 100);
    _lifeSatisfaction = (_lifeSatisfaction + choice.lifeSatisfactionDelta)
        .clamp(0, 100);
    _selfAdvocacy = (_selfAdvocacy + choice.selfAdvocacyDelta).clamp(0, 100);
    _timeMinutes += choice.timeMinutesDelta;
    if (choice.taskCompleted != null) {
      _completedTasks.add(choice.taskCompleted!);
    }
    if (choice.tag != null) {
      _appliedTags.add(choice.tag!);
    }
    _selectedChoiceHistory.add(choice.label);
    _lastChoiceLabel = choice.label;
    _pendingFeedback = choice.educationalFeedback;
    notifyListeners();
  }

  void advanceScenario() {
    if (!isPlaying || _pendingFeedback == null) return;
    _pendingFeedback = null;
    _lastChoiceLabel = null;
    if (_currentScenarioIndex + 1 >= _activeScenarios.length) {
      _isFinished = true;
      _sessionStatus = GameSessionStatus.completed;
      final endTimeLabel = _activeScenarios[_currentScenarioIndex].endTimeLabel;
      if (endTimeLabel != null) {
        _timeMinutes = _minutesFromTimeLabel(endTimeLabel);
      }
    } else {
      _currentScenarioIndex++;
      final nextScenarioTime = _minutesFromTimeLabel(
        _activeScenarios[_currentScenarioIndex].timeLabel,
      );
      // Choices affect the clock within a scenario.  Waiting until the next
      // scheduled block never moves the day backward, and fills the ordinary
      // gaps between classes.
      if (_timeMinutes < nextScenarioTime) {
        _timeMinutes = nextScenarioTime;
      }
    }
    notifyListeners();
  }

  void toggleVisualEffects() {
    _reduceVisualEffects = !_reduceVisualEffects;
    notifyListeners();
  }

  void _resetProgress() {
    final c = _selectedCharacter;
    _timeMinutes = _activeScenarios.isEmpty
        ? 480
        : _minutesFromTimeLabel(_activeScenarios.first.timeLabel);
    _energy = c?.initialEnergy ?? 80;
    _focus = c?.initialFocus ?? 70;
    _stress = c?.initialStress ?? 20;
    _motivation = c?.initialMotivation ?? 75;
    _lifeSatisfaction = c?.initialLifeSatisfaction ?? 70;
    _selfAdvocacy = c?.initialSelfAdvocacy ?? 50;
    _completedTasks.clear();
    _selectedChoiceHistory.clear();
    _appliedTags.clear();
    _isFinished = false;
    _currentScenarioIndex = 0;
    _pendingFeedback = null;
    _lastChoiceLabel = null;
  }

  /// Starts a blank session. Accessibility-related visual preferences remain.
  void beginNewSession() {
    _selectedCharacter = null;
    _activeScenarios = const [];
    _sessionStatus = GameSessionStatus.unselected;
    _resetProgress();
    notifyListeners();
  }

  /// Ends the current playthrough and removes all character-specific data.
  void endSession() => beginNewSession();

  /// Backward-compatible reset with safe new-session semantics.
  void reset() => beginNewSession();

  int _minutesFromTimeLabel(String label) {
    final match = RegExp(r'^(\d{1,2}):(\d{2}) (AM|PM)$').firstMatch(label);
    if (match == null) {
      throw ArgumentError.value(label, 'label', 'Invalid time label');
    }

    var hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final period = match.group(3)!;
    if (hour == 12) hour = 0;
    if (period == 'PM') hour += 12;
    return hour * 60 + minute;
  }
}

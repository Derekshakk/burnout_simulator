import 'package:flutter/foundation.dart';
import 'game_choice.dart';

class GameState extends ChangeNotifier {
  int _timeMinutes = 480; // 8:00 AM
  double _energy = 80;
  double _focus = 70;
  double _stress = 20;
  double _motivation = 75;
  double _lifeSatisfaction = 70;
  double _selfAdvocacy = 50;
  final List<String> _completedTasks = [];
  final List<String> _selectedChoiceHistory = [];
  bool _isFinished = false;
  bool _reduceVisualEffects = false;
  int _currentScenarioIndex = 0;
  String? _pendingFeedback;
  String? _lastChoiceLabel;

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
  bool get isFinished => _isFinished;
  bool get reduceVisualEffects => _reduceVisualEffects;
  int get currentScenarioIndex => _currentScenarioIndex;
  String? get pendingFeedback => _pendingFeedback;
  String? get lastChoiceLabel => _lastChoiceLabel;

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

  String get currentTimeLabel {
    final hours = _timeMinutes ~/ 60;
    final minutes = _timeMinutes % 60;
    final amPm = hours >= 12 ? 'PM' : 'AM';
    final displayHour = hours > 12 ? hours - 12 : (hours == 0 ? 12 : hours);
    return '${displayHour.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $amPm';
  }

  bool get canDoHighEnergyActivity => burnoutLevel < 70 && _energy > 30;
  bool get canDoLowEnergyActivity => burnoutLevel < 85 && _energy > 10;

  void applyChoice(GameChoice choice) {
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
    _selectedChoiceHistory.add(choice.label);
    _lastChoiceLabel = choice.label;
    _pendingFeedback = choice.educationalFeedback;
    notifyListeners();
  }

  void advanceScenario(int totalScenarios) {
    _pendingFeedback = null;
    _lastChoiceLabel = null;
    if (_currentScenarioIndex + 1 >= totalScenarios) {
      _isFinished = true;
    } else {
      _currentScenarioIndex++;
    }
    notifyListeners();
  }

  void toggleVisualEffects() {
    _reduceVisualEffects = !_reduceVisualEffects;
    notifyListeners();
  }

  void reset() {
    _timeMinutes = 480;
    _energy = 80;
    _focus = 70;
    _stress = 20;
    _motivation = 75;
    _lifeSatisfaction = 70;
    _selfAdvocacy = 50;
    _completedTasks.clear();
    _selectedChoiceHistory.clear();
    _isFinished = false;
    _currentScenarioIndex = 0;
    _pendingFeedback = null;
    _lastChoiceLabel = null;
    notifyListeners();
  }
}

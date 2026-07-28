class GameChoice {
  final String id;
  final String label;
  final String description;
  final double energyDelta;
  final double focusDelta;
  final double stressDelta;
  final double motivationDelta;
  final double lifeSatisfactionDelta;
  final double selfAdvocacyDelta;
  final int timeMinutesDelta;
  final String? taskCompleted;
  final String educationalFeedback;
  final String? tag;
  final double? minEnergyRequired;
  final double? maxBurnoutAllowed;
  final String? unavailableReason;

  const GameChoice({
    required this.id,
    required this.label,
    required this.description,
    this.energyDelta = 0,
    this.focusDelta = 0,
    this.stressDelta = 0,
    this.motivationDelta = 0,
    this.lifeSatisfactionDelta = 0,
    this.selfAdvocacyDelta = 0,
    this.timeMinutesDelta = 0,
    this.taskCompleted,
    required this.educationalFeedback,
    this.tag,
    this.minEnergyRequired,
    this.maxBurnoutAllowed,
    this.unavailableReason,
  });
}

class CharacterProfile {
  final String id;
  final String name;
  final int age;
  final String context;
  final String gender;
  final String pronouns;
  final String shortDescription;
  final String neurodivergenceType;
  final List<String> strengths;
  final List<String> burnoutTriggers;
  final List<String> recoveryStrategies;
  final List<String> supportiveStrategies;
  final String lowEnergyActivity;
  final String highEnergyActivity;
  final String disclaimer;
  final double initialEnergy;
  final double initialStress;
  final double initialFocus;
  final double initialMotivation;
  final double initialLifeSatisfaction;
  final double initialSelfAdvocacy;

  const CharacterProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.context,
    required this.gender,
    required this.pronouns,
    required this.shortDescription,
    required this.neurodivergenceType,
    required this.strengths,
    required this.burnoutTriggers,
    required this.recoveryStrategies,
    required this.supportiveStrategies,
    required this.lowEnergyActivity,
    required this.highEnergyActivity,
    required this.disclaimer,
    this.initialEnergy = 80,
    this.initialStress = 20,
    this.initialFocus = 70,
    this.initialMotivation = 75,
    this.initialLifeSatisfaction = 70,
    this.initialSelfAdvocacy = 50,
  });
}

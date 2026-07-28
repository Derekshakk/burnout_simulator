class CharacterProfile {
  final String name;
  final int age;
  final String context;
  final String shortDescription;
  final List<String> strengths;
  final List<String> supportiveStrategies;
  final String lowEnergyActivity;
  final String highEnergyActivity;
  final String disclaimer;

  const CharacterProfile({
    required this.name,
    required this.age,
    required this.context,
    required this.shortDescription,
    required this.strengths,
    required this.supportiveStrategies,
    required this.lowEnergyActivity,
    required this.highEnergyActivity,
    required this.disclaimer,
  });
}

import '../models/character_profile.dart';

const demoCharacter = CharacterProfile(
  id: 'alex',
  name: 'Alex',
  age: 16,
  context: 'High school student',
  gender: 'Male',
  pronouns: 'he/him',
  shortDescription:
      'Alex experiences attention regulation difficulties, executive-function demands, overcommitment, and periods of intense focus followed by exhaustion.',
  neurodivergenceType: 'ADHD',
  strengths: [
    'Creativity',
    'Deep engagement with preferred projects',
    'Quick idea generation',
  ],
  burnoutTriggers: [
    'Long lists of unstructured tasks',
    'Sensory noise in crowded spaces',
    'Mismatched assignments that don\'t align with strengths',
    'Running out of time before feeling done',
  ],
  recoveryStrategies: [
    'Movement breaks',
    'Listening to music',
    'Working on a preferred creative project',
    'Breaking tasks into smaller, manageable steps',
  ],
  supportiveStrategies: [
    'Breaking work into smaller steps',
    'Visual planning',
    'Short movement breaks',
    'Asking for clearer priorities',
  ],
  lowEnergyActivity: 'Listening to a favorite music playlist',
  highEnergyActivity: 'Working on a creative digital project',
  disclaimer:
      'Alex is a fictional example created for educational purposes. This character does not represent all people with ADHD, autism, or any neurodivergent experience. Different people have different strengths, challenges, and support needs.',
  initialEnergy: 80,
  initialStress: 20,
  initialFocus: 70,
  initialMotivation: 75,
  initialLifeSatisfaction: 70,
  initialSelfAdvocacy: 50,
);

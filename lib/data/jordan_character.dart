import '../models/character_profile.dart';

const jordanCharacter = CharacterProfile(
  id: 'jordan',
  name: 'Jordan',
  age: 17,
  context: 'High school student',
  shortDescription:
      'Jordan navigates a world built for neurotypical processing. Routines provide stability, sensory environments affect capacity, and masking — performing expected social behavior — has a real and cumulative energy cost.',
  neurodivergenceType: 'Autism',
  strengths: [
    'Pattern recognition and systematic thinking',
    'Deep expertise in areas of interest',
    'Reliability and attention to detail',
    'Creative problem-solving within structured systems',
  ],
  burnoutTriggers: [
    'Unexpected changes to routine or schedule',
    'Extended social masking',
    'Sensory overload (noise, lights, texture, smell)',
    'Ambiguous instructions with no clear success criteria',
    'Transitions without adequate warning',
  ],
  recoveryStrategies: [
    'Special interest time (mechanical puzzle games)',
    'Quiet spaces with low sensory input',
    'Fidgets and sensory toys',
    'Scheduled alone time between demands',
    'Clear and predictable routines',
  ],
  supportiveStrategies: [
    'Written instructions and clear grading criteria',
    'Advance notice of schedule changes',
    'Access to a designated quiet space at school',
    'Scheduled check-ins with a trusted adult',
  ],
  lowEnergyActivity: 'Quiet time with a stim toy or mechanical puzzle',
  highEnergyActivity: 'Working on a complex mechanical engineering puzzle game',
  disclaimer:
      'Jordan is a fictional example created for educational purposes. This character does not represent all autistic people or the full range of autistic experience. Autism is a broad spectrum — strengths, challenges, and support needs vary widely from person to person.',
  initialEnergy: 75,
  initialStress: 30,
  initialFocus: 65,
  initialMotivation: 70,
  initialLifeSatisfaction: 65,
  initialSelfAdvocacy: 40,
);

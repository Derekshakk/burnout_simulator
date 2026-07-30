import 'package:flutter/material.dart';

import '../models/character_profile.dart';

const mayaCharacter = CharacterProfile(
  id: 'maya',
  name: 'Maya',
  age: 18,
  context: 'First-year college student',
  gender: 'Female',
  pronouns: 'she/her',
  shortDescription:
      'Maya is autistic and has ADHD (AuDHD). Clear structure, interest-based learning, and sensory supports help Maya thrive; juggling competing demands, unexpected changes, and the effort of switching tasks can drain capacity quickly.',
  neurodivergenceType: 'Autism + ADHD',
  strengths: [
    'Connecting detailed patterns with big-picture ideas',
    'Curiosity and deep, interest-led learning',
    'Creative, unconventional problem-solving',
    'Strong sense of fairness and care for others',
  ],
  burnoutTriggers: [
    'Abrupt changes and unclear expectations',
    'Task switching, time blindness, and competing deadlines',
    'Crowded or unpredictable sensory environments',
    'Sustained masking or pressure to appear fine',
  ],
  recoveryStrategies: [
    'A quiet, low-sensory reset with food and water',
    'Body-doubling or starting work alongside someone trusted',
    'Movement, stimming, and sensory tools',
    'External reminders and a short, visible next-step list',
  ],
  supportiveStrategies: [
    'Written instructions, clear priorities, and advance notice',
    'Flexible ways to participate and demonstrate learning',
    'Permission to use headphones, movement, and quiet spaces',
    'Collaborative planning that does not treat support as failure',
  ],
  lowEnergyActivity: 'A quiet reset with a familiar podcast and sensory tools',
  highEnergyActivity: 'Designing an interactive exhibit for a topic Maya loves',
  disclaimer:
      'Maya is a fictional educational example, not a definition of AuDHD. Autistic people with ADHD have varied strengths, challenges, identities, and support needs. No one strategy or experience applies to everyone.',
  initialEnergy: 72,
  initialStress: 32,
  initialFocus: 62,
  initialMotivation: 74,
  initialLifeSatisfaction: 68,
  initialSelfAdvocacy: 45,
  portraitImagePath: 'assets/characters/maya.jpg',
  appearance: CharacterAppearance(
    skinTone: Color(0xFFFFC18F),
    hairColor: Color(0xFF21170E),
    topColor: Color(0xFF3E8C83),
    bottomColor: Color(0xFF53697E),
  ),
);

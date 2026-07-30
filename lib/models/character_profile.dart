import 'package:flutter/material.dart';

/// Compact visual palette for the reusable pixel-style character figure.
///
/// This stays alongside the character profile rather than in a screen so any
/// new character can supply its own appearance wherever a lightweight avatar
/// is needed. Full portrait images remain independent from this palette.
class CharacterAppearance {
  final Color skinTone;
  final Color hairColor;
  final Color topColor;
  final Color bottomColor;

  const CharacterAppearance({
    required this.skinTone,
    required this.hairColor,
    required this.topColor,
    required this.bottomColor,
  });

  /// Neutral, readable fallback for profiles that do not yet provide visual
  /// attributes. It keeps the condition figure functional for future data.
  static const neutral = CharacterAppearance(
    skinTone: Color(0xFFE8C99A),
    hairColor: Color(0xFF4A3728),
    topColor: Color(0xFF667085),
    bottomColor: Color(0xFF52667A),
  );
}

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
  // Optional path to a portrait image asset. When null (or the asset is
  // missing) the UI falls back to a generated pixel-art avatar.
  final String? portraitImagePath;
  // Optional palette for compact pixel-style representations, such as the
  // end-of-day condition figure. Null deliberately falls back to neutral.
  final CharacterAppearance? appearance;

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
    this.portraitImagePath,
    this.appearance,
  });
}

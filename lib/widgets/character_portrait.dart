import 'package:flutter/material.dart';
import '../app/theme.dart';
import '../models/character_profile.dart';

/// Reusable portrait widget. Shows the character's custom image when
/// `portraitImagePath` is set; falls back to a placeholder icon otherwise
/// or if the asset fails to load.
class CharacterPortrait extends StatelessWidget {
  final CharacterProfile character;
  final double width;
  final double height;
  final BoxFit fit;

  const CharacterPortrait({
    super.key,
    required this.character,
    required this.width,
    required this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    if (character.portraitImagePath == null) {
      return _Placeholder(width: width, height: height, name: character.name);
    }
    return Semantics(
      label: 'Portrait of ${character.name}',
      child: Image.asset(
        character.portraitImagePath!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            _Placeholder(width: width, height: height, name: character.name),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final double width;
  final double height;
  final String name;

  const _Placeholder({
    required this.width,
    required this.height,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Portrait placeholder for $name',
      child: Container(
        width: width,
        height: height,
        color: AppColors.surfaceVariant,
        alignment: Alignment.center,
        child: Icon(
          Icons.person_outline,
          color: AppColors.textMuted,
          size: (width * 0.5).clamp(16, 48),
        ),
      ),
    );
  }
}

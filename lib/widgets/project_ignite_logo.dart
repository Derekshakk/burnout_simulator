import 'package:flutter/material.dart';

/// The supplied Project Ignite brand mark, kept at its native aspect ratio.
class ProjectIgniteLogo extends StatelessWidget {
  final double height;

  const ProjectIgniteLogo({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Project Ignite logo',
      child: ExcludeSemantics(
        child: Image.asset(
          'assets/images/project_ignite_logo.png',
          height: height,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}

import 'package:flutter/services.dart';

/// One team member loaded from assets/team/N.txt + assets/team/N.jpg.
class TeamMember {
  final int id;
  final String name;
  final String role;
  final String bio;
  final bool hasPhoto;

  /// Asset path for the numbered photo when one is bundled with the app.
  String get imagePath => 'assets/team/$id.jpg';

  const TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.bio,
    required this.hasPhoto,
  });
}

/// Loads team members from consecutively numbered assets/team/N.txt files.
/// Stops at the first missing file, so files MUST be numbered 1, 2, 3 … N
/// without gaps. A matching N.jpg is detected from the app's asset manifest;
/// the UI deliberately uses its placeholder when no photo has been supplied.
/// See assets/team/README.md for the expected TXT format.
Future<List<TeamMember>> loadTeamMembers({AssetBundle? bundle}) async {
  final assetBundle = bundle ?? rootBundle;
  final assets = await AssetManifest.loadFromAssetBundle(assetBundle);
  final paths = assets.listAssets().toSet();
  final members = <TeamMember>[];
  for (var i = 1; paths.contains('assets/team/$i.txt'); i++) {
    final text = await assetBundle.loadString('assets/team/$i.txt');
    members.add(
      _parse(i, text, hasPhoto: paths.contains('assets/team/$i.jpg')),
    );
  }
  return members;
}

TeamMember _parse(int id, String raw, {required bool hasPhoto}) {
  String name = 'Team Member $id';
  String role = '';
  String bio = '';

  for (final line in raw.trim().split('\n')) {
    final t = line.trim();
    if (t.startsWith('Name:')) {
      name = t.substring(5).trim();
    } else if (t.startsWith('Role:')) {
      role = t.substring(5).trim();
    } else if (t.startsWith('Bio:')) {
      bio = t.substring(4).trim();
    }
  }
  return TeamMember(
    id: id,
    name: name,
    role: role,
    bio: bio,
    hasPhoto: hasPhoto,
  );
}

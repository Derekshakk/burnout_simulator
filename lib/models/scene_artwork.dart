/// A declared artwork asset for a scenario scene.
///
/// Character-owned artwork can only be shown for its owner. Shared artwork is
/// background-only and may be used by any character when the location matches.
class SceneArtwork {
  final String assetPath;
  final String sceneType;
  final String? characterId;
  final bool isShared;

  const SceneArtwork({
    required this.assetPath,
    required this.sceneType,
    this.characterId,
    this.isShared = false,
  }) : assert(
         isShared ? characterId == null : characterId != null,
         'Artwork must be either shared or owned by exactly one character.',
       );

  bool isUsableFor(String selectedCharacterId, String requestedSceneType) =>
      sceneType == requestedSceneType &&
      (isShared || characterId == selectedCharacterId);
}

/// The single ownership registry for every scenario image asset.
///
/// Add new artwork here before assigning it to a scenario. This prevents a
/// filename from becoming an unreviewed, generic fallback for another player.
abstract final class SceneArtworks {
  static const alexProductive = SceneArtwork(
    assetPath: 'assets/stories/alex_productive.jpg',
    sceneType: 'home',
    characterId: 'alex',
  );
  static const jordanBedroomRecovery = SceneArtwork(
    assetPath: 'assets/stories/jordan_bedroom_recovery.jpg',
    sceneType: 'home',
    characterId: 'jordan',
  );
  static const jordanCafeteriaConversation = SceneArtwork(
    assetPath: 'assets/stories/jordan_cafeteria_conversation.jpg',
    sceneType: 'cafeteria',
    characterId: 'jordan',
  );
  static const jordanClassroom = SceneArtwork(
    assetPath: 'assets/stories/jordan_classroom.jpg',
    sceneType: 'classroom',
    characterId: 'jordan',
  );
  static const jordanHallway = SceneArtwork(
    assetPath: 'assets/stories/jordan_hallway.jpg',
    sceneType: 'hallway',
    characterId: 'jordan',
  );
  static const mayaCafeGroup = SceneArtwork(
    assetPath: 'assets/stories/maya_cafe_group.jpg',
    sceneType: 'cafeteria',
    characterId: 'maya',
  );
  static const mayaDisclosingToTeacher = SceneArtwork(
    assetPath: 'assets/stories/maya_disclosing_to_teacher.jpg',
    sceneType: 'classroom',
    characterId: 'maya',
  );

  static const bedroomBackground = SceneArtwork(
    assetPath: 'assets/stories/bedroom_background.jpg',
    sceneType: 'home',
    isShared: true,
  );
  static const cafeteriaBackground = SceneArtwork(
    assetPath: 'assets/stories/cafeteria_background.jpg',
    sceneType: 'cafeteria',
    isShared: true,
  );
  static const hallwayBackground = SceneArtwork(
    assetPath: 'assets/stories/hallway_background.jpg',
    sceneType: 'hallway',
    isShared: true,
  );
  static const timeAwareness = SceneArtwork(
    assetPath: 'assets/stories/time_Awareness.jpg',
    sceneType: 'time_awareness',
    isShared: true,
  );

  static const all = <SceneArtwork>[
    alexProductive,
    jordanBedroomRecovery,
    jordanCafeteriaConversation,
    jordanClassroom,
    jordanHallway,
    mayaCafeGroup,
    mayaDisclosingToTeacher,
    bedroomBackground,
    cafeteriaBackground,
    hallwayBackground,
    timeAwareness,
  ];

  static const sharedBySceneType = <String, SceneArtwork>{
    'home': bedroomBackground,
    'cafeteria': cafeteriaBackground,
    'hallway': hallwayBackground,
    'time_awareness': timeAwareness,
  };

  static bool contains(SceneArtwork artwork) => all.contains(artwork);
}

/// Resolves artwork without allowing a character-owned image to cross players.
/// The returned asset order is: exact character image, matching shared
/// background. Callers then use pixel art and a neutral placeholder as the
/// non-asset fallbacks.
abstract final class SceneArtworkResolver {
  static List<String> assetCandidates({
    required SceneArtwork? preferredArtwork,
    required String selectedCharacterId,
    required String sceneType,
  }) {
    final paths = <String>[];
    if (preferredArtwork?.isUsableFor(selectedCharacterId, sceneType) ??
        false) {
      paths.add(preferredArtwork!.assetPath);
    }

    final sharedArtwork = SceneArtworks.sharedBySceneType[sceneType];
    if (sharedArtwork != null && !paths.contains(sharedArtwork.assetPath)) {
      paths.add(sharedArtwork.assetPath);
    }
    return paths;
  }
}

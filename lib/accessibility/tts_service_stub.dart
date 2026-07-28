// ignore_for_file: avoid_classes_with_only_static_members
class TtsService {
  static bool get isSupported => false;
  static void speak(
    String text,
    double rate, {
    void Function(int charIndex)? onBoundary,
    void Function()? onDone,
  }) {}
  static void stop() {}
  static void pause() {}
  static void resume() {}
}

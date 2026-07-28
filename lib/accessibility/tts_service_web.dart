// ignore_for_file: avoid_classes_with_only_static_members, deprecated_member_use
// dart:html is available on Flutter web only; this file is not imported on other platforms.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class TtsService {
  static bool get isSupported {
    try {
      return html.window.speechSynthesis != null;
    } catch (_) {
      return false;
    }
  }

  static void speak(
    String text,
    double rate, {
    void Function(int charIndex)? onBoundary,
    void Function()? onDone,
  }) {
    try {
      final synth = html.window.speechSynthesis;
      if (synth == null) return;
      synth.cancel();
      final u = html.SpeechSynthesisUtterance(text)
        ..rate = rate.clamp(0.5, 2.0);
      if (onBoundary != null) {
        u.onBoundary.listen((event) {
          onBoundary(event.charIndex ?? 0);
        });
      }
      if (onDone != null) {
        u.onEnd.first.then((_) => onDone());
      }
      synth.speak(u);
    } catch (_) {}
  }

  static void stop() {
    try {
      html.window.speechSynthesis?.cancel();
    } catch (_) {}
  }

  static void pause() {
    try {
      html.window.speechSynthesis?.pause();
    } catch (_) {}
  }

  static void resume() {
    try {
      html.window.speechSynthesis?.resume();
    } catch (_) {}
  }
}

import 'package:flutter/foundation.dart';
import 'tts_service.dart';

enum TtsPlayState { idle, playing, paused }

/// Manages TTS playback state and exposes it for the UI.
class TtsController extends ChangeNotifier {
  TtsPlayState _state = TtsPlayState.idle;
  int _highlightCharIndex = 0;
  String _activeText = '';

  TtsPlayState get state => _state;
  int get highlightCharIndex => _highlightCharIndex;
  String get activeText => _activeText;
  bool get isPlaying => _state == TtsPlayState.playing;
  bool get isPaused => _state == TtsPlayState.paused;
  bool get isIdle => _state == TtsPlayState.idle;

  void speak(String text, double rate) {
    if (!TtsService.isSupported) return;
    _activeText = text;
    _highlightCharIndex = 0;
    _state = TtsPlayState.playing;
    notifyListeners();

    TtsService.speak(
      text,
      rate,
      onBoundary: (charIndex) {
        _highlightCharIndex = charIndex;
        notifyListeners();
      },
      onDone: () {
        _state = TtsPlayState.idle;
        _highlightCharIndex = 0;
        _activeText = '';
        notifyListeners();
      },
    );
  }

  void pause() {
    if (_state != TtsPlayState.playing) return;
    TtsService.pause();
    _state = TtsPlayState.paused;
    notifyListeners();
  }

  void resume() {
    if (_state != TtsPlayState.paused) return;
    TtsService.resume();
    _state = TtsPlayState.playing;
    notifyListeners();
  }

  void stop() {
    TtsService.stop();
    _state = TtsPlayState.idle;
    _highlightCharIndex = 0;
    _activeText = '';
    notifyListeners();
  }

  @override
  void dispose() {
    TtsService.stop();
    super.dispose();
  }
}

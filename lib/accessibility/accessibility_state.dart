import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityState extends ChangeNotifier {
  static const _kFontSize = 'a11y_fontSizeScale';
  static const _kLineHeight = 'a11y_lineHeightScale';
  static const _kLetterSpacing = 'a11y_letterSpacingDelta';
  static const _kContentScale = 'a11y_contentScale';
  static const _kReadableFont = 'a11y_readableFont';
  static const _kHighContrast = 'a11y_highContrast';
  static const _kTextAlign = 'a11y_textAlign';
  static const _kHighlightLinks = 'a11y_highlightLinks';
  static const _kHighlightTitles = 'a11y_highlightTitles';
  static const _kHideImages = 'a11y_hideImages';
  static const _kReadingMask = 'a11y_readingMask';
  static const _kTextMagnifier = 'a11y_textMagnifier';
  static const _kSelectiveBolding = 'a11y_selectiveBolding';
  static const _kSpeechRate = 'a11y_speechRate';

  double fontSizeScale = 1.0;
  double lineHeightScale = 1.0;
  double letterSpacingDelta = 0.0;
  double contentScale = 1.0;
  bool readableFont = false;
  bool highContrast = false;
  TextAlign textAlign = TextAlign.start;
  bool highlightLinks = false;
  bool highlightTitles = false;
  bool hideImages = false;
  bool readingMask = false;
  bool textMagnifier = false;
  bool selectiveBolding = false;
  double speechRate = 1.0;

  SharedPreferences? _prefs;

  bool get hasAnyChange =>
      fontSizeScale != 1.0 ||
      lineHeightScale != 1.0 ||
      letterSpacingDelta != 0.0 ||
      contentScale != 1.0 ||
      readableFont ||
      highContrast ||
      textAlign != TextAlign.start ||
      highlightLinks ||
      highlightTitles ||
      hideImages ||
      readingMask ||
      textMagnifier ||
      selectiveBolding;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    fontSizeScale = _prefs!.getDouble(_kFontSize) ?? 1.0;
    lineHeightScale = _prefs!.getDouble(_kLineHeight) ?? 1.0;
    letterSpacingDelta = _prefs!.getDouble(_kLetterSpacing) ?? 0.0;
    contentScale = _prefs!.getDouble(_kContentScale) ?? 1.0;
    readableFont = _prefs!.getBool(_kReadableFont) ?? false;
    highContrast = _prefs!.getBool(_kHighContrast) ?? false;
    final alignIdx = _prefs!.getInt(_kTextAlign) ?? 0;
    textAlign =
        TextAlign.values[alignIdx.clamp(0, TextAlign.values.length - 1)];
    highlightLinks = _prefs!.getBool(_kHighlightLinks) ?? false;
    highlightTitles = _prefs!.getBool(_kHighlightTitles) ?? false;
    hideImages = _prefs!.getBool(_kHideImages) ?? false;
    readingMask = _prefs!.getBool(_kReadingMask) ?? false;
    textMagnifier = _prefs!.getBool(_kTextMagnifier) ?? false;
    selectiveBolding = _prefs!.getBool(_kSelectiveBolding) ?? false;
    speechRate = _prefs!.getDouble(_kSpeechRate) ?? 1.0;
    notifyListeners();
  }

  void _save() {
    final p = _prefs;
    if (p == null) return;
    p.setDouble(_kFontSize, fontSizeScale);
    p.setDouble(_kLineHeight, lineHeightScale);
    p.setDouble(_kLetterSpacing, letterSpacingDelta);
    p.setDouble(_kContentScale, contentScale);
    p.setBool(_kReadableFont, readableFont);
    p.setBool(_kHighContrast, highContrast);
    p.setInt(_kTextAlign, textAlign.index);
    p.setBool(_kHighlightLinks, highlightLinks);
    p.setBool(_kHighlightTitles, highlightTitles);
    p.setBool(_kHideImages, hideImages);
    p.setBool(_kReadingMask, readingMask);
    p.setBool(_kTextMagnifier, textMagnifier);
    p.setBool(_kSelectiveBolding, selectiveBolding);
    p.setDouble(_kSpeechRate, speechRate);
  }

  void setFontSizeScale(double v) {
    fontSizeScale = v.clamp(0.7, 2.0);
    _save();
    notifyListeners();
  }

  void setLineHeightScale(double v) {
    lineHeightScale = v.clamp(0.7, 2.5);
    _save();
    notifyListeners();
  }

  void setLetterSpacingDelta(double v) {
    letterSpacingDelta = v.clamp(-0.5, 5.0);
    _save();
    notifyListeners();
  }

  void setContentScale(double v) {
    contentScale = v.clamp(0.7, 1.5);
    _save();
    notifyListeners();
  }

  void toggleReadableFont() {
    readableFont = !readableFont;
    _save();
    notifyListeners();
  }

  void toggleHighContrast() {
    highContrast = !highContrast;
    _save();
    notifyListeners();
  }

  void setTextAlign(TextAlign a) {
    textAlign = a;
    _save();
    notifyListeners();
  }

  void toggleHighlightLinks() {
    highlightLinks = !highlightLinks;
    _save();
    notifyListeners();
  }

  void toggleHighlightTitles() {
    highlightTitles = !highlightTitles;
    _save();
    notifyListeners();
  }

  void toggleHideImages() {
    hideImages = !hideImages;
    _save();
    notifyListeners();
  }

  void toggleReadingMask() {
    readingMask = !readingMask;
    _save();
    notifyListeners();
  }

  void toggleTextMagnifier() {
    textMagnifier = !textMagnifier;
    _save();
    notifyListeners();
  }

  void toggleSelectiveBolding() {
    selectiveBolding = !selectiveBolding;
    _save();
    notifyListeners();
  }

  void setSpeechRate(double r) {
    speechRate = r;
    _save();
    notifyListeners();
  }

  void resetAll() {
    fontSizeScale = 1.0;
    lineHeightScale = 1.0;
    letterSpacingDelta = 0.0;
    contentScale = 1.0;
    readableFont = false;
    highContrast = false;
    textAlign = TextAlign.start;
    highlightLinks = false;
    highlightTitles = false;
    hideImages = false;
    readingMask = false;
    textMagnifier = false;
    selectiveBolding = false;
    speechRate = 1.0;
    _save();
    notifyListeners();
  }
}

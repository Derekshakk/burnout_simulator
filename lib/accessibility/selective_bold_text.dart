import 'package:flutter/material.dart';

/// Renders text with the first ~40% of each content word bolded,
/// creating visual "reading anchors". Screen readers receive the
/// original unsplit text via a merged Semantics node.
class SelectiveBoldText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const SelectiveBoldText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: text,
      excludeSemantics: true,
      child: Text.rich(
        _buildSpan(context),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }

  TextSpan _buildSpan(BuildContext context) {
    final baseStyle = style ?? DefaultTextStyle.of(context).style;
    final boldStyle = baseStyle.copyWith(fontWeight: FontWeight.w700);

    final spans = <InlineSpan>[];

    // Split on whitespace while preserving the whitespace
    final parts = text.split(_wordSplit);
    final whitespace = _wordSplit.allMatches(text).toList();
    int wsIdx = 0;

    for (int i = 0; i < parts.length; i++) {
      final word = parts[i];
      if (word.isEmpty) {
        if (wsIdx < whitespace.length) {
          spans.add(
            TextSpan(text: whitespace[wsIdx++].group(0), style: baseStyle),
          );
        }
        continue;
      }

      if (_isEligible(word)) {
        final cutoff = _boldLength(word);
        spans.add(TextSpan(text: word.substring(0, cutoff), style: boldStyle));
        spans.add(TextSpan(text: word.substring(cutoff), style: baseStyle));
      } else {
        spans.add(TextSpan(text: word, style: baseStyle));
      }

      if (wsIdx < whitespace.length) {
        spans.add(
          TextSpan(text: whitespace[wsIdx++].group(0), style: baseStyle),
        );
      }
    }

    return TextSpan(children: spans);
  }

  static final _wordSplit = RegExp(r'(\s+)');

  bool _isEligible(String word) {
    if (word.length < 3) return false;
    // Skip words that look like URLs, email, code
    if (word.contains('/') || word.contains('@') || word.contains('_')) {
      return false;
    }
    // Must contain at least one letter
    return word.contains(RegExp(r'[a-zA-Z]'));
  }

  int _boldLength(String word) {
    // Bold roughly the first 40% of the word, minimum 1 char, maximum half
    final raw = (word.length * 0.4).ceil();
    return raw.clamp(1, (word.length / 2).ceil());
  }
}

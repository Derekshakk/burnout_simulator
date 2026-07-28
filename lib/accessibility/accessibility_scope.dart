import 'package:flutter/material.dart';
import 'accessibility_state.dart';

/// InheritedWidget that makes AccessibilityState available anywhere in the tree.
class AccessibilityScope extends InheritedNotifier<AccessibilityState> {
  const AccessibilityScope({
    super.key,
    required AccessibilityState state,
    required super.child,
  }) : super(notifier: state);

  static AccessibilityState of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AccessibilityScope>();
    assert(scope != null, 'No AccessibilityScope found in context');
    return scope!.notifier!;
  }

  static AccessibilityState? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AccessibilityScope>()
        ?.notifier;
  }
}

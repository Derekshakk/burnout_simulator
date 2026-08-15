import 'package:url_launcher/url_launcher.dart';

/// Mobile/desktop fallback: delegate to url_launcher. Popup blocking is a
/// browser-only concern, so the native platforms use the standard launcher.
Future<bool> openExternalUrl(String url, {required bool sameTab}) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  try {
    return await launchUrl(
      uri,
      mode: sameTab
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
    );
  } catch (_) {
    return false;
  }
}

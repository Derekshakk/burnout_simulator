import 'package:url_launcher/url_launcher.dart';

import 'external_launcher.dart';

typedef UrlLauncher =
    Future<bool> Function(
      Uri uri, {
      LaunchMode mode,
      String? webOnlyWindowName,
    });

/// Centralizes browser and email actions so every external destination is
/// validated and launched consistently across Flutter platforms and the web.
class ExternalActionService {
  ExternalActionService._();

  static const feedbackUrl = 'https://tinyurl.com/projectignitefeedback';
  static const contactEmail = 'Dereksha2008@gmail.com';

  /// Returns an HTTP(S) URI only when [url] is a complete external URL.
  static Uri? websiteUri(String url) {
    final uri = Uri.tryParse(url.trim());
    if (uri == null || !uri.hasAuthority) return null;
    if (uri.scheme != 'http' && uri.scheme != 'https') return null;
    return uri;
  }

  /// Opens a website in a separate browser tab for non-web callers.
  ///
  /// On Flutter web, render user-facing HTTP(S) actions with url_launcher's
  /// Link widget instead. It creates a native anchor, while popup success
  /// cannot be observed reliably through window.open.
  static Future<bool> openWebsite(String url, {UrlLauncher? launcher}) async {
    final uri = websiteUri(url);
    if (uri == null) return false;

    // Tests inject a launcher and assert on its arguments; honor it exactly.
    if (launcher != null) {
      try {
        return await launcher(
          uri,
          mode: LaunchMode.platformDefault,
          webOnlyWindowName: '_blank',
        );
      } catch (_) {
        return false;
      }
    }

    // Production: use the popup-blocker-safe opener (anchor click on web).
    return openExternalUrl(uri.toString(), sameTab: false);
  }

  /// Builds a correctly percent-encoded mailto URI for the contact form.
  static Uri contactEmailUri({
    required String name,
    required String email,
    required String role,
    required String message,
  }) {
    const subject = 'Project Ignite – Contact Form Submission';
    final body =
        'From: $name\n'
        'Reply-to: $email\n'
        'Role/Reason: $role\n\n'
        'Message:\n$message\n\n'
        '---\n'
        'Sent via the Project Ignite website contact form.';

    return Uri(
      scheme: 'mailto',
      path: contactEmail,
      queryParameters: {'subject': subject, 'body': body},
    );
  }

  static bool isValidEmailUri(Uri uri) =>
      uri.scheme == 'mailto' && uri.path.isNotEmpty;

  /// Opens the visitor's configured email application with a prefilled draft.
  static Future<bool> openEmail(Uri uri, {UrlLauncher? launcher}) async {
    if (!isValidEmailUri(uri)) return false;

    // Tests inject a launcher and assert on its arguments; honor it exactly.
    if (launcher != null) {
      try {
        return await launcher(
          uri,
          mode: LaunchMode.platformDefault,
          // Protocol handlers such as mailto: are most reliable when dispatched
          // from the active browsing context rather than a popup-style tab.
          webOnlyWindowName: '_self',
        );
      } catch (_) {
        return false;
      }
    }

    // Production: anchor-click the mailto in the current context (web) or hand
    // off to the platform launcher (mobile/desktop).
    return openExternalUrl(uri.toString(), sameTab: true);
  }
}

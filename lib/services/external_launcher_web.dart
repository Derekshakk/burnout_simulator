import 'package:web/web.dart' as web;

/// Web: synchronously create and click a real `<a>` element. Performing the
/// click inside the originating user-gesture call stack avoids the popup
/// blocker that silently stops `window.open` on deployed origins (the reason
/// links work on localhost but "cannot open" on the live site).
///
/// [sameTab] is used for `mailto:` (which should stay in the current context);
/// http(s) links open in a new tab with `rel="noopener noreferrer"`.
Future<bool> openExternalUrl(String url, {required bool sameTab}) async {
  try {
    final anchor = web.HTMLAnchorElement()
      ..href = url
      ..rel = 'noopener noreferrer';
    if (!sameTab) anchor.target = '_blank';
    final body = web.document.body;
    if (body == null) return false;
    body.appendChild(anchor);
    anchor.click();
    anchor.remove();
    return true;
  } catch (_) {
    return false;
  }
}

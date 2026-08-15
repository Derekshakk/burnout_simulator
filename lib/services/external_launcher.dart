/// Platform-conditional external-URL opener.
///
/// On Flutter web the release build uses the CanvasKit renderer, where
/// `url_launcher`/`window.open` is silently blocked by the browser popup
/// blocker on deployed (non-localhost) origins — which is why external links
/// work under `flutter run` but fail on the live site. The web implementation
/// instead creates and clicks a real `<a>` element inside the user-gesture
/// call stack, which browsers reliably honor. Mobile/desktop keep url_launcher.
library;

export 'external_launcher_io.dart'
    if (dart.library.js_interop) 'external_launcher_web.dart';

import 'package:burnout_simulator/services/external_action_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  group('ExternalActionService', () {
    test('accepts complete HTTP(S) website URLs only', () {
      expect(
        ExternalActionService.websiteUri('https://youtu.be/88TJ-HQA_qk'),
        isNotNull,
      );
      expect(
        ExternalActionService.websiteUri('http://example.com/resource'),
        isNotNull,
      );
      expect(ExternalActionService.websiteUri('not a URL'), isNull);
      expect(
        ExternalActionService.websiteUri('mailto:person@example.com'),
        isNull,
      );
      expect(ExternalActionService.websiteUri('javascript:alert(1)'), isNull);
    });

    test('encodes every contact field in the mailto query', () {
      final uri = ExternalActionService.contactEmailUri(
        name: 'Alex & Jamie',
        email: 'alex+feedback@example.com',
        role: 'Student / parent',
        message: 'Hello & thank you!\nCan we talk at 3:00?',
      );

      expect(uri.scheme, 'mailto');
      expect(uri.path, ExternalActionService.contactEmail);
      expect(uri.queryParameters['subject'], contains('Contact Form'));
      expect(uri.queryParameters['body'], contains('Alex & Jamie'));
      expect(
        uri.queryParameters['body'],
        contains('alex+feedback@example.com'),
      );
      expect(uri.queryParameters['body'], contains('Student / parent'));
      expect(uri.queryParameters['body'], contains('Hello & thank you!'));
      expect(uri.toString(), contains('%26'));
      expect(uri.toString(), contains('%0A'));
      expect(uri.toString(), contains('%2B'));
      expect(ExternalActionService.isValidEmailUri(uri), isTrue);
    });

    test('rejects malformed email actions before launching', () {
      expect(
        ExternalActionService.isValidEmailUri(Uri.parse('https://example.com')),
        isFalse,
      );
      expect(
        ExternalActionService.isValidEmailUri(Uri(scheme: 'mailto')),
        isFalse,
      );
    });

    test(
      'opens websites in a new browser tab and reports launch failures',
      () async {
        Uri? launchedUri;
        String? windowName;
        final opened = await ExternalActionService.openWebsite(
          'https://youtu.be/88TJ-HQA_qk',
          launcher:
              (
                uri, {
                mode = LaunchMode.platformDefault,
                webOnlyWindowName,
              }) async {
                launchedUri = uri;
                windowName = webOnlyWindowName;
                return true;
              },
        );

        expect(opened, isTrue);
        expect(launchedUri.toString(), 'https://youtu.be/88TJ-HQA_qk');
        expect(windowName, '_blank');
        expect(
          await ExternalActionService.openWebsite(
            'https://example.com',
            launcher:
                (
                  uri, {
                  mode = LaunchMode.platformDefault,
                  webOnlyWindowName,
                }) async => false,
          ),
          isFalse,
        );
      },
    );

    test('does not attempt to launch malformed destinations', () async {
      var launchCalled = false;
      final opened = await ExternalActionService.openWebsite(
        'javascript:alert(1)',
        launcher:
            (
              uri, {
              mode = LaunchMode.platformDefault,
              webOnlyWindowName,
            }) async {
              launchCalled = true;
              return true;
            },
      );

      expect(opened, isFalse);
      expect(launchCalled, isFalse);
    });
  });
}

import 'package:burnout_simulator/widgets/educational_feedback_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('feedback footer fits narrow enlarged-text layouts', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 360,
            child: MediaQuery(
              data: const MediaQueryData(
                size: Size(360, 800),
                textScaler: TextScaler.linear(1.5),
              ),
              child: EducationalFeedbackCard(
                choiceLabel: 'Use an accessible strategy',
                feedbackText:
                    'The feedback remains readable when text is enlarged.',
                onContinue: () {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Different people may respond differently.'),
      findsOneWidget,
    );
    expect(find.widgetWithText(ElevatedButton, 'Continue'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ka4_pin_code_field/ka4_pin_code_field.dart';

void main() {
  group('VerificationCodeField Widget Tests', () {
    testWidgets('Renders correct number of fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Ka4PinCodeField(
              length: 6,
              onCompleted: (code) {},
            ),
          ),
        ),
      );

      // Verify that 6 fields are rendered
      expect(find.byType(TextField), findsNWidgets(6));
    });

    testWidgets('Auto-focus moves to next field', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Ka4PinCodeField(
              length: 6,
              onCompleted: (code) {},
            ),
          ),
        ),
      );

      // Enter text in the first field
      await tester.enterText(find.byType(TextField).first, '1');
      await tester.pump();

      // Verify focus moves to the second field
      expect(FocusScope.of(tester.element(find.byType(TextField).at(1))).hasFocus, true);
    });

    testWidgets('Triggers onCompleted when all fields are filled', (WidgetTester tester) async {
      bool isCompleted = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Ka4PinCodeField(
              length: 4,
              onCompleted: (code) {
                isCompleted = true;
              },
            ),
          ),
        ),
      );

      // Fill all fields
      for (int i = 0; i < 4; i++) {
        await tester.enterText(find.byType(TextField).at(i), i.toString());
        await tester.pump();
      }

      // Verify onCompleted is triggered
      expect(isCompleted, true);
    });

    testWidgets('Pastes code into all fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Ka4PinCodeField(
              length: 4,
              onCompleted: (code) {},
            ),
          ),
        ),
      );

      // Simulate pasting a code
      await tester.showKeyboard(find.byType(TextField).first);
      await tester.enterText(find.byType(TextField).first, '1234');
      await tester.pump();

      // Verify all fields are filled
      for (int i = 0; i < 4; i++) {
        expect(find.text((i + 1).toString()), findsOneWidget);
      }
    });
  });
}
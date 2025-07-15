import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shift_handover_challenge/core/service_locator.dart';
import 'package:shift_handover_challenge/features/shift_handover/presentation/pages/shift_handover_screen.dart';
import 'package:shift_handover_challenge/main.dart';

void main() {
  // Setup service locator before running tests
  setUpAll(() {
    setupServiceLocator();
  });

  group('Shift Handover Integration Tests', () {
    testWidgets('Complete Shift Handover Workflow',
        (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const MyApp());

      // Wait for the app to settle
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify the initial screen loads
      expect(find.byType(ShiftHandoverScreen), findsOneWidget);

      // Enter a new note
      final textField = find.byType(TextField).first;
      await tester.enterText(textField, 'Test observation note');

      // Send note
      await tester.tap(find.descendant(
        of: find.byType(TextField).first,
        matching: find.byIcon(Icons.send),
      ));
      await tester.pumpAndSettle();

      // Verify note is added
      expect(find.text('Test observation note'), findsOneWidget);

      // Verify note type dropdown works
      await tester.tap(find.byIcon(Icons.category_outlined));
      await tester.pumpAndSettle();

      // Tap the first dropdown item (INCIDENT)
      await tester.tap(find.text('INCIDENT').first);
      await tester.pumpAndSettle();

      // Add another note
      await tester.enterText(textField, 'Incident report');
      await tester.tap(find.descendant(
        of: find.byType(TextField).first,
        matching: find.byIcon(Icons.send),
      ));
      await tester.pumpAndSettle();

      // Verify multiple notes
      expect(find.text('Test observation note'), findsOneWidget);
      expect(find.text('Incident report'), findsOneWidget);

      // Test sorting
      await tester.tap(find.byIcon(Icons.sort));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Oldest First'));
      await tester.pumpAndSettle();

      // Test note deletion (Dismissible)
      await tester.drag(
          find.text('Test observation note'), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Verify note is removed
      expect(find.text('Test observation note'), findsNothing);

      // Submit report
      await tester.tap(find.text('Submit Final Report'));
      await tester.pumpAndSettle();

      // Enter summary
      await tester.enterText(
          find.byType(TextField), 'Shift completed successfully');
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Verify submission
      expect(find.text('Report submitted successfully!'), findsOneWidget);
    });
  });
}

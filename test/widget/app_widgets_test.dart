import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kamkar/core/theme/app_colors.dart';
import 'package:kamkar/core/widgets/custom_button.dart';
import 'package:kamkar/core/widgets/status_badge.dart';

void main() {
  group('Core Widget Tests', () {
    testWidgets('CustomButton renders text and triggers callback', (tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Book Now',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Book Now'), findsOneWidget);

      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      expect(pressed, true);
    });

    testWidgets('StatusBadge renders text and icon correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              text: 'VERIFIED',
              color: AppColors.success,
              icon: Icons.verified,
            ),
          ),
        ),
      );

      expect(find.text('VERIFIED'), findsOneWidget);
      expect(find.byIcon(Icons.verified), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_grocery/features/onboarding/presentation/pages/onboardingscreen.dart';
import 'package:mini_grocery/features/auth/presentation/pages/loginpagescreen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: Onboardingscreen(),
    );
  }

  testWidgets('Onboarding first page loads correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Fresh picks'), findsOneWidget);
    expect(find.text('Fresh Groceries, Every Time'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('Next button moves to second page',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Shop in a Snap'), findsOneWidget);
  });

  testWidgets('Button text changes to Start on last page',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Move to page 2
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Move to page 3
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Start'), findsOneWidget);
  });

  testWidgets('Tapping Start navigates to Login screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Move to last page
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Tap Start
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
  });
}

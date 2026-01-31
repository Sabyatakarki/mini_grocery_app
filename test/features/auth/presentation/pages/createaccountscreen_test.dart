import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_grocery/features/auth/presentation/pages/createaccountscreen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: CreateAccountScreen(),
      ),
    );
  }

  testWidgets('Create Account screen loads correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
  });

  testWidgets('Shows validation errors when form is empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('Sign up'));
    await tester.pump();

    expect(find.text('Full name required'), findsOneWidget);
    expect(find.text('Email required'), findsOneWidget);
    expect(find.text('Phone number required'), findsOneWidget);
  });

  testWidgets('Shows error when passwords do not match',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(
        find.byType(TextFormField).at(3), '123456');
    await tester.enterText(
        find.byType(TextFormField).at(4), '654321');

    await tester.tap(find.text('Sign up'));
    await tester.pump();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('Checkbox toggles correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    final checkbox = find.byType(Checkbox);
    expect(checkbox, findsOneWidget);

    await tester.tap(checkbox);
    await tester.pump();

    Checkbox cb = tester.widget(checkbox);
    expect(cb.value, true);
  });
}

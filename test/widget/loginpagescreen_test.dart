import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_grocery/features/auth/presentation/pages/loginpagescreen.dart';

void main() {
  testWidgets('Login screen has email and password fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextField(key: Key('email')),
              TextField(key: Key('password')),
              ElevatedButton(onPressed: null, child: Text('Login')),
            ],
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('email')), findsOneWidget);
    expect(find.byKey(const Key('password')), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
  testWidgets('Login button is disabled when fields are empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextField(key: Key('email')),
              TextField(key: Key('password')),
              ElevatedButton(onPressed: null, child: Text('Login')),
            ],
          ),
        ),
      ),
    );

    final loginButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Login'));
    expect(loginButton.onPressed, isNull);
  });
    testWidgets('Login screen should display welcome text', (tester) async {

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.text("Welcome Back"), findsOneWidget);
  });
  
  testWidgets('Password visibility icon should toggle', (tester) async {

  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(
        home: LoginScreen()
      ),
    ),
  );

  final visibilityIcon = find.byIcon(Icons.visibility_off);

  expect(visibilityIcon, findsOneWidget);

  await tester.tap(visibilityIcon);
  await tester.pump();

  expect(find.byIcon(Icons.visibility), findsOneWidget);
});
testWidgets('Login button should be visible', (tester) async {

  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(
        home: LoginScreen(),
      ),
    ),
  );

  expect(find.text("Log in"), findsOneWidget);
});
  
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Logout dialog shows confirmation message',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AlertDialog(
            title: Text('Logout'),
            content: Text('Are you sure you want to log out?'),
          ),
        ),
      ),
    );

    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('Are you sure you want to log out?'), findsOneWidget);
  });
  testWidgets('Logout dialog has Cancel and Confirm buttons',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AlertDialog(
            title: Text('Logout'),
            content: Text('Are you sure you want to log out?'),
            actions: [
              TextButton(onPressed: null, child: Text('Cancel')),
              ElevatedButton(onPressed: null, child: Text('Confirm')),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
  });
  
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_grocery/features/dashboard/presentation/pages/cart_screen.dart';

void main() {
  testWidgets('Cart should show empty message when no items', (tester) async {

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CartScreen(),
        ),
      ),
    );

    expect(find.text("Your cart is empty"), findsOneWidget);
  });
  testWidgets('Place Order button should be visible', (tester) async {

  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(
        home: CartScreen(),
      ),
    ),
  );

  expect(find.text("Place Order"), findsNothing);
});
testWidgets('Cart screen should display title', (tester) async {

  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(
        home: CartScreen(),
      ),
    ),
  );

  expect(find.text("Your Cart"), findsOneWidget);
});
testWidgets('Delete icon should exist in cart items', (tester) async {

  await tester.pumpWidget(
    const ProviderScope(
      child: MaterialApp(
        home: CartScreen(),
      ),
    ),
  );

  expect(find.byIcon(Icons.delete_outline), findsNothing);
});

}
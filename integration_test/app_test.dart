// @dart=2.9
import 'package:flutter/material.dart';

///To run this integration test, use following command:
/// flutter drive --target=integration_test/app_test.dart --driver=test_driver/integration_test.dart
///ref = https://flutter.dev/docs/testing/integration-tests
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shopper_bloc/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ShopperApp', () {
    testWidgets('renders correct AppBar text', (tester) async {
      await tester.pumpApp();
      expect(find.text('Catalog'), findsOneWidget);
    });

    testWidgets('renders correct initial page', (tester) async {
      await tester.pumpApp();
      expect(find.text('Catalog'), findsOneWidget);
      await tester.loadComplete();
      expect(find.text('+0'), findsWidgets);
      expect(find.text('ADD'), findsWidgets);
    });

    testWidgets('navigate to cart', (tester) async {
      await tester.pumpApp();
      await tester.loadComplete();

      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();

      expect(find.text('Nothing in the cart..'), findsOneWidget);

      // Buy an item.
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('ADD').first);

      // Check that the shopping cart is not empty anymore.
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();
      expect(find.text('Nothing in the cart..'), findsNothing);

    });
  });
}

extension on WidgetTester {
  Future<void> pumpApp() async {
    app.main();
    await pumpAndSettle();
  }

  Future<void> loadComplete() async {
    while (true) {
      if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
        debugPrint('load Complete');
        break;
      } else {
        debugPrint('load yet Complete');
        await Future.delayed(Duration(milliseconds: 25));
        continue;
      }
    }
    await pump();
  }
}

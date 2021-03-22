import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopper_bloc/cart/bloc/cart_bloc.dart';
import 'package:shopper_bloc/cart/cart.dart';
import 'package:shopper_bloc/cart/my_cart.dart';
import 'package:shopper_bloc/catalog/models/item.dart';

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue<CartState>(CartLoading());
    registerFallbackValue<CartEvent>(CartStarted());
  });

  group('MyCart', () {
    final Item a = Item(0, "A", 56);
    final Item b = Item(1, "B", 57);

    testWidgets('renders CartLoading state', (tester) async {
      final cartBloc = MockCartBloc();
      when(() => cartBloc.state).thenReturn(CartLoading());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CartBloc>(
            create: (_) => cartBloc,
            child: MyCart(),
          ),
        ),
      );
      expect(find.text('Cart'), findsOneWidget);
      expect(find.byKey(Key('cart_loading')), findsOneWidget);
    });

    testWidgets('renders CartError state', (tester) async {
      final cartBloc = MockCartBloc();
      when(() => cartBloc.state).thenReturn(CartError());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CartBloc>(
            create: (_) => cartBloc,
            child: MyCart(),
          ),
        ),
      );
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Something went wrong!'), findsOneWidget);
    });

    testWidgets('renders CartLoaded state with empty cart', (tester) async {
      final cartBloc = MockCartBloc();
      when(() => cartBloc.state).thenReturn(CartLoaded(cart: Cart()));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CartBloc>(
            create: (_) => cartBloc,
            child: MyCart(),
          ),
        ),
      );
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Nothing in the cart..'), findsOneWidget);
      // Verify no BUY button initially exists.
      expect(find.text('BUY'), findsNothing);
    });

    testWidgets('renders CartLoaded state with cart[(a,2),(b,3)]',
        (tester) async {
      final cartBloc = MockCartBloc();
      when(() => cartBloc.state).thenReturn(
          CartLoaded(cart: Cart(items: [CartItem(a, 2), CartItem(b, 3)])));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CartBloc>(
            create: (_) => cartBloc,
            child: MyCart(),
          ),
        ),
      );
      expect(find.text('Cart'), findsOneWidget);
      // Testing total price of the first two items.
      expect(find.text('\$${a.price * 2 + b.price * 3}'), findsOneWidget);
      expect(find.byIcon(Icons.done), findsNWidgets(2));
      expect(find.text(a.name), findsOneWidget);
      expect(find.text(b.name), findsOneWidget);
      expect(find.byIcon(Icons.remove_circle_outline), findsNWidgets(2));
      expect(find.text('BUY'), findsOneWidget);
    });

    testWidgets('renders CartStockChange state with cart[(a,1),(b,2)]',
            (tester) async {
          final cartBloc = MockCartBloc();
          when(() => cartBloc.state).thenReturn(
              CartStockChange(cart: Cart(items: [CartItem(a, 1), CartItem(b, 2)])));
          await tester.pumpWidget(
            MaterialApp(
              home: BlocProvider<CartBloc>(
                create: (_) => cartBloc,
                child: MyCart(),
              ),
            ),
          );
          expect(find.text('Cart'), findsOneWidget);
          // Testing total price of the first two items.
          expect(find.text('\$${a.price * 1 + b.price * 2}'), findsOneWidget);
          expect(find.byIcon(Icons.done), findsNWidgets(2));
          expect(find.text(a.name), findsOneWidget);
          expect(find.text(b.name), findsOneWidget);
          expect(find.byIcon(Icons.remove_circle_outline), findsNWidgets(2));
          expect(find.text('BUY'), findsOneWidget);
        });

    testWidgets('Tapping BUY button displays snackbar.', (tester) async {
      final cartBloc = MockCartBloc();
      when(() => cartBloc.state)
          .thenReturn(CartLoaded(cart: Cart(items: [CartItem(a, 1)])));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CartBloc>(
            create: (_) => cartBloc,
            child: MyCart(),
          ),
        ),
      );
      // Verify no snackbar initially exists.
      expect(find.byType(SnackBar), findsNothing);
      await tester.tap(find.text('BUY'));
      // Schedule animation.
      await tester.pump();
      // Verifying the snackbar upon clicking the button.
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Tapping minus button emits CartItemRemoved.', (tester) async {
      final cartBloc = MockCartBloc();
      when(() => cartBloc.state)
          .thenReturn(CartLoaded(cart: Cart(items: [CartItem(a, 2)])));
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CartBloc>(
            create: (_) => cartBloc,
            child: MyCart(),
          ),
        ),
      );

      expect(find.text('\$${a.price * 2}'), findsOneWidget);
      expect(find.text(a.name), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove_circle_outline));
      verify(() => cartBloc.add(CartItemRemoved(a))).called(1);
    });
  });
}

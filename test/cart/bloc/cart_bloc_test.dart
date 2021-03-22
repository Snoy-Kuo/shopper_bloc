import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopper_bloc/cart/bloc/cart_bloc.dart';
import 'package:shopper_bloc/cart/cart.dart';
import 'package:shopper_bloc/catalog/models/item.dart';

void main() {
  group('CartBloc', () {
    final Item a = Item(0, "A", 56);
    final Item b = Item(1, "B", 57);

    test('initial state is CartLoading', () {
      expect(CartBloc().state, CartLoading());
    });

    group('event CartStarted', () {
      blocTest<CartBloc, CartState>(
        'yield [CartLoading, CartLoaded] when event is CartStarted',
        build: () => CartBloc(),
        act: (bloc) => bloc..add(CartStarted()),
        expect: () => [CartLoading(), CartLoaded()],
      );
    });

    group('event CartItemAdded', () {
      blocTest<CartBloc, CartState>(
        'yield [CartStockChanged([(a,1)])] when event is CartItemAdded(a)',
        build: () => CartBloc(),
        seed: () => CartLoaded(),
        act: (bloc) => bloc..add(CartItemAdded(a)),
        expect: () => [
          CartStockChange(cart: Cart(items: [CartItem(a, 1)]))
        ],
      );

      blocTest<CartBloc, CartState>(
        'yield [CartStockChanged([(a,1)])],yield [CartStockChanged([(a,1),(b,1)])] when event is CartItemAdded(a),CartItemAdded(b)',
        build: () => CartBloc(),
        seed: () => CartLoaded(),
        act: (bloc) => bloc..add(CartItemAdded(a))..add(CartItemAdded(b)),
        expect: () => [
          CartStockChange(cart: Cart(items: [CartItem(a, 1)])),
          CartStockChange(cart: Cart(items: [CartItem(a, 1), CartItem(b, 1)]))
        ],
      );
    });

    group('event CartItemRemoved', () {
      blocTest<CartBloc, CartState>(
        'yield [CartStockChanged([])] when event is CartItemRemoved(a), cart[]',
        build: () => CartBloc(),
        seed: () => CartLoaded(),
        act: (bloc) => bloc..add(CartItemRemoved(a)),
        expect: () => [CartStockChange()],
      );

      blocTest<CartBloc, CartState>(
        'yield [CartStockChanged([])] when event is CartItemRemoved(a), cart[(a,1)]',
        build: () => CartBloc(),
        seed: () => CartLoaded(cart: Cart(items: [CartItem(a, 1)])),
        act: (bloc) => bloc..add(CartItemRemoved(a)),
        expect: () => [
          CartStockChange(),
        ],
      );

      blocTest<CartBloc, CartState>(
        'yield [CartStockChanged([(a,1)])] when event is CartItemRemoved(a), cart[(a,2)]',
        build: () => CartBloc(),
        seed: () => CartLoaded(cart: Cart(items: [CartItem(a, 2)])),
        act: (bloc) => bloc..add(CartItemRemoved(a)),
        expect: () => [
          CartStockChange(cart: Cart(items: [CartItem(a, 1)])),
        ],
      );

      blocTest<CartBloc, CartState>(
        'yield [CartStockChanged([(a,1)])] when event is CartItemRemoved(b), cart[(a,1)]',
        build: () => CartBloc(),
        seed: () => CartLoaded(cart: Cart(items: [CartItem(a, 1)])),
        act: (bloc) => bloc..add(CartItemRemoved(b)),
        expect: () => [
          CartStockChange(cart: Cart(items: [CartItem(a, 1)])),
        ],
      );

      blocTest<CartBloc, CartState>(
        'yield [CartStockChanged([(a,1)])] when event is CartItemRemoved(b), cart[(a,1),(b,1)]',
        build: () => CartBloc(),
        seed: () =>
            CartLoaded(cart: Cart(items: [CartItem(a, 1), CartItem(b, 1)])),
        act: (bloc) => bloc..add(CartItemRemoved(b)),
        expect: () => [
          CartStockChange(cart: Cart(items: [CartItem(a, 1)])),
        ],
      );
    });
  });
}

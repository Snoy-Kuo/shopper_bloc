import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shopper_bloc/cart/cart.dart';
import 'package:shopper_bloc/catalog/catalog.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartLoading());

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is CartStarted) {
      yield* _mapCartStartedToState();
    } else if (event is CartItemAdded) {
      yield* _mapCartItemAddedToState(event, state);
    } else if (event is CartItemRemoved) {
      yield* _mapCartItemMovedToState(event, state);
    }
  }

  Stream<CartState> _mapCartStartedToState() async* {
    yield CartLoading();
    try {
      await Future<void>.delayed(const Duration(seconds: 3));
      yield const CartLoaded();
    } catch (_) {
      yield CartError();
    }
  }

  Stream<CartState> _mapCartItemAddedToState(
    CartItemAdded event,
    CartState state,
  ) async* {
    if (state is CartLoaded) {
      try {
        yield CartLoaded(
          cart: Cart(items: List.from(state.cart.items)..add(event.item)),
        );
      } on Exception {
        yield CartError();
      }
    }
  }

  Stream<CartState> _mapCartItemMovedToState(
    CartItemRemoved event,
    CartState state,
  ) async* {
    if (state is CartLoaded) {
      try {
        yield CartLoaded(
          cart: Cart(items: List.from(state.cart.items)..remove(event.item)),
        );
      } on Exception {
        yield CartError();
      }
    }
  }
}

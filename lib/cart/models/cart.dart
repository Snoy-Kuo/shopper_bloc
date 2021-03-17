import 'package:equatable/equatable.dart';
import 'package:shopper_bloc/catalog/catalog.dart';

class Cart extends Equatable {
  const Cart({this.items = const <CartItem>[]});

  final List<CartItem> items;

  int get totalPrice => items.fold(
      0, (total, current) => total + current.info.price * current.volume);

  int indexOf(Item item) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].info == item) return i;
    }
    return -1;
  }

  @override
  List<Object> get props => [items];
}

class CartItem extends Equatable {
  final Item info;
  final int volume;

  CartItem(this.info, this.volume);

  @override
  List<Object> get props => [info, volume];
}

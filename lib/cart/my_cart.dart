import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopper_bloc/cart/cart.dart';

class MyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: Theme.of(context).textTheme.headline1),
        backgroundColor: Colors.white,
      ),
      body: ColoredBox(
        color: Colors.amber,
        child: _CartBody(),
      ),
    );
  }
}

class _CartBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(builder: (context, state) {
      if (state is CartLoading) {
        return const Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ));
      } else if (state is CartLoaded) {
        if (state.cart.items.isEmpty) {
          return Center(
              child: Text('Nothing in the cart..',
                  style: Theme.of(context)
                      .textTheme
                      .headline1!
                      .copyWith(fontSize: 35)));
        } else {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: _CartList(cart: state.cart),
                ),
              ),
              const Divider(height: 4, color: Colors.black),
              _CartTotal(cart: state.cart)
            ],
          );
        }
      } else {
        return const Text('Something went wrong!');
      }
    });
  }
}

class _CartList extends StatelessWidget {
  _CartList({required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    final itemNameStyle = Theme.of(context).textTheme.headline6;

    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.done),
        trailing: IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: () {
            context.read<CartBloc>().add(CartItemRemoved(cart.items[index].info));
          },
        ),
        title: Text(
          cart.items[index].info.name,
          style: itemNameStyle,
        ),
        subtitle: Text(
          '+${cart.items[index].volume}',
          style: itemNameStyle,
        ),
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {
  _CartTotal({required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    final hugeStyle =
        Theme.of(context).textTheme.headline1?.copyWith(fontSize: 48);

    return SizedBox(
      height: 200,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('\$${cart.totalPrice}', style: hugeStyle),
            const SizedBox(width: 24),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Buying not supported yet.')),
                );
              },
              style: ElevatedButton.styleFrom(primary: Colors.white),
              child: const Text('BUY'),
            ),
          ],
        ),
      ),
    );
  }
}

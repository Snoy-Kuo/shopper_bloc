import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopper_bloc/cart/cart.dart';
import 'package:shopper_bloc/catalog/catalog.dart';
import 'package:shopper_bloc/common/theme.dart';

void main() {
  Bloc.observer = BlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MultiBlocProvider(
      providers: [
        BlocProvider<CatalogBloc>(
          create: (_) => CatalogBloc()..add(CatalogStarted()),
        ),
        BlocProvider<CartBloc>(
          create: (_) => CartBloc()..add(CartStarted()),
        ),
      ],
      child: MaterialApp(
        title: 'Shopper BLoC',
        theme: appTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => MyCatalog(),
          '/cart': (context) => MyCart(),
        },
      ),
    );
  }
}

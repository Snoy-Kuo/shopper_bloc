import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopper_bloc/cart/bloc/cart_bloc.dart';
import 'package:shopper_bloc/cart/models/cart.dart';
import 'package:shopper_bloc/catalog/bloc/catalog_bloc.dart';
import 'package:shopper_bloc/catalog/catalog.dart';
import 'package:shopper_bloc/catalog/models/item.dart';
import 'package:shopper_bloc/catalog/my_catalog.dart';

class MockCatalogBloc extends MockBloc<CatalogEvent, CatalogState>
    implements CatalogBloc {}

class MockCartBloc extends MockBloc<CartEvent, CartState> implements CartBloc {}

void main() {
  late CatalogBloc catalogBloc;
  late CartBloc cartBloc;
  final catalog = Catalog();
  final Item a = catalog.getByPosition(0);
  final Item b = catalog.getByPosition(1);
  final catalogListItems = [a, b];

  setUpAll(() {
    registerFallbackValue<CatalogState>(CatalogLoading());
    registerFallbackValue<CatalogEvent>(CatalogStarted());

    registerFallbackValue<CartState>(CartLoading());
    registerFallbackValue<CartEvent>(CartStarted());
  });

  setUp(() {
    catalogBloc = MockCatalogBloc();
    cartBloc = MockCartBloc();
  });

  group('MyCatalog', () {
    testWidgets('renders CatalogLoading state', (tester) async {
      when(() => catalogBloc.state).thenReturn(CatalogLoading());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CatalogBloc>(
            create: (_) => catalogBloc,
            child: MyCatalog(),
          ),
        ),
      );
      expect(find.text('Catalog'), findsOneWidget);
      expect(find.byKey(Key('catalog_loading')), findsOneWidget);
    });

    testWidgets('renders CatalogError state', (tester) async {
      when(() => catalogBloc.state).thenReturn(CatalogError());
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<CatalogBloc>(
            create: (_) => catalogBloc,
            child: MyCatalog(),
          ),
        ),
      );
      expect(find.text('Catalog'), findsOneWidget);
      expect(find.text('Something went wrong!'), findsOneWidget);
    });

    testWidgets('renders CatalogLoaded state with CartLoading', (tester) async {
      when(() => catalogBloc.state).thenReturn(CatalogLoaded(Catalog()));
      when(() => cartBloc.state).thenReturn(CartLoading());
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CatalogBloc>(create: (_) => catalogBloc),
            BlocProvider<CartBloc>(create: (_) => cartBloc)
          ],
          child: MaterialApp(home: MyCatalog()),
        ),
      );
      expect(find.text('Catalog'), findsOneWidget);
      for (var item in catalogListItems) {
        expect(find.text(item.name), findsOneWidget);
        expect(find.text('\$ ${item.price}'), findsOneWidget);
      }
      expect(find.text('+0'), findsWidgets);
      expect(find.text('ADD'), findsNothing);
      expect(find.byKey(Key('catalog_item_loading')), findsWidgets);
    });

    testWidgets('renders CatalogLoaded state with CartError', (tester) async {
      when(() => catalogBloc.state).thenReturn(CatalogLoaded(Catalog()));
      when(() => cartBloc.state).thenReturn(CartError());
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CatalogBloc>(create: (_) => catalogBloc),
            BlocProvider<CartBloc>(create: (_) => cartBloc)
          ],
          child: MaterialApp(home: MyCatalog()),
        ),
      );
      expect(find.text('Catalog'), findsOneWidget);
      for (var item in catalogListItems) {
        expect(find.text(item.name), findsOneWidget);
        expect(find.text('\$ ${item.price}'), findsOneWidget);
      }
      expect(find.text('+0'), findsWidgets);
      expect(find.text('ADD'), findsNothing);
      expect(find.text('cart accident!'), findsWidgets);
    });

    testWidgets('renders CatalogLoaded state with CartLoaded()',
        (tester) async {
      when(() => catalogBloc.state).thenReturn(CatalogLoaded(Catalog()));
      when(() => cartBloc.state).thenReturn(CartLoaded());
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CatalogBloc>(create: (_) => catalogBloc),
            BlocProvider<CartBloc>(create: (_) => cartBloc)
          ],
          child: MaterialApp(home: MyCatalog()),
        ),
      );
      expect(find.text('Catalog'), findsOneWidget);
      for (var item in catalogListItems) {
        expect(find.text(item.name), findsOneWidget);
        expect(find.text('\$ ${item.price}'), findsOneWidget);
      }
      expect(find.text('+0'), findsWidgets);
      expect(find.text('+1'), findsNothing);
      expect(find.text('ADD'), findsWidgets);
    });

    testWidgets('renders CatalogLoaded state with CartLoaded((a,2),(b,3))',
        (tester) async {
      when(() => catalogBloc.state).thenReturn(CatalogLoaded(Catalog()));
      when(() => cartBloc.state).thenReturn(
          CartLoaded(cart: Cart(items: [CartItem(a, 2), CartItem(b, 3)])));
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CatalogBloc>(create: (_) => catalogBloc),
            BlocProvider<CartBloc>(create: (_) => cartBloc)
          ],
          child: MaterialApp(home: MyCatalog()),
        ),
      );
      expect(find.text('Catalog'), findsOneWidget);
      for (var item in catalogListItems) {
        expect(find.text(item.name), findsOneWidget);
        expect(find.text('\$ ${item.price}'), findsOneWidget);
      }
      expect(find.text('+2'), findsOneWidget);
      expect(find.text('+3'), findsOneWidget);
      expect(find.text('+0'), findsWidgets);
      expect(find.text('ADD'), findsWidgets);
    });

    testWidgets('renders CatalogLoaded state with CartStockChange((a,1),(b,2))',
        (tester) async {
      when(() => catalogBloc.state).thenReturn(CatalogLoaded(Catalog()));
      when(() => cartBloc.state).thenReturn(
          CartStockChange(cart: Cart(items: [CartItem(a, 1), CartItem(b, 2)])));
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CatalogBloc>(create: (_) => catalogBloc),
            BlocProvider<CartBloc>(create: (_) => cartBloc)
          ],
          child: MaterialApp(home: MyCatalog()),
        ),
      );
      expect(find.text('Catalog'), findsOneWidget);
      for (var item in catalogListItems) {
        expect(find.text(item.name), findsOneWidget);
        expect(find.text('\$ ${item.price}'), findsOneWidget);
      }
      expect(find.text('+1'), findsOneWidget);
      expect(find.text('+2'), findsOneWidget);
      expect(find.text('+0'), findsWidgets);
      expect(find.text('ADD'), findsWidgets);
    });

    testWidgets('Tapping ADD button emits CartItemAdded.', (tester) async {
      when(() => catalogBloc.state).thenReturn(CatalogLoaded(Catalog()));
      when(() => cartBloc.state)
          .thenReturn(CartStockChange(cart: Cart(items: [CartItem(a, 2)])));
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CatalogBloc>(create: (_) => catalogBloc),
            BlocProvider<CartBloc>(create: (_) => cartBloc)
          ],
          child: MaterialApp(home: MyCatalog()),
        ),
      );
      expect(find.text('+2'), findsOneWidget);
      await tester.tap(find.text('ADD').first);
      verify(() => cartBloc.add(CartItemAdded(a))).called(1);
    });
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopper_bloc/catalog/bloc/catalog_bloc.dart';
import 'package:shopper_bloc/catalog/models/catalog.dart';

void main() {
  group('CatalogBloc', () {
    test('initial state is CatalogLoading', () {
      expect(CatalogBloc().state, CatalogLoading());
    });

    group('event CatalogStarted', () {
      blocTest<CatalogBloc, CatalogState>(
        'yield [CatalogLoading, CatalogLoaded] when event is CatalogStarted',
        build: () => CatalogBloc(),
        act: (bloc) => bloc..add(CatalogStarted()),
        expect: () => [CatalogLoading(), CatalogLoaded(Catalog())],
      );
    });
  });
}

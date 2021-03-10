import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shopper_bloc/catalog/catalog.dart';

@immutable
class Catalog extends Equatable {
  static const _itemNames = [
    'Item A',
    'Item B',
    'Item C',
    'Item D',
    'Item E',
    'Item F',
    'Item G',
    'Item H',
    'Item I',
    'Item J',
    'Item K',
    'Item L',
    'Item M',
    'Item N',
    'Item O',
  ];

  Item getById(int id) => Item(id, _itemNames[id % _itemNames.length]);

  Item getByPosition(int position) => getById(position);

  @override
  List<Object> get props => [_itemNames];
}

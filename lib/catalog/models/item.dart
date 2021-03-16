import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Item extends Equatable {
  Item(this.id, this.name, this.price)
      : color = Colors.primaries[id % Colors.primaries.length];

  final int id;
  final String name;
  final Color color;
  final int price;

  @override
  List<Object> get props => [id, name, color, price];
}

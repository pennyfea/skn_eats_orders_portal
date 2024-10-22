import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

import '../models.dart';

part 'cart_item.g.dart';

@JsonSerializable(explicitToJson: true)
class CartItem extends Equatable {
  final String id;
  final MenuItem menuItem;
  final int quantity;
  final String? specialInstructions;

  const CartItem({
    required this.id,
    required this.menuItem,
    required this.quantity,
    this.specialInstructions,
  });

  @override
  List<Object?> get props => [id, menuItem, quantity, specialInstructions];

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json['menuItem'] = menuItem.toFirestore();
    return json;
  }

  factory CartItem.fromFirestore(dynamic data) {
    if (data is! Map<String, dynamic>) {
      throw ArgumentError('Expected Map<String, dynamic>, but received ${data.runtimeType}');
    }
    return CartItem(
      id: data['id'] as String? ?? '',
      menuItem: MenuItem.fromFirestore(data['menuItem']),
      quantity: data['quantity'] as int? ?? 0,
      specialInstructions: data['specialInstructions'] as String?,
    );
  }
}
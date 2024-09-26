import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'menu_item_option.g.dart';

@JsonSerializable()
class MenuItemOption extends Equatable {
  final String id;
  final List<String> choices;
  final String category;
  final double? price;
  final int? quantity;

  const MenuItemOption({
    required this.id,
    required this.choices,
    required this.category,
    this.price,
    this.quantity,
  });

  @override
  List<Object?> get props => [
    id,
    choices,
    category,
    price,
    quantity
  ];

  factory MenuItemOption.fromJson(Map<String, dynamic> json) => _$MenuItemOptionFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemOptionToJson(this);

  MenuItemOption copyWith({
    String? id,
    double? price,
    String? category,
    List<String>? choices,
    int? quantity,
  }) {
    return MenuItemOption(
      id: id ?? this.id,
      price: price ?? this.price,
      category: category ?? this.category,
      choices: choices ?? this.choices,
      quantity: quantity ?? this.quantity
    );
  }

  Map<String, dynamic> toFirestore() {
    return toJson();
  }

  factory MenuItemOption.fromFirestore(Map<String, dynamic> data) {
    return MenuItemOption(
      id: data['id'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble(),
      choices: (data['choices'] as List<dynamic>).cast<String>(),
      category: data['category'] as String? ?? '',
      quantity: data['quantity'] as int?,
    );
  }
}

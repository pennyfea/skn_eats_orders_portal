import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../models.dart';

part 'menu_item.g.dart';

@JsonSerializable()
class MenuItem extends Equatable {
  final String? id;
  final String? restaurantId;
  final String name;
  final String? imageUrl;
  final List<MenuCategory> menuCategories;
  final List<MenuCategory>? itemCategories;
  final List<MenuItemOption>? requiredOptions;
  final List<MenuItemOption>? optionalAddOns;
  final String description;
  final double price;

  const MenuItem({
    this.id,
    this.restaurantId,
    required this.name,
    this.imageUrl,
    required this.menuCategories,
    this.itemCategories,
    this.requiredOptions,
    this.optionalAddOns,
    required this.description,
    required this.price,
  });

  MenuItem copyWith({
    String? id,
    String? restaurantId,
    String? name,
    String? imageUrl,
    List<MenuCategory>? itemCategories,
    List<MenuCategory>? menuCategories,
    List<MenuItemOption>? requiredOptions,
    List<MenuItemOption>? optionalAddOns,
    String? description,
    double? price,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      itemCategories: itemCategories ?? this.itemCategories,
      menuCategories: menuCategories ?? this.menuCategories,
      requiredOptions: requiredOptions ?? this.requiredOptions,
      optionalAddOns: optionalAddOns ?? this.optionalAddOns,
      description: description ?? this.description,
      price: price ?? this.price,
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        menuCategories,
        itemCategories,
        requiredOptions,
        optionalAddOns,
        description,
        price,
        restaurantId,
      ];

  // Update serialization for Firestore and JSON

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemToJson(this);

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'name': name,
      'imageUrl': imageUrl,
      'menuCategories': menuCategories.map((cat) => cat.toFirestore()).toList(),
      if (itemCategories != null)
        'itemCategories': itemCategories!.map((cat) => cat.toFirestore()).toList(),
      if (requiredOptions != null)
        'requiredOptions': requiredOptions!.map((e) => e.toJson()).toList(),
      if (optionalAddOns != null)
        'optionalAddOns': optionalAddOns!.map((e) => e.toJson()).toList(),
      'description': description,
      'price': price,
    };
  }

  factory MenuItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('Document does not exist');
    }

    return MenuItem(
      id: data['id'] as String?,
      restaurantId: data['restaurantId'] as String?,
      name: data['name'] as String,
      imageUrl: data['imageUrl'] as String?,
      menuCategories: (data['menuCategories'] as List<dynamic>)
          .map((cat) => MenuCategory.fromFirestore(cat))
          .toList(),
      itemCategories: data['itemCategories'] != null
          ? (data['itemCategories'] as List<dynamic>)
              .map((cat) => MenuCategory.fromFirestore(cat))
              .toList()
          : null,
      requiredOptions: data['requiredOptions'] != null
          ? List<MenuItemOption>.from((data['requiredOptions'] as List)
              .map((e) => MenuItemOption.fromJson(e)))
          : null,
      optionalAddOns: data['optionalAddOns'] != null
          ? List<MenuItemOption>.from((data['optionalAddOns'] as List)
              .map((e) => MenuItemOption.fromJson(e)))
          : null,
      description: data['description'] as String,
      price: (data['price'] as num).toDouble(),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../models.dart';

part 'menu_item.g.dart';

@JsonSerializable()
class MenuItem extends Equatable {
  final String? id;
  final String? restaurantId;
  final String? locationId;
  final String name;
  final String? imageUrl;
  final List<String>? menuCategoryIds;
  final List<String>? itemCategoryIds;
  final List<MenuItemOption>? requiredOptions;
  final List<MenuItemOption>? optionalAddOns;
  final String description;
  final double price;

  const MenuItem({
    this.id,
    this.restaurantId,
    this.locationId,
    required this.name,
    this.imageUrl,
    required this.menuCategoryIds,
    this.itemCategoryIds,
    this.requiredOptions,
    this.optionalAddOns,
    required this.description,
    required this.price,
  });

  MenuItem copyWith({
    String? id,
    String? restaurantId,
    String? locationId,
    String? name,
    String? imageUrl,
    List<String>? itemCategoryIds,
    List<String>? menuCategoryIds,
    List<MenuItemOption>? requiredOptions,
    List<MenuItemOption>? optionalAddOns,
    String? description,
    double? price,
  }) {
    return MenuItem(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      locationId: locationId ?? this.locationId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      itemCategoryIds: itemCategoryIds ?? this.itemCategoryIds,
      menuCategoryIds: menuCategoryIds ?? this.menuCategoryIds,
      requiredOptions: requiredOptions ?? this.requiredOptions,
      optionalAddOns: optionalAddOns ?? this.optionalAddOns,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        locationId,
        name,
        imageUrl,
        menuCategoryIds,
        itemCategoryIds,
        requiredOptions,
        optionalAddOns,
        description,
        price,
      ];

  // Update serialization for Firestore and JSON

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);

  Map<String, dynamic> toJson() => _$MenuItemToJson(this);

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'locationId': locationId,
      'name': name,
      'imageUrl': imageUrl,
      'menuCategoryIds': menuCategoryIds,
      'itemCategoryIds': itemCategoryIds,
      if (requiredOptions != null)
        'requiredOptions': requiredOptions!.map((e) => e.toJson()).toList(),
      if (optionalAddOns != null)
        'optionalAddOns': optionalAddOns!.map((e) => e.toJson()).toList(),
      'description': description,
      'price': price,
    };
  }

  factory MenuItem.fromFirestore(dynamic snapshot) {
    late Map<String, dynamic> data;
    
    if (snapshot is DocumentSnapshot<Map<String, dynamic>>) {
      data = snapshot.data() ?? {};
    } else if (snapshot is Map<String, dynamic>) {
      data = snapshot;
    } else {
      throw ArgumentError('Expected DocumentSnapshot or Map<String, dynamic>, but received ${snapshot.runtimeType}');
    }

    return MenuItem(
      id: data['id'] as String?,
      restaurantId: data['restaurantId'] as String?,
      locationId: data['locationId'] as String?,
      name: data['name'] as String? ?? '',
      imageUrl: data['imageUrl'] as String?,
      menuCategoryIds: List<String>.from(data['menuCategoryIds'] ?? []),
      itemCategoryIds: List<String>.from(data['itemCategoryIds'] ?? []),
      requiredOptions: data['requiredOptions'] != null
          ? List<MenuItemOption>.from((data['requiredOptions'] as List)
              .map((e) => MenuItemOption.fromJson(e as Map<String, dynamic>)))
          : null,
      optionalAddOns: data['optionalAddOns'] != null
          ? List<MenuItemOption>.from((data['optionalAddOns'] as List)
              .map((e) => MenuItemOption.fromJson(e as Map<String, dynamic>)))
          : null,
      description: data['description'] as String? ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => MenuItem(
      id: json['id'] as String?,
      restaurantId: json['restaurantId'] as String?,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      menuCategories: (json['menuCategories'] as List<dynamic>)
          .map((e) => MenuCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemCategories: (json['itemCategories'] as List<dynamic>?)
          ?.map((e) => MenuCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      requiredOptions: (json['requiredOptions'] as List<dynamic>?)
          ?.map((e) => MenuItemOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      optionalAddOns: (json['optionalAddOns'] as List<dynamic>?)
          ?.map((e) => MenuItemOption.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$MenuItemToJson(MenuItem instance) => <String, dynamic>{
      'id': instance.id,
      'restaurantId': instance.restaurantId,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'menuCategories': instance.menuCategories,
      'itemCategories': instance.itemCategories,
      'requiredOptions': instance.requiredOptions,
      'optionalAddOns': instance.optionalAddOns,
      'description': instance.description,
      'price': instance.price,
    };

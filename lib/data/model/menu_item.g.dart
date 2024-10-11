// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => MenuItem(
      id: json['id'] as String?,
      restaurantId: json['restaurantId'] as String?,
      locationId: json['locationId'] as String?,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      menuCategoryIds: (json['menuCategoryIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      itemCategoryIds: (json['itemCategoryIds'] as List<dynamic>?)
          ?.map((e) => e as String)
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
      'locationId': instance.locationId,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'menuCategoryIds': instance.menuCategoryIds,
      'itemCategoryIds': instance.itemCategoryIds,
      'requiredOptions': instance.requiredOptions,
      'optionalAddOns': instance.optionalAddOns,
      'description': instance.description,
      'price': instance.price,
    };

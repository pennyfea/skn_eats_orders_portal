// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantLocation _$RestaurantLocationFromJson(Map<String, dynamic> json) =>
    RestaurantLocation(
      id: json['id'] as String?,
      restaurantId: json['restaurantId'] as String?,
      primaryLocation: json['primaryLocation'] as bool? ?? false,
      name: json['name'] as String?,
      address: json['address'] as String?,
      imageUrl: json['imageUrl'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => FoodCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      menuCategories: (json['menuCategories'] as List<dynamic>?)
          ?.map((e) => MenuCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemCategories: (json['itemCategories'] as List<dynamic>?)
          ?.map((e) => MenuCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      menuItems: (json['menuItems'] as List<dynamic>?)
          ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      workingHours: (json['workingHours'] as List<dynamic>?)
          ?.map((e) => WorkingHours.fromJson(e as Map<String, dynamic>))
          .toList(),
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble(),
      employeeIds: (json['employeeIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      reviewCount: (json['reviewCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RestaurantLocationToJson(RestaurantLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurantId': instance.restaurantId,
      'primaryLocation': instance.primaryLocation,
      'name': instance.name,
      'address': instance.address,
      'imageUrl': instance.imageUrl,
      'categories': instance.categories,
      'menuCategories': instance.menuCategories,
      'itemCategories': instance.itemCategories,
      'menuItems': instance.menuItems,
      'workingHours': instance.workingHours,
      'deliveryFee': instance.deliveryFee,
      'employeeIds': instance.employeeIds,
      'averageRating': instance.averageRating,
      'reviewCount': instance.reviewCount,
    };

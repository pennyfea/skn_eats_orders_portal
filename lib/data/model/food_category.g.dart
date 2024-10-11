// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodCategory _$FoodCategoryFromJson(Map<String, dynamic> json) => FoodCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$FoodCategoryToJson(FoodCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
    };

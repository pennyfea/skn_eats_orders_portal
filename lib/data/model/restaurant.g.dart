// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
      id: json['id'] as String?,
      name: json['name'] as String?,
      setupCompleted: json['setupCompleted'] as bool? ?? false,
      verified: json['verified'] as bool? ?? false,
    );

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'setupCompleted': instance.setupCompleted,
      'verified': instance.verified,
    };

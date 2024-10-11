// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']),
      restaurantId: json['restaurantId'] as String?,
      restaurantLocationIds: (json['restaurantLocationIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role],
      'restaurantId': instance.restaurantId,
      'restaurantLocationIds': instance.restaurantLocationIds,
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.employee: 'employee',
};

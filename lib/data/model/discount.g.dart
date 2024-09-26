// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Discount _$DiscountFromJson(Map<String, dynamic> json) => Discount(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      restaurantLocationId: json['restaurantLocationId'] as String,
      menuItemIds: (json['menuItemIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      code: json['code'] as String?,
      value: (json['value'] as num?)?.toDouble(),
      spendThreshold: (json['spendThreshold'] as num?)?.toDouble(),
      type: $enumDecode(_$DiscountTypeEnumMap, json['type']),
      startDate:
          const DateTimeConverter().fromJson(json['startDate'] as Timestamp),
      endDate: const DateTimeConverter().fromJson(json['endDate'] as Timestamp),
      isActive: json['isActive'] as bool? ?? false,
      redemptionCount: (json['redemptionCount'] as num?)?.toInt() ?? 0,
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$DiscountToJson(Discount instance) => <String, dynamic>{
      'id': instance.id,
      'restaurantId': instance.restaurantId,
      'restaurantLocationId': instance.restaurantLocationId,
      'menuItemIds': instance.menuItemIds,
      'code': instance.code,
      'value': instance.value,
      'spendThreshold': instance.spendThreshold,
      'type': _$DiscountTypeEnumMap[instance.type]!,
      'startDate': const DateTimeConverter().toJson(instance.startDate),
      'endDate': const DateTimeConverter().toJson(instance.endDate),
      'isActive': instance.isActive,
      'redemptionCount': instance.redemptionCount,
      'totalSales': instance.totalSales,
    };

const _$DiscountTypeEnumMap = {
  DiscountType.percentageOff: 'percentageOff',
  DiscountType.buyOneGetOneFree: 'buyOneGetOneFree',
  DiscountType.zeroDeliveryFee: 'zeroDeliveryFee',
  DiscountType.spendMoreSaveMore: 'spendMoreSaveMore',
  DiscountType.saveOnMenuItems: 'saveOnMenuItems',
};

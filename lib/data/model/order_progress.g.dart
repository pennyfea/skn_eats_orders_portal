// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderProgress _$OrderProgressFromJson(Map<String, dynamic> json) =>
    OrderProgress(
      timestamp:
          const DateTimeConverter().fromJson(json['timestamp'] as Timestamp),
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$OrderProgressToJson(OrderProgress instance) =>
    <String, dynamic>{
      'timestamp': const DateTimeConverter().toJson(instance.timestamp),
      'status': _$OrderStatusEnumMap[instance.status]!,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.cancel: 'cancel',
  OrderStatus.pending: 'pending',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.deliveryInPorgress: 'deliveryInPorgress',
  OrderStatus.completed: 'completed',
};

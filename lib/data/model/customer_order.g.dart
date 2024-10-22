// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerOrder _$CustomerOrderFromJson(Map<String, dynamic> json) =>
    CustomerOrder(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      restaurantLocationId: json['restaurantLocationId'] as String,
      customerId: json['customerId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      contactEmail: json['contactEmail'] as String,
      contactPhone: json['contactPhone'] as String,
      deliveryAddress: json['deliveryAddress'] as String,
      confirmationNumber: json['confirmationNumber'] as String,
      total: (json['total'] as num).toDouble(),
      cartItems: (json['cartItems'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
      createdAt:
          const DateTimeConverter().fromJson(json['createdAt'] as Timestamp),
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
      dropOffOptions: json['dropOffOptions'] as String?,
      deliveryInstructions: json['deliveryInstructions'] as String?,
      progress: (json['progress'] as List<dynamic>)
          .map((e) => OrderProgress.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasReviewed: json['hasReviewed'] as bool? ?? false,
      appliedDiscount: json['appliedDiscount'] == null
          ? null
          : Discount.fromJson(json['appliedDiscount'] as Map<String, dynamic>),
      storeLocation: json['storeLocation'] == null
          ? null
          : Location.fromJson(json['storeLocation'] as Map<String, dynamic>),
      userLocation: json['userLocation'] == null
          ? null
          : Location.fromJson(json['userLocation'] as Map<String, dynamic>),
      driverLocation: json['driverLocation'] == null
          ? null
          : Location.fromJson(json['driverLocation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomerOrderToJson(CustomerOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurantId': instance.restaurantId,
      'restaurantLocationId': instance.restaurantLocationId,
      'customerId': instance.customerId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'contactEmail': instance.contactEmail,
      'contactPhone': instance.contactPhone,
      'deliveryAddress': instance.deliveryAddress,
      'confirmationNumber': instance.confirmationNumber,
      'total': instance.total,
      'cartItems': instance.cartItems,
      'notes': instance.notes,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'status': _$OrderStatusEnumMap[instance.status]!,
      'dropOffOptions': instance.dropOffOptions,
      'deliveryInstructions': instance.deliveryInstructions,
      'progress': instance.progress,
      'hasReviewed': instance.hasReviewed,
      'appliedDiscount': instance.appliedDiscount,
      'storeLocation': instance.storeLocation,
      'userLocation': instance.userLocation,
      'driverLocation': instance.driverLocation,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.cancel: 'cancel',
  OrderStatus.pending: 'pending',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.deliveryInPorgress: 'deliveryInPorgress',
  OrderStatus.completed: 'completed',
};

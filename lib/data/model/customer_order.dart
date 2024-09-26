import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../converters/date_time_converter.dart';
import '../models.dart';

part 'customer_order.g.dart';

@JsonSerializable()
class CustomerOrder extends Equatable {
  final String id;
  final String restaurantId;
  final String locationId;
  final String customerId;
  final String firstName;
  final String lastName;
  final String contactEmail;
  final String contactPhone;
  final String deliveryAddress;
  final String confirmationNumber;
  final double total;
  final List<CartItem> cartItems;
  final String? notes;
  @DateTimeConverter()
  final DateTime createdAt;
  final OrderStatus status;
  final String? dropOffOptions;
  final String? deliveryInstructions;
  final List<OrderProgress> progress;
  final bool hasReviewed;
  final Discount? appliedDiscount;

  const CustomerOrder(
      {required this.id,
      required this.restaurantId,
      required this.locationId,
      required this.customerId,
      required this.firstName,
      required this.lastName,
      required this.contactEmail,
      required this.contactPhone,
      required this.deliveryAddress,
      required this.confirmationNumber,
      required this.total,
      required this.cartItems,
      this.notes,
      required this.createdAt,
      required this.status,
      this.dropOffOptions,
      this.deliveryInstructions,
      required this.progress,
      this.hasReviewed = false,
      this.appliedDiscount});

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        locationId, // Include locationId in props
        customerId,
        firstName,
        lastName,
        contactEmail,
        contactPhone,
        deliveryAddress,
        confirmationNumber,
        total,
        cartItems,
        notes,
        createdAt,
        status,
        dropOffOptions,
        deliveryInstructions,
        progress,
        hasReviewed,
        appliedDiscount
      ];

  CustomerOrder copyWith(
      {String? id,
      String? restaurantId,
      String? locationId,
      String? customerId,
      String? firstName,
      String? lastName,
      String? contactEmail,
      String? contactPhone,
      String? deliveryAddress,
      String? confirmationNumber,
      double? total,
      List<CartItem>? cartItems,
      String? notes,
      DateTime? createdAt,
      OrderStatus? status,
      String? dropOffOptions,
      String? deliveryInstructions,
      List<OrderProgress>? progress,
      bool? hasReviewed,
      Discount? appliedDiscount}) {
    return CustomerOrder(
        id: id ?? this.id,
        restaurantId: restaurantId ?? this.restaurantId,
        locationId: locationId ?? this.locationId,
        customerId: customerId ?? this.customerId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        contactEmail: contactEmail ?? this.contactEmail,
        contactPhone: contactPhone ?? this.contactPhone,
        deliveryAddress: deliveryAddress ?? this.deliveryAddress,
        confirmationNumber: confirmationNumber ?? this.confirmationNumber,
        total: total ?? this.total,
        cartItems: cartItems ?? this.cartItems,
        notes: notes ?? this.notes,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
        dropOffOptions: dropOffOptions ?? this.dropOffOptions,
        deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
        progress: progress ?? this.progress,
        hasReviewed: hasReviewed ?? this.hasReviewed,
        appliedDiscount: appliedDiscount ?? this.appliedDiscount);
  }

  double calculateSubtotal() {
    return cartItems.fold(0.0, (sum, item) {
      double itemTotal = item.menuItem.price * item.quantity;
      if (item.menuItem.requiredOptions != null) {
        itemTotal += item.menuItem.requiredOptions!
            .where((option) => option.price != null)
            .fold(0.0, (sum, option) => sum + (option.price ?? 0));
      }
      if (item.menuItem.optionalAddOns != null) {
        itemTotal += item.menuItem.optionalAddOns!
            .where((option) => option.price != null)
            .fold(0.0, (sum, option) => sum + (option.price ?? 0));
      }
      return sum + itemTotal;
    });
  }

  // JSON serialization
  factory CustomerOrder.fromJson(Map<String, dynamic> json) =>
      _$CustomerOrderFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerOrderToJson(this);

  // Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'locationId': locationId,
      'customerId': customerId,
      'firstName': firstName,
      'lastName': lastName,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'deliveryAddress': deliveryAddress,
      'confirmationNumber': confirmationNumber,
      'total': total,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'dropOffOptions': dropOffOptions,
      'deliveryInstructions': deliveryInstructions,
      'status': status.toString().split('.').last,
      'progress': progress.map((p) => p.toFirestore()).toList(),
      'cartItems': cartItems.map((item) => item.toFirestore()).toList(),
      'hasReviewed': hasReviewed,
      if (appliedDiscount != null) 'appliedDiscount': appliedDiscount!.toFirestore(),
    };
  }

  factory CustomerOrder.fromFirestore(Map<String, dynamic> data) {
    final statusString = data['status'] as String?;
    final orderStatus = statusString != null
        ? OrderStatus.values.firstWhere(
            (s) => s.toString().split('.').last == statusString,
            orElse: () => OrderStatus.pending)
        : OrderStatus.pending;

    final progressData = data['progress'] as List<dynamic>?;
    final progress = progressData != null
        ? progressData
            .map((p) => OrderProgress.fromFirestore(p as Map<String, dynamic>))
            .toList()
        : <OrderProgress>[];

    final cartItemsData = data['cartItems'] as List<dynamic>?;
    final cartItems = cartItemsData != null
        ? cartItemsData
            .map((item) => CartItem.fromFirestore(item as Map<String, dynamic>))
            .toList()
        : <CartItem>[];

    return CustomerOrder(
      id: data['id'] as String? ?? '',
      restaurantId: data['restaurantId'] as String? ?? '',
      locationId: data['locationId'] as String? ?? '',
      customerId: data['customerId'] as String? ?? '',
      firstName: data['firstName'] as String? ?? '',
      lastName: data['lastName'] as String? ?? '',
      contactEmail: data['contactEmail'] as String? ?? '',
      contactPhone: data['contactPhone'] as String? ?? '',
      deliveryAddress: data['deliveryAddress'] as String? ?? '',
      confirmationNumber: data['confirmationNumber'] as String? ?? '',
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      cartItems: cartItems,
      notes: data['notes'] as String?,
      dropOffOptions: data['dropOffOptions'] as String?,
      deliveryInstructions: data['deliveryInstructions'] as String?,
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      status: orderStatus,
      progress: progress,
      hasReviewed: data['hasReviewed'] as bool? ?? false,
      appliedDiscount: data['appliedDiscount'] != null
          ? Discount.fromFirestore(data['appliedDiscount'], null)
          : null,
    );
  }
}

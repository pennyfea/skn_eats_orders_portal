import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../converters/date_time_converter.dart';

part 'discount.g.dart';

@JsonSerializable()
class Discount extends Equatable {
  final String id;
  final String restaurantId;
  final String restaurantLocationId;
  final List<String>? menuItemIds;
  final String? code;
  final double? value; // The discount value (percentage or amount off)
  final double? spendThreshold; // New field: amount the customer needs to spen
  final DiscountType type;
  @DateTimeConverter()
  final DateTime startDate;
  @DateTimeConverter()
  final DateTime endDate;
  final bool isActive;
  final int? redemptionCount;
  final double? totalSales;

  const Discount({
    required this.id,
    required this.restaurantId,
    required this.restaurantLocationId,
    this.menuItemIds,
    this.code,
    this.value,
    this.spendThreshold,
    required this.type,
    required this.startDate,
    required this.endDate,
    this.isActive = false,
    this.redemptionCount = 0,
    this.totalSales = 0.0,
  });

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        restaurantLocationId,
        menuItemIds,
        code,
        value,
        spendThreshold,
        type,
        startDate,
        endDate,
        isActive,
        redemptionCount,
        totalSales
      ];

  // JSON serialization
  factory Discount.fromJson(Map<String, dynamic> json) =>
      _$DiscountFromJson(json);
  Map<String, dynamic> toJson() => _$DiscountToJson(this);

  // Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'restaurantLocationId': restaurantLocationId,
      'menuItemIds': menuItemIds, // Serialize the list of menu item IDs
      if (code != null) 'code': code, // Only include 'code' if it's not null
      if (value != null)
        'value': value, // Only include 'value' if it's not null
      if (spendThreshold != null) 'spendThreshold': spendThreshold,
      'type': type.toString().split('.').last,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'isActive': isActive,
      'redemptionCount': redemptionCount,
      'totalSales': totalSales, 
    };
  }

  factory Discount.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data()!;
    return Discount(
      id: data['id'] ?? '',
      restaurantId: data['restaurantId'] ?? '',
      restaurantLocationId: data['restaurantLocationId'] ?? '',
      menuItemIds: List<String>.from(data['menuItemIds'] ?? []),
      code: data['code'],
      value: data['value'] != null ? (data['value'] as num).toDouble() : null,
      spendThreshold: data['spendThreshold'] != null
          ? (data['spendThreshold'] as num).toDouble()
          : null, // Deserialize the new field
      type: DiscountType.values
          .firstWhere((e) => e.toString().split('.').last == data['type']),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
      redemptionCount: data['redemptionCount'],
      totalSales: data['totalSales']
    );
  }

  Discount copyWith({
    String? id,
    String? restaurantId,
    String? restaurantLocationId,
    List<String>? menuItemIds,
    String? code,
    double? value,
    DiscountType? type,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    int? redemptionCount,
    double? totalSales
  }) {
    return Discount(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantLocationId: restaurantLocationId ?? this.restaurantLocationId,
      menuItemIds: menuItemIds ?? this.menuItemIds,
      code: code ?? this.code,
      value: value ?? this.value,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      redemptionCount: redemptionCount ?? this.redemptionCount,
      totalSales: totalSales ?? this.totalSales,
    );
  }

  bool get autoIsActive {
    final currentDate = DateTime.now();
    return currentDate.isAfter(startDate) && currentDate.isBefore(endDate);
  }
}

// Enum to represent the type of discount
enum DiscountType {
  @JsonValue('percentageOff')
  percentageOff,

  @JsonValue('buyOneGetOneFree')
  buyOneGetOneFree,

  @JsonValue('zeroDeliveryFee')
  zeroDeliveryFee,

  @JsonValue('spendMoreSaveMore')
  spendMoreSaveMore,

  @JsonValue('saveOnMenuItems')
  saveOnMenuItems,
}

extension DiscountTypeExtension on DiscountType {
  String toDisplayString() {
    switch (this) {
      case DiscountType.percentageOff:
        return 'Percentage Off';
      case DiscountType.buyOneGetOneFree:
        return 'Buy 1, Get 1 Free';
      case DiscountType.zeroDeliveryFee:
        return '\$0 Delivery Fee';
      case DiscountType.spendMoreSaveMore:
        return 'Spend More, Save More';
      case DiscountType.saveOnMenuItems:
        return 'Save On Menu Items';
    }
  }
}

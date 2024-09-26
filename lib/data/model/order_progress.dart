import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../converters/date_time_converter.dart';

part 'order_progress.g.dart';

enum OrderStatus {
  cancel,
  pending,
  preparing,
  ready,
  deliveryInPorgress,
  completed,
}

extension OrderStatusExtension on OrderStatus {
  String toDisplayString() {
    switch (this) {
      case OrderStatus.cancel:
        return 'Cancelled';
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.completed:
        return 'Delivered';
      case OrderStatus.deliveryInPorgress:
        return 'Delivery in progress';
    }
  }
}

@JsonSerializable()
class OrderProgress extends Equatable {
  @DateTimeConverter()
  final DateTime timestamp;
  final OrderStatus status;

  const OrderProgress({
    required this.timestamp,
    required this.status,
  });

  @override
  List<Object?> get props => [timestamp, status];

  // JSON serialization
  factory OrderProgress.fromJson(Map<String, dynamic> json) =>
      _$OrderProgressFromJson(json);
  Map<String, dynamic> toJson() => _$OrderProgressToJson(this);

  // Firestore serialization
  Map<String, dynamic> toFirestore() {
    return {
      'timestamp': Timestamp.fromDate(timestamp),
      'status': status.toString().split('.').last,
    };
  }

  factory OrderProgress.fromFirestore(Map<String, dynamic> data) {
    final statusString = data['status'] as String?;
    final orderStatus = statusString != null
        ? OrderStatus.values.firstWhere(
            (s) => s.toString().split('.').last == statusString,
            orElse: () => OrderStatus.pending)
        : OrderStatus.pending;

    final timestampData = data['timestamp'];
    final timestamp =
        timestampData is Timestamp ? timestampData.toDate() : DateTime.now();

    return OrderProgress(
      timestamp: timestamp,
      status: orderStatus,
    );
  }

  OrderProgress copyWith({
    DateTime? timestamp,
    OrderStatus? status,
  }) {
    return OrderProgress(
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'OrderProgress(timestamp: $timestamp, status: ${status.toDisplayString()})';
  }
}

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../converters/date_time_converter.dart';

part 'location.g.dart';

@JsonSerializable()
class Location extends Equatable {
  final double latitude;
  final double longitude;
  @DateTimeConverter()
  final DateTime? timestamp;

  const Location({
    required this.latitude,
    required this.longitude,
    this.timestamp,
  });

  @override
  List<Object?> get props => [latitude, longitude, timestamp];

  // JSON serialization
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);

  // Override toString for easier debugging
  @override
  String toString() => 'Location(latitude: $latitude, longitude: $longitude, timestamp: $timestamp)';

  Location copyWith({
    double? latitude,
    double? longitude,
    DateTime? timestamp,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  factory Location.fromFirestore(Map<String, dynamic> data) {
    return Location(
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      timestamp: data['timestamp'] is Timestamp
          ? (data['timestamp'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      if (timestamp != null) 'timestamp': Timestamp.fromDate(timestamp!),
    };
  }
}
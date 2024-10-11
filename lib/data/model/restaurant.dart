import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'restaurant.g.dart';

@JsonSerializable()
class Restaurant extends Equatable {
  final String? id;
  final String? name;
  final bool setupCompleted;
  final bool verified;
  // Add any other fields relevant to the restaurant

  const Restaurant(
      {this.id, this.name, this.setupCompleted = false, this.verified = false});

  @override
  List<Object?> get props => [
        id,
        name,
        setupCompleted,
        verified
        // Include other fields in props
      ];

  Restaurant copyWith(
      {String? id, String? name, bool? setupCompleted, bool? verified
      // Include other fields
      }) {
    return Restaurant(
        id: id ?? this.id,
        name: name ?? this.name,
        setupCompleted: setupCompleted ?? this.setupCompleted,
        verified: verified ?? this.verified
        // Copy other fields
        );
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  factory Restaurant.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data()!;
    return Restaurant(
      id: snapshot.id,
      name: data['name'] as String?,
      setupCompleted: data['setupCompleted'] as bool? ?? false,
      verified: data['verified'] as bool? ?? false,
      // Map other fields
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'setupCompleted': setupCompleted,
      'verified': verified
      // Include other fields
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final UserRole? role;
  final String? restaurantId;
  final List<String>? restaurantLocationIds;

  const User({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    required this.role,
    this.restaurantId,
    this.restaurantLocationIds,
  });

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    UserRole? role,
    String? restaurantId,
    List<String>? restaurantLocationIds,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantLocationIds: restaurantLocationIds ?? this.restaurantLocationIds,
    );
  }

  @override
  List<Object?> get props => [id, email, role, restaurantId];

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      role: UserRole.values
          .firstWhere((e) => e.toString() == 'UserRole.${data['role']}'),
      restaurantId: data['restaurantId'],
      restaurantLocationIds:
          List<String>.from(data['restaurantLocationIds'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role.toString().split('.').last,
      'restaurantId': restaurantId,
      'restaurantLocationIds': restaurantLocationIds,
    };
  }
}
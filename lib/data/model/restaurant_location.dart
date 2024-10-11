import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../models.dart';

part 'restaurant_location.g.dart';

@JsonSerializable()
class RestaurantLocation extends Equatable {
  final String? id;
  final String? restaurantId;
  final bool? primaryLocation;
  final String? name;
  final String? address;
  final String? imageUrl;
  final List<FoodCategory>? categories;
  final List<MenuCategory>? menuCategories;
  final List<MenuCategory>? itemCategories;
  final List<MenuItem>? menuItems;
  final List<WorkingHours>? workingHours;
  final double? deliveryFee;
  final List<String>? employeeIds;
  final double? averageRating;
  final int? reviewCount;

  const RestaurantLocation({
    this.id,
    this.restaurantId,
    this.primaryLocation = false,
    this.name,
    this.address,
    this.imageUrl,
    this.categories,
    this.menuCategories,
    this.itemCategories,
    this.menuItems,
    this.workingHours,
    this.deliveryFee,
    this.employeeIds,
    this.averageRating,
    this.reviewCount,
  });

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        primaryLocation,
        name,
        address,
        imageUrl,
        categories,
        menuCategories,
        itemCategories,
        menuItems,
        workingHours,
        deliveryFee,
        employeeIds,
        averageRating,
        reviewCount,
      ];

  RestaurantLocation copyWith({
    String? id,
    String? restaurantId,
    bool? primaryLocation,
    String? name,
    String? address,
    String? imageUrl,
    List<FoodCategory>? categories,
    List<MenuCategory>? menuCategories,
    List<MenuCategory>? itemCategories,
    List<MenuItem>? menuItems,
    List<WorkingHours>? workingHours,
    double? deliveryFee,
    List<String>? employeeIds,
    double? averageRating,
    int? reviewCount,
  }) {
    return RestaurantLocation(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      primaryLocation: primaryLocation ?? this.primaryLocation,
      name: name ?? this.name,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      menuCategories: menuCategories ?? this.menuCategories,
      itemCategories: itemCategories ?? this.itemCategories,
      menuItems: menuItems ?? this.menuItems,
      workingHours: workingHours ?? this.workingHours,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      employeeIds: employeeIds ?? this.employeeIds,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  /// Returns whether the restaurant is currently open based on working hours.
  bool isCurrentlyOpen() {
    if (workingHours == null || workingHours!.isEmpty) {
      return false;
    }

    final now = DateTime.now();
    final currentDay = _getCurrentDay(now.weekday);
    final currentTime = TimeOfDay.fromDateTime(now);

    final todayHours = workingHours!.firstWhere(
      (hours) => hours.day.toLowerCase() == currentDay.toLowerCase(),
      orElse: () => const WorkingHours(
          id: '',
          day: '',
          openAt: TimeOfDay(hour: 0, minute: 0),
          closeAt: TimeOfDay(hour: 0, minute: 0),
          isOpen: false),
    );

    if (!todayHours.isOpen) {
      return false;
    }

    return _isTimeBetween(currentTime, todayHours.openAt, todayHours.closeAt);
  }

  /// Helper method to convert weekday integer to string.
  String _getCurrentDay(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  /// Helper method to check if a given time is between two times.
  bool _isTimeBetween(TimeOfDay time, TimeOfDay start, TimeOfDay end) {
    final now = _convertToMinutes(time);
    final opens = _convertToMinutes(start);
    final closes = _convertToMinutes(end);

    if (opens <= closes) {
      return now >= opens && now <= closes;
    } else {
      // Handles cases where closing time is on the next day
      return now >= opens || now <= closes;
    }
  }

  /// Converts `TimeOfDay` to total minutes since midnight.
  int _convertToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  /// Factory method for creating a `RestaurantLocation` from Firestore.
  factory RestaurantLocation.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('Document does not exist');
    }

    final restaurantId = snapshot.reference.parent.parent?.id;
    return RestaurantLocation(
      id: data['id'] as String?,
      restaurantId: restaurantId,
      primaryLocation: data['primaryLocation'] as bool?,
      name: data['name'] as String?,
      address: data['address'] as String?,
      imageUrl: data['imageUrl'] as String?,
      categories: (data['categories'] as List<dynamic>?)
          ?.map((e) => FoodCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      menuCategories: (data['menuCategories'] as List<dynamic>?)
          ?.map((e) => MenuCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      itemCategories: (data['itemCategories'] as List<dynamic>?)
          ?.map((e) => MenuCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      menuItems: (data['menuItems'] as List<dynamic>?)
          ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      workingHours: (data['workingHours'] as List<dynamic>?)
          ?.map((e) => WorkingHours.fromJson(e as Map<String, dynamic>))
          .toList(),
      deliveryFee: (data['deliveryFee'] as num?)?.toDouble(),
      employeeIds: (data['employeeIds'] as List<dynamic>?)?.cast<String>(),
      averageRating: (data['averageRating'] as num?)?.toDouble(),
      reviewCount: data['reviewCount'] as int?,
    );
  }

  /// Converts `RestaurantLocation` to a Firestore document.
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      if (primaryLocation != null) 'primaryLocation': primaryLocation,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (categories != null)
        'categories': categories!.map((e) => e.toJson()).toList(),
      if (menuCategories != null)
        'menuCategories': menuCategories!.map((e) => e.toFirestore()).toList(),
      if (itemCategories != null)
        'itemCategories': itemCategories!.map((e) => e.toFirestore()).toList(),
      if (menuItems != null)
        'menuItems': menuItems!.map((e) => e.toJson()).toList(),
      if (workingHours != null)
        'workingHours': workingHours!.map((e) => e.toJson()).toList(),
      if (deliveryFee != null) 'deliveryFee': deliveryFee,
      if (employeeIds != null) 'employeeIds': employeeIds,
      if (averageRating != null) 'averageRating': averageRating,
      if (reviewCount != null) 'reviewCount': reviewCount,
    };
  }
}

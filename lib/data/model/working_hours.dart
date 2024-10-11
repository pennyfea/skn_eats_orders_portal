import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../converters/time_of_day_converter.dart';

part 'working_hours.g.dart';

@JsonSerializable()
@TimeOfDayConverter()
class WorkingHours extends Equatable {
  final String id;
  final String day;
  final TimeOfDay openAt;
  final TimeOfDay closeAt;
  final bool isOpen;

  const WorkingHours({
    required this.id,
    required this.day,
    required this.openAt,
    required this.closeAt,
    required this.isOpen,
  });

  WorkingHours copyWith({
    String? id,
    String? day,
    TimeOfDay? openAt,
    TimeOfDay? closeAt,
    bool? isOpen,
  }) {
    return WorkingHours(
      id: id ?? this.id, 
      day: day ?? this.day, 
      openAt: openAt ?? this.openAt, 
      closeAt: closeAt ?? this.closeAt, 
      isOpen: isOpen ?? this.isOpen
    );
  }

  @override
  List<Object?> get props => [id, day, openAt, closeAt, isOpen];

  factory WorkingHours.fromJson(Map<String, dynamic> json) => _$WorkingHoursFromJson(json);
  Map<String, dynamic> toJson() => _$WorkingHoursToJson(this);

  factory WorkingHours.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data()!;
    return WorkingHours(
      id: snapshot.id,
      day: data['day'] as String,
      openAt: TimeOfDay(hour: data['openAt']['hour'] as int, minute: data['openAt']['minute'] as int),
      closeAt: TimeOfDay(hour: data['closeAt']['hour'] as int, minute: data['closeAt']['minute'] as int),
      isOpen: data['isOpen'] as bool,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'day': day,
      'openAt': {'hour': openAt.hour, 'minute': openAt.minute},
      'closeAt': {'hour': closeAt.hour, 'minute': closeAt.minute},
      'isOpen': isOpen,
    };
  }

  static List<WorkingHours> weekWorkingHours = [
    const WorkingHours(id: '1', day: 'Monday',    openAt: TimeOfDay(hour: 9, minute: 0), closeAt: TimeOfDay(hour: 17, minute: 0), isOpen: true),
    const WorkingHours(id: '2', day: 'Tuesday',   openAt: TimeOfDay(hour: 9, minute: 0), closeAt: TimeOfDay(hour: 17, minute: 0), isOpen: true),
    const WorkingHours(id: '3', day: 'Wednesday', openAt: TimeOfDay(hour: 9, minute: 0), closeAt: TimeOfDay(hour: 17, minute: 0), isOpen: true),
    const WorkingHours(id: '4', day: 'Thursday',  openAt: TimeOfDay(hour: 9, minute: 0), closeAt: TimeOfDay(hour: 17, minute: 0), isOpen: true),
    const WorkingHours(id: '5', day: 'Friday',    openAt: TimeOfDay(hour: 9, minute: 0), closeAt: TimeOfDay(hour: 17, minute: 0), isOpen: true),
    const WorkingHours(id: '6', day: 'Saturday',  openAt: TimeOfDay(hour: 10, minute: 0), closeAt: TimeOfDay(hour: 15, minute: 0), isOpen: true),
    const WorkingHours(id: '7', day: 'Sunday',    openAt: TimeOfDay(hour: 0, minute: 0), closeAt: TimeOfDay(hour: 0, minute: 0), isOpen: false),
  ];
}
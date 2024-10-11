// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'working_hours.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkingHours _$WorkingHoursFromJson(Map<String, dynamic> json) => WorkingHours(
      id: json['id'] as String,
      day: json['day'] as String,
      openAt: const TimeOfDayConverter().fromJson(json['openAt'] as String),
      closeAt: const TimeOfDayConverter().fromJson(json['closeAt'] as String),
      isOpen: json['isOpen'] as bool,
    );

Map<String, dynamic> _$WorkingHoursToJson(WorkingHours instance) =>
    <String, dynamic>{
      'id': instance.id,
      'day': instance.day,
      'openAt': const TimeOfDayConverter().toJson(instance.openAt),
      'closeAt': const TimeOfDayConverter().toJson(instance.closeAt),
      'isOpen': instance.isOpen,
    };

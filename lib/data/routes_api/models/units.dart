import 'package:json_annotation/json_annotation.dart';

part 'units.g.dart';

/// A set of values that specify the unit of measure used in the display.
@JsonEnum(alwaysCreate: true)
enum Units {
  /// Units of measure not specified.
  @JsonValue('UNITS_UNSPECIFIED')
  unspecified,

  /// Metric units of measure.
  @JsonValue('METRIC')
  metric,

  /// Imperial (English) units of measure.
  @JsonValue('IMPERIAL')
  imperial;

  String? toJson() => _$UnitsEnumMap[this];
}

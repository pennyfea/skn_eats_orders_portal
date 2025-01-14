import 'package:json_annotation/json_annotation.dart';

part 'latlng.g.dart';

/// An object that represents a latitude/longitude pair. This is expressed as a
/// pair of doubles to represent degrees latitude and degrees longitude. Unless
/// specified otherwise, this object must conform to the WGS84 standard. Values
/// must be within normalized ranges.
@JsonSerializable()
class LatLng {
  /// The latitude in degrees. It must be in the range [-90.0, +90.0].
  final double latitude;

  /// The longitude in degrees. It must be in the range [-180.0, +180.0].
  final double longitude;

  const LatLng({
    required this.latitude,
    required this.longitude,
  }) : assert(latitude >= -90.0 && latitude <= 90.0,
            'Latitude must be between -90 and 90 degrees.'),
        assert(longitude >= -180.0 && longitude <= 180.0,
            'Longitude must be between -180 and 180 degrees.');

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);

    /// Returns a new [LatLng] instance offset by the given [LatLng].
  /// Asserts that the operation does not cross the poles.
  LatLng offset(LatLng offset) {
    final double newLatitude = latitude + offset.latitude;
    assert(newLatitude >= -90.0 && newLatitude <= 90.0,
        'Latitude after applying offset must be between -90 and 90 degrees.');

    // Handle longitude wrap-around (across the 180th meridian)
    double newLongitude = longitude + offset.longitude;
    newLongitude = (newLongitude + 180) % 360 - 180;

    return LatLng(latitude: newLatitude, longitude: newLongitude);
  }

  /// Returns a new [LatLng] instance with the latitude and longitude negated.
  LatLng operator -() => LatLng(latitude: -latitude, longitude: -longitude);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatLng &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() => 'LatLng{latitude: $latitude, longitude: $longitude}';
}

import 'package:json_annotation/json_annotation.dart';

import '../routes_models.dart';

part 'route_matrix_destination.g.dart';

/// Represents a single destination for the `computeRouteMatrix` method.
@JsonSerializable()
class RouteMatrixDestination {
  /// Required. Destination waypoint.
  final Waypoint? waypoint;

  const RouteMatrixDestination({
    this.waypoint,
  });

  /// Creates a [RouteMatrixDestination] from longitude and latitude.
  factory RouteMatrixDestination.fromLatLng({
    required double longitude,
    required double latitude,
  }) =>
      RouteMatrixDestination(
        waypoint: Waypoint(
          location: Location(
            latLng: LatLng(
              latitude: latitude,
              longitude: longitude,
            ),
          ),
        ),
      );

  factory RouteMatrixDestination.fromJson(Map<String, dynamic> json) =>
      _$RouteMatrixDestinationFromJson(json);

  Map<String, dynamic> toJson() => _$RouteMatrixDestinationToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteMatrixDestination &&
          runtimeType == other.runtimeType &&
          waypoint == other.waypoint;

  @override
  int get hashCode => waypoint.hashCode;

  @override
  String toString() => 'RouteMatrixDestination{waypoint: $waypoint}';
}

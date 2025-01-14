// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_routes_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$GoogleRoutesService extends GoogleRoutesService {
  _$GoogleRoutesService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = GoogleRoutesService;

  @override
  Future<Response<Result<ComputeRouteResult>>> computeRoutes({
    required String apiKey,
    required String fieldMask,
    required Waypoint origin,
    required Waypoint destination,
    List<Waypoint>? intermediates,
    RouteTravelMode? travelMode,
    RoutingPreference? routingPreference,
    PolylineQuality? polylineQuality,
    PolylineEncoding? polylineEncoding,
    String? departureTime,
    String? arrivalTime,
    bool? computeAlternativeRoutes,
    RouteModifiers? routeModifiers,
    String? languageCode,
    String? regionCode,
    Units? units,
    bool? optimizeWaypointOrder,
    List<ReferenceRoute>? requestedReferenceRoutes,
    List<ExtraComputation>? extraComputations,
    TrafficModel? trafficModel,
    TransitPreferences? transitPreferences,
  }) {
    final Uri $url = Uri.parse('directions/v2:computeRoutes');
    final Map<String, String> $headers = {
      'X-Goog-Api-Key': apiKey,
      'X-Goog-FieldMask': fieldMask,
    };
    final $body = <String, dynamic>{
      'origin': origin,
      'destination': destination,
      'intermediates': intermediates,
      'travelMode': travelMode,
      'routingPreference': routingPreference,
      'polylineQuality': polylineQuality,
      'polylineEncoding': polylineEncoding,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'computeAlternativeRoutes': computeAlternativeRoutes,
      'routeModifiers': routeModifiers,
      'languageCode': languageCode,
      'regionCode': regionCode,
      'units': units,
      'optimizeWaypointOrder': optimizeWaypointOrder,
      'requestedReferenceRoutes': requestedReferenceRoutes,
      'extraComputations': extraComputations,
      'trafficModel': trafficModel,
      'transitPreferences': transitPreferences,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client
        .send<Result<ComputeRouteResult>, ComputeRouteResult>($request);
  }
}

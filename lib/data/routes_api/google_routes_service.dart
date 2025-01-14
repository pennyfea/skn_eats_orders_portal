import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'google_routes_model_converter.dart';
import 'model_response.dart';
import 'routes_models.dart';

part 'google_routes_service.chopper.dart';

@ChopperApi()
abstract class GoogleRoutesService extends ChopperService {
  @Post(path: 'directions/v2:computeRoutes')
  Future<Response<Result<ComputeRouteResult>>> computeRoutes({
    @Header("X-Goog-Api-Key") required String apiKey,
    @Header("X-Goog-FieldMask") required String fieldMask,
    @Field() required Waypoint origin,
    @Field() required Waypoint destination,
    @Field() List<Waypoint>? intermediates,
    @Field() RouteTravelMode? travelMode,
    @Field() RoutingPreference? routingPreference,
    @Field() PolylineQuality? polylineQuality,
    @Field() PolylineEncoding? polylineEncoding,
    @Field() String? departureTime,
    @Field() String? arrivalTime,
    @Field() bool? computeAlternativeRoutes,
    @Field() RouteModifiers? routeModifiers,
    @Field() String? languageCode,
    @Field() String? regionCode,
    @Field() Units? units,
    @Field() bool? optimizeWaypointOrder,
    @Field() List<ReferenceRoute>? requestedReferenceRoutes,
    @Field() List<ExtraComputation>? extraComputations,
    @Field() TrafficModel? trafficModel,
    @Field() TransitPreferences? transitPreferences,
  });

  static GoogleRoutesService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse(dotenv.get('GOOGLE_ROUTES_URL')),
      interceptors: [HttpLoggingInterceptor()],
      converter: GoogleRoutesModelConverter(),
      errorConverter: const JsonConverter(),
      services: [_$GoogleRoutesService()],
    );
    return _$GoogleRoutesService(client);
  }
}

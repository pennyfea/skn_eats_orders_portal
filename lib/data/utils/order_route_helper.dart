import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import '../models.dart' hide Location;
import '../routes_api/google_routes_service.dart';
import '../routes_api/model_response.dart';
import '../routes_api/routes_models.dart';

extension OrderRouteHelper on CustomerOrder {
   static var logger = Logger(printer: PrettyPrinter());

Future<Map<String, dynamic>?> computeRoute(double driverLatitude, double driverLongitude) async {
    if (userLocation == null) {
      return null;
    }

    // Create the Google Routes service instance
    final googleRoutesService = GoogleRoutesService.create();
    try {
      // Make the API request
      final response = await googleRoutesService.computeRoutes(
          apiKey: dotenv.get('GOOGLE_API_KEY'),
          fieldMask:
              'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
          origin: Waypoint(
            location: Location(
              latLng: LatLng(
                latitude: driverLatitude,
                longitude: driverLongitude,
              ),
            ),
          ),
          destination: Waypoint(
            location: Location(
              latLng: LatLng(
                latitude: storeLocation!.latitude,
                longitude: storeLocation!.longitude,
              ),
            ),
          ),
          units: Units.metric,
          travelMode: RouteTravelMode.drive,
          polylineEncoding: PolylineEncoding.encodedPolyline);

      if (response.isSuccessful && response.body != null) {
        final result = response.body;
        final route = (result as Success<ComputeRouteResult>).value;

        if (route.routes != null && route.routes!.isNotEmpty) {
          return {
            'total_distance': route.routes!.first.distanceMeters,
            'total_duration':
                int.parse(route.routes!.first.duration!.replaceAll('s', '')),
            'encoded_polyline': route.routes!.first.polyline!.encodedPolyline,
          };
        }
      } else {
        logger.w('Failed to fetch route: ${response.error}');
      }
    } catch (e) {
      logger.w('Error fetching route: $e');
    }
    return null;
  }
}

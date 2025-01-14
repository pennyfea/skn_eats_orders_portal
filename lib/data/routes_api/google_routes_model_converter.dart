import 'dart:convert';

import 'package:chopper/chopper.dart';

import 'model_response.dart';
import 'routes_models.dart';

class GoogleRoutesModelConverter implements Converter {
  @override
  Request convertRequest(Request request) {
    final req =
        applyHeader(request, contentTypeKey, jsonHeaders, override: false);
    return encodeJson(req);
  }

  Request encodeJson(Request request) {
    final contentType = request.headers[contentTypeKey];
    if (contentType != null && contentType.contains(jsonHeaders)) {
      return request.copyWith(body: json.encode(request.body));
    }
    return request;
  }

  Response<BodyType> decodeJson<BodyType, InnerType>(Response response) {
    final contentType = response.headers[contentTypeKey];
    var body = response.body;
    if (contentType != null && contentType.contains(jsonHeaders)) {
      body = utf8.decode(response.bodyBytes);
    }

    try {
      final mapData = json.decode(body);

      // Check if `fallbackInfo` is present and has a `reason`
      if (mapData['fallbackInfo'] != null) {
        final fallbackInfo = FallbackInfo.fromJson(mapData['fallbackInfo']);

        if (fallbackInfo.reason == FallbackReason.serverError) {
          // Return an Error if the fallback reason is SERVER_ERROR
          return response.copyWith<BodyType>(
            body: Error(Exception('Server error: ${fallbackInfo.reason}'))
                as BodyType,
          );
        }
      }

      // If no error, parse and return the success result
      final computeRoutesQuery = ComputeRouteResult.fromJson(mapData);
      return response.copyWith<BodyType>(
        body: Success(computeRoutesQuery) as BodyType,
      );
    } catch (e) {
      chopperLogger.warning(e);
      return response.copyWith<BodyType>(
        body: Error(e as Exception) as BodyType,
      );
    }
  }

  @override
  Response<BodyType> convertResponse<BodyType, InnerType>(Response response) {
    return decodeJson<BodyType, InnerType>(response);
  }
}

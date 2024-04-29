import 'package:final_year/key.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directions {
  static const String _baseURL = 'https://maps.googleapis.com/maps/api/directions/json?';
  
  get polylinePoints => null;

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseURL,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': googleAPIKey,
      },
    );
    // check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
  
  static Null fromMap(data) {}
}

class DirectionsModel {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  const DirectionsModel ({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory DirectionsModel.fromMap(Map<String, dynamic>map) {

    // get route information
    final data = Map<String, dynamic>.from(map['routes'] [0]);

    // bounds
    final northeast = data['bounds'] ['northeast'];
    final southwest = data['bounds'] ['southwest'];
    final bounds = LatLngBounds(
      southwest: LatLng(southwest['lat'], southwest['lng']), 
      northeast: LatLng(northeast['lat'], northeast['lng']),
    );    

    // distance & duration
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'] [0];
      distance = leg['distance'] ['text'];
      duration = leg['duration'] ['text'];
    }

    return DirectionsModel(
      bounds: bounds, 
      polylinePoints: 
        PolylinePoints().decodePolyline(data['overview_polyline']['points']), 
      totalDistance: distance, 
      totalDuration: duration,
    );
  }
}

mixin PointLatLng {
}
  var _dio;

PolylinePoints() {
}
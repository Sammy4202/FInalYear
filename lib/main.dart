import 'package:final_year/directions.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traffic App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class TrafficMapPage extends StatefulWidget {
  const TrafficMapPage({super.key});

  @override
  _TrafficMapPageState createState() => _TrafficMapPageState();
}

class _TrafficMapPageState extends State<TrafficMapPage> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // Default location (San Francisco)
    zoom: 12.0,
  );
          
  late GoogleMapController _mapController;
  late Marker _origin;
  late Marker _destination;
  late Directions _info;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
  setState(() {
    _mapController = controller;
  });
  
  // Example: Zoom in to a specific location
  _mapController.animateCamera(CameraUpdate.newLatLngZoom(const LatLng(37.7749, -122.4194), 12.0));
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Google Maps'),
        actions: [
          if (_origin != Null)
            TextButton(
              onPressed: () => _mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin.position,
                    zoom: 15,
                    tilt: 50,
                  ),
                ),
              ), 
              style: TextButton.styleFrom(
                foregroundColor: Colors.green, 
                textStyle: const TextStyle(fontWeight: FontWeight.w600)
              ),
              child: const Text('ORIGIN')
            ),
          // ignore: unrelated_type_equality_checks
          if (_destination != Null)
            TextButton(
              onPressed: () => _mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination.position,
                    zoom: 15,
                    tilt: 50,
                  ),
                ),
              ), 
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, 
                textStyle: const TextStyle(fontWeight: FontWeight.w600)
              ),
              child: const Text('DEST')
            )
        ],
      ),
      body: GoogleMap(
        onMapCreated: (controller) => _mapController = controller,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        markers: {
          if (_origin != Null) _origin,
          if (_destination != Null) _destination
        },
        polylines: {
          Polyline(
            polylineId: const PolylineId('overview_polyline'),
            color: Colors.red,
            width: 5,
            points: _info.polylinePoints
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList(),
          ),
        },
        onLongPress: _addMarker,
      ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black,
          onPressed: () => _mapController.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition),
            ),
            child: const Icon(Icons.center_focus_strong),
      ),
    ); 
  }

  void _addMarker(LatLng pos) async {
    if (_origin == Null || (_origin != Null && _destination != Null)) {
      // origin is not set or Origin/Destination are both set
      // set origin
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        // reset destination
        _destination == Null;

        // reset info
        _info == Null;
      });
    } else {
      // origin is already set
      // set destination
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // get directions
      final directions = await Directions()
          .getDirections(origin: _origin.position, destination: pos);
      setState(() {
        if (directions != null) {
          _info = directions; // Safe assignment if directions is not null
        } else {
        // Handle the case where directions is null (e.g., show an error)
        }
      });
    }
  }
}
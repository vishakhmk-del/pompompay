import 'dart:convert';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:pompompay/core/hook/hooks.dart';
import 'package:sizer/sizer.dart';

class _StopMarker extends fmap.Marker {
  final Stop stop;

  _StopMarker({required this.stop})
      : super(
          point: LatLng(double.parse(stop.latitude!), double.parse(stop.longitude!)),
          width: 30,
          height: 30,
          child: const Icon(Icons.location_on, color: Colors.orange, size: 25),
        );
}

class ScreenMapTrack extends StatefulWidget {
  const ScreenMapTrack({super.key, required this.stoploc});
  final Farereq stoploc;

  @override
  State<ScreenMapTrack> createState() => _ScreenMapTrackState();
}

class _ScreenMapTrackState extends State<ScreenMapTrack> {
  final fmap.MapController _mapController = fmap.MapController();
  final PopupController _popupLayerController = PopupController();

  bool isLoading = true;
  bool _isMapReady = false;

  List<LatLng> _routePoints = [];
  LatLng? _starting;
  LatLng? _destination;
  List<Stop> stops = [];
  List<fmap.Marker> _popupMarkers = [];
  BusLocation? busLocation;
  Timer? _busLocationTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    Livelocationfun.instance.startTracking(
      context: context,
      onLocationUpdate: (position) {
        if (position.latitude != 0 && position.longitude != 0) {
          setState(() => isLoading = false);
        }
      },
    );

    final stopValue = await SearchFun.instance.fetchStopLoc(widget.stoploc, context);
    stops = stopValue?.stops ?? [];
    busLocation = stopValue?.busLocation;

    List<LatLng> points = stops
        .map((s) => LatLng(double.parse(s.latitude!), double.parse(s.longitude!)))
        .toList();

    if (points.isNotEmpty) {
      _starting = points.first;
      _destination = points.last;
      _routePoints = points;
      await _fetchRoute(points);
    }

    _buildMarkers();
    setState(() {});

    // Start 3-second periodic bus location update
    _busLocationTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _fetchBusLiveLocation();
    });
  }

  void _buildMarkers() {
    _popupMarkers = [
      if (_starting != null)
        fmap.Marker(
          point: _starting!,
          width: 30,
          height: 30,
          child: const Icon(Icons.flag, color: Colors.green, size: 35),
        ),
      for (int i = 1; i < stops.length - 1; i++) _StopMarker(stop: stops[i]),
      if (_destination != null)
        fmap.Marker(
          point: _destination!,
          width: 30,
          height: 30,
          child: const Icon(Icons.location_on, color: Colors.red, size: 35),
        ),
      if (busLocation?.latitude != null && busLocation?.longitude != null)
        fmap.Marker(
          key: const ValueKey('bus_marker'),
          point: LatLng(
            double.parse(busLocation!.latitude!),
            double.parse(busLocation!.longitude!),
          ),
          width: 32,
          height: 32,
          child: const Icon(Icons.directions_bus_filled, color: Colors.indigo, size: 32),
        ),
    ];
  }

  Future<void> _fetchRoute(List<LatLng> points) async {
    final coords = points.map((p) => '${p.longitude},${p.latitude}').join(';');
    final url = Uri.parse(
      'http://router.project-osrm.org/route/v1/driving/$coords'
      '?overview=full&geometries=polyline',
    );
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      final geometry = data['routes']?[0]['geometry'];
      if (geometry != null) {
        final decoded = PolylinePoints().decodePolyline(geometry);
        _routePoints =
            decoded.map((pt) => LatLng(pt.latitude, pt.longitude)).toList();

        setState(() {
          _isMapReady = false;
        });
      }
    }
  }

  Future<void> _fetchBusLiveLocation() async {
    final updatedBusLocation =
        await SearchFun.instance.fetchLiveBusLoc(widget.stoploc, context);
    if (updatedBusLocation != null &&
        updatedBusLocation.latitude != null &&
        updatedBusLocation.longitude != null) {
      busLocation = updatedBusLocation.busLocation;

      final updatedPosition = LatLng(
        double.parse(busLocation!.latitude!),
        double.parse(busLocation!.longitude!),
      );

      _popupMarkers.removeWhere((m) => m.key == const ValueKey('bus_marker'));

      _popupMarkers.add(
        fmap.Marker(
          key: const ValueKey('bus_marker'),
          point: updatedPosition,
          width: 32,
          height: 32,
          child: const Icon(Icons.directions_bus_filled, color: Colors.indigo, size: 32),
        ),
      );

      setState(() {});
    }
  }

  @override
  void dispose() {
    _busLocationTimer?.cancel();
    Livelocationfun.instance.stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isMapReady && _routePoints.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration.zero, () {
          final bounds = fmap.LatLngBounds.fromPoints(_routePoints);
          _mapController.fitCamera(
            fmap.CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
          );
          _isMapReady = true;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tracking',
          style: TextStyle(
            fontFamily: 'Poppins-Medium',
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          textScaler: TextScaler.noScaling,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : fmap.FlutterMap(
              mapController: _mapController,
              options: fmap.MapOptions(
                initialCenter: _starting ?? LatLng(0, 0),
                initialZoom: 15,
                minZoom: 5,
                maxZoom: 18,
                onTap: (_, __) => _popupLayerController.hideAllPopups(),
              ),
              children: [
                fmap.TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                if (_routePoints.isNotEmpty)
                  fmap.PolylineLayer(
                    polylines: [
                      fmap.Polyline(
                        points: _routePoints,
                        color: Colors.blue,
                        strokeWidth: 4,
                      ),
                    ],
                  ),
                PopupMarkerLayer(
                  options: PopupMarkerLayerOptions(
                    markers: _popupMarkers,
                    popupController: _popupLayerController,
                    popupDisplayOptions: PopupDisplayOptions(
                      builder: (BuildContext context, fmap.Marker marker) {
                        if (marker is _StopMarker) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(marker.stop.stopName ?? 'N/A'),
                                  const SizedBox(height: 4),
                                  Text('Arriving: ${marker.stop.arrivingTime ?? 'N/A'}'),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                const CurrentLocationLayer(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mapController.move(
          _routePoints.firstOrNull ?? LatLng(0, 0),
          14,
        ),
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

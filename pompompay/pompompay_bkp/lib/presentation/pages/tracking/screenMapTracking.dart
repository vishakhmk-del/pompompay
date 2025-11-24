import 'dart:convert';
import 'dart:developer';
import 'package:flutter_map/flutter_map.dart' as fmap;
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:pompompay/core/hook/hooks.dart';
import 'package:pompompay/infrastructure/model/search/stoploc_resp/bus.dart';
import 'package:sizer/sizer.dart';

// ------------------- STOP MARKER ------------------- //
class _StopMarker extends fmap.Marker {
  final Stop stop;
  final Farereq stoploc;

  _StopMarker({required this.stop, required this.stoploc})
    : super(
        point: LatLng(
          double.parse(stop.latitude!),
          double.parse(stop.longitude!),
        ),
        width: 40,
        height: 40,
        child:
            stop.stopName == stoploc.to
                ? Image.asset(
                  'assets/image/tracking/Untitled_design__7_-removebg-preview.png',
                  width: 40,
                  height: 40,
                )
                : const Icon(Icons.my_location, color: Colors.red, size: 25),
      );
}

// ------------------- BUS MARKER ------------------- //
class _BusMarker extends fmap.Marker {
  final BusLocation bus;
  final BusValue busdet;
  final Farereq stoploc;

  _BusMarker({required this.bus,required this.busdet,required this.stoploc})
    : super(
        key: const ValueKey('bus_marker'),
        point: LatLng(
          double.parse(bus.latitude!),
          double.parse(bus.longitude!),
        ),
        width: 40,
        height: 40,
        child: Image.asset(
          'assets/image/tracking/Untitled_design__8_-removebg-preview.png',
          width: 40,
          height: 40,
        ),
      );
}

// ------------------- MAIN SCREEN ------------------- //
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
  // bool _isUserInteracting = false;
  bool _showRecenter = false;
  LatLng? _lastBusPos;
  bool isStopFetch = false;
// bool _hasAutoCenteredOnce = false;
  List<LatLng> _routePoints = [];
  LatLng? _starting;
  List<Stop> stops = [];
  List<fmap.Marker> _popupMarkers = [];
  BusLocation? busLocation;
  BusValue? bus;
DataList? stopValue;
  Timer? _busLocationTimer;
bool _showStartButton = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize(context));
  }

  Future<void> _initialize(BuildContext context) async {
    Livelocationfun.instance.startTracking(
      context: context,
      onLocationUpdate: (position) async {
        if (position.latitude != 0 && position.longitude != 0) {
          if (!mounted) return;
          setState(() => isLoading = false);
        if (!isStopFetch) {
            isStopFetch = true; // Set the flag to true after the first call
             stopValue = await SearchFun.instance.fetchStopLoc(widget.stoploc,context);
             stops = stopValue?.stops ?? [];
          busLocation = stopValue?.busLocation;
          bus=stopValue?.bus;
          List<LatLng> points =
              stops
                  .map(
                    (s) => LatLng(
                      double.parse(s.latitude!),
                      double.parse(s.longitude!),
                    ),
                  )
                  .toList();

          if (points.isNotEmpty) {
            _starting = points.first;
            _routePoints = points;
            await _fetchRoute(points);
          }

          _buildMarkers();

          // --- Show nearest stop popup initially ---
          if (busLocation != null && _popupMarkers.isNotEmpty) {
            final Distance hv = const Distance();
            LatLng busPos = LatLng(
              double.parse(busLocation!.latitude!),
              double.parse(busLocation!.longitude!),
            );

            int? nearestDist;
            _StopMarker? nearestStopMarker;

            for (final m in _popupMarkers) {
              if (m is _StopMarker) {
                final d = hv(m.point, busPos).round();
                if (nearestDist == null || d < nearestDist) {
                  nearestDist = d;
                  nearestStopMarker = m;
                }
              }
            }

            if (nearestStopMarker != null) {
              // Show popup for the nearest stop
              _popupLayerController.showPopupsOnlyFor([nearestStopMarker]);
            }
          }

            if(widget.stoploc.status=="0"){
              if(!context.mounted)return;
                alertTracking(context);
            }else if(widget.stoploc.status=="1"){
              if (!mounted) return;
              setState(() {});
              _busLocationTimer = Timer.periodic(const Duration(seconds:3), (_) {
                _fetchBusLiveLocation(context);
              });
            }
          }
   
        }

      },
    );
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
      for (int i = 0; i < stops.length; i++)
        _StopMarker(stop: stops[i], stoploc: widget.stoploc),
      if (busLocation?.latitude != null && busLocation?.longitude != null)
        _BusMarker(bus: busLocation!,busdet: bus!, stoploc: widget.stoploc),
    ];
  }

  Future<void> _fetchRoute(List<LatLng> points) async {
    final coords = points.map((e) => '${e.longitude},${e.latitude}').join(';');
    final url = Uri.parse(
      'http://117.221.68.183:5000/route/v1/driving/$coords?overview=full&geometries=geojson',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final geometry = data['routes'][0]['geometry'];
      final List<LatLng> polylinePoints = List<LatLng>.from(
        geometry['coordinates'].map((coord) => LatLng(coord[1], coord[0])),
      );

      setState(() {
        _routePoints = polylinePoints;
        _isMapReady = false;
      });
    } else {
      log('Failed to fetch route');
      throw Exception('Failed to fetch route');
    }
  }

  Future<void> _fetchBusLiveLocation(BuildContext context) async {
    final updated = await SearchFun.instance.fetchLiveBusLoc(
      widget.stoploc,
      context,
    );
    if (!mounted) return;

    final double busLat, busLng;
    if (updated != null &&
        updated.latitude != null &&
        updated.longitude != null) {
      busLocation = updated;
      busLat = double.parse(updated.latitude!);
      busLng = double.parse(updated.longitude!);
    } else if (_starting != null) {
      busLat = _starting!.latitude;
      busLng = _starting!.longitude;
    } else {
      return;
    }
    _lastBusPos = LatLng(busLat, busLng);

    _popupMarkers.removeWhere((m) => m.key == const ValueKey('bus_marker'));
    if (busLocation != null) {
      _popupMarkers.add(_BusMarker(bus: busLocation!,busdet: bus!, stoploc: widget.stoploc));
    }
      final Distance hv = const Distance();
      int? nearestDist;
      _StopMarker? nearestStopMarker;

      for (final m in _popupMarkers) {
        if (m is _StopMarker) {
          final d = hv(m.point, _lastBusPos!).round(); // metres
          if (nearestDist == null || d < nearestDist) {
            nearestDist = d;
            nearestStopMarker = m;
          }
        }
      }

      // threshold ≈ 200 m
      if (nearestStopMarker != null && nearestDist! < 200) {
        // Show ONLY that stop’s popup
        _popupLayerController.showPopupsOnlyFor([nearestStopMarker]);
      } else {
        _popupLayerController.hideAllPopups();
      }

    // if (!_isUserInteracting) {
    //   _mapController.move(_lastBusPos!, 15);
    // }
    // if (!_isUserInteracting && !_hasAutoCenteredOnce) {
    //     _mapController.move(_lastBusPos!, 15);
    //     _hasAutoCenteredOnce = true;
    //   }


    if (mounted) setState(() {});
  }

  void _recenterMap() {
    if (busLocation != null &&
        busLocation!.latitude != null &&
        busLocation!.longitude != null) {
      final position = LatLng(
        double.parse(busLocation!.latitude!),
        double.parse(busLocation!.longitude!),
      );
      _mapController.move(position, 15);
      // _isUserInteracting = false;
      // _hasAutoCenteredOnce = true; 
      setState(() => _showRecenter = false);
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
            fmap.CameraFit.bounds(
              bounds: bounds,
              padding: const EdgeInsets.all(50),
            ),
          );
          _isMapReady = true;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  fmap.FlutterMap(
                    mapController: _mapController,
                    options: fmap.MapOptions(
                      initialCenter: _starting ?? LatLng(0, 0),
                      initialZoom: 15,
                      minZoom: 5,
                      maxZoom: 18,
                      onTap: (_, __) => _popupLayerController.hideAllPopups(),
                      onPositionChanged: (position, hasGesture) {
                        if (hasGesture) {
                          // _isUserInteracting = true;
                          if (!_showRecenter) {
                            setState(() => _showRecenter = true);
                          }
                        }
                      },
                    ),
                    children: [
                      fmap.TileLayer(
                        urlTemplate:
                            'http://117.221.68.183:7001/tile/{z}/{x}/{y}.png',
                        tileProvider: NetworkTileProvider(),
                        errorTileCallback: (tile, error, stackTrace) {
                          debugPrint('Tile load error: $error │ $tile');
                          log('Tile load error: $error │ $tile');
                        },
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
                            builder: (
                              BuildContext context,
                              fmap.Marker marker,
                            ) {
                              // ----- STOP MARKER POPUP ----- //
                              if (marker is _StopMarker) {
                                int? dist;
                                if (_lastBusPos != null) {
                                  dist =
                                      const Distance()
                                          .call(marker.point, _lastBusPos!)
                                          .round();
                                }
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(marker.stop.stopName ?? 'N/A'),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Arriving: ${marker.stop.arrivingTime ?? 'N/A'}',
                                        ),
                                        if (dist != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            'Distance ≈ $dist m away',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              }

                              // ----- BUS MARKER POPUP ----- //
                              if (marker is _BusMarker) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(marker.busdet.busName?.toUpperCase() ?? 'Bus',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text(
                                            'Reg No: ${marker.busdet.registrationNo ?? 'N/A'}'),
                                        const SizedBox(height: 4),
                                        Text(
                                            '${marker.busdet.fromStation} → ${marker.busdet.toStation}'),
                                        const SizedBox(height: 4),
                                        Text(
                                            '(${marker.busdet.startTime ?? 'N/A'}-${marker.busdet.endTime ?? 'N/A'})'),
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
                  if (_showRecenter)
                    Positioned(
                      bottom: 90,
                      right: 16,
                      child: FloatingActionButton(backgroundColor: Colors.blue,
                        heroTag: 'recenter',
                        mini: true,
                        onPressed: _recenterMap,
                        child: const Icon(Icons.center_focus_strong,color: Colors.white,),
                      ),
                    ),
                    if (_showStartButton && widget.stoploc.status=="1")
                        Positioned(
                          bottom: 30,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              icon: const Icon(Icons.play_arrow, color: Colors.white),
                              label: const Text(
                                'Start Tracking',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: () {
                                
                               setState(() {
                                  _showStartButton = false;
                                });
                                if (busLocation != null &&
                                    busLocation!.latitude != null &&
                                    busLocation!.longitude != null) {
                                  final position = LatLng(
                                    double.parse(busLocation!.latitude!),
                                    double.parse(busLocation!.longitude!),
                                  );
                                  _mapController.move(position, 15);
                                  _lastBusPos = position;
                                }
                              },
                            ),
                          ),
                        ),

                ],
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        heroTag: 'mylocation',
        onPressed:
            () => _mapController.move(
              _routePoints.isNotEmpty ? _routePoints.first : LatLng(0, 0),
              14,
            ),
        child: const Icon(Icons.my_location,color: Colors.white,),
      ),
    );
  }
}
 Future<void> alertTracking(
    BuildContext originalContext,
  ) async {
    if (!originalContext.mounted) return;

    showDialog(
      context: originalContext,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                              Icons.warning,
                              color: Colors.amber,
                              size: 35,
                            ),
                        const SizedBox(width: 8),
                        Text(
                          "Alert",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Tracking unavailable: The selected trip is either not started or has been completed",
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                backgroundColor: const Color(0xffffa600),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed:() async {
                                        Navigator.pop(context);
                                       
                                      },
                              child: Text(
                                "Ok",
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                       
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter_map/flutter_map.dart' as fmap;
// import 'package:flutter_map/flutter_map.dart';
// import 'package:http/http.dart' as http;
// import 'package:latlong2/latlong.dart';
// import 'package:pompompay/core/hook/hooks.dart';
// import 'package:sizer/sizer.dart';

// class _StopMarker extends fmap.Marker {
//   final Stop stop;
//   final Farereq stoploc;

//   _StopMarker({required this.stop,required this.stoploc})
//       : super(
//           point: LatLng(double.parse(stop.latitude!), double.parse(stop.longitude!)),
//         width: 40,
//         height: 40,
//         child:stop.stopName == stoploc.to ? Image.asset(
//                   'assets/image/tracking/Untitled_design__7_-removebg-preview.png',
//                   width: 40,
//                   height: 40,
//                 ):Icon(
//                   Icons.my_location,
//                   color:  Colors.red,
//                   size: 25,
//                 ),

//         );
// }
// class _BusMarker extends fmap.Marker {
//   final BusLocation bus;
//   final Farereq stoploc;

//   _BusMarker({
//     required this.bus,
//     required this.stoploc,
//   }) : super(
//           key: const ValueKey('bus_marker'),
//           point: LatLng(double.parse(bus.latitude!), double.parse(bus.longitude!)),
//           width: 40,
//           height: 40,
//           child: Image.asset(
//             'assets/image/tracking/Untitled_design__8_-removebg-preview.png',
//             width: 40,
//             height: 40,
//           ),
//         );
// }

// class ScreenMapTrack extends StatefulWidget {
//   const ScreenMapTrack({super.key, required this.stoploc});
//   final Farereq stoploc;

//   @override
//   State<ScreenMapTrack> createState() => _ScreenMapTrackState();
// }
// class _ScreenMapTrackState extends State<ScreenMapTrack> {
//   final fmap.MapController _mapController = fmap.MapController();
//   final PopupController _popupLayerController = PopupController();

//   bool isLoading = true;
//   bool _isMapReady = false;
//   bool _isUserInteracting = false;
//   bool _showRecenter = false;
//   LatLng? _lastBusPos;   // ← new

//   List<LatLng> _routePoints = [];
//   LatLng? _starting;
//   List<Stop> stops = [];
//   List<fmap.Marker> _popupMarkers = [];
//   BusLocation? busLocation;
//   Timer? _busLocationTimer;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _initialize(context));
//   }

//   Future<void> _initialize(BuildContext context) async {
//     Livelocationfun.instance.startTracking(
//       context: context,
//       onLocationUpdate: (position) async {
//         if (position.latitude != 0 && position.longitude != 0) {
//           if (!mounted) return;
//           setState(() => isLoading = false);

//           final stopValue = await SearchFun.instance.fetchStopLoc(widget.stoploc, context);
//           stops = stopValue?.stops ?? [];
//           busLocation = stopValue?.busLocation;

//           List<LatLng> points = stops
//               .map((s) => LatLng(double.parse(s.latitude!), double.parse(s.longitude!)))
//               .toList();

//           if (points.isNotEmpty) {
//             _starting = points.first;
//             _routePoints = points;
//             await _fetchRoute(points);
//           }

//           _buildMarkers();

//           if (!mounted) return;
//           setState(() {});

//           _busLocationTimer = Timer.periodic(const Duration(seconds: 3), (_) {
//             _fetchBusLiveLocation(context);
//           });
//         }
//       },
//     );
//   }

//   void _buildMarkers() {
//     _popupMarkers = [
//       if (_starting != null)
//         fmap.Marker(
//           point: _starting!,
//           width: 30,
//           height: 30,
//           child: const Icon(Icons.flag, color: Colors.green, size: 35),
//         ),
//       for (int i = 0; i < stops.length; i++)
//         _StopMarker(stop: stops[i], stoploc: widget.stoploc),
//       if (busLocation?.latitude != null && busLocation?.longitude != null)
//         fmap.Marker(
//           key: const ValueKey('bus_marker'),
//           point: LatLng(
//             double.parse(busLocation!.latitude!),
//             double.parse(busLocation!.longitude!),
//           ),
//           width: 40,
//           height: 40,
//           child: Image.asset(
//             'assets/image/tracking/Untitled_design__8_-removebg-preview.png',
//             width: 40,
//             height: 40,
//           ),
//         ),
//     ];
//   }
// // Future<void> _fetchRoute(List<LatLng> points) async {
// //     final coords = points.map((p) => '${p.longitude},${p.latitude}').join(';');
// //     final url = Uri.parse(
// //       'http://router.project-osrm.org/route/v1/driving/$coords'
// //       '?overview=full&geometries=polyline',
// //     );
// //     final resp = await http.get(url);
// //     if (resp.statusCode == 200) {
// //       final data = json.decode(resp.body);
// //       final geometry = data['routes']?[0]['geometry'];
// //       if (geometry != null) {
// //         final decoded = PolylinePoints().decodePolyline(geometry);
// //         _routePoints =
// //             decoded.map((pt) => LatLng(pt.latitude, pt.longitude)).toList();

// //         setState(() {
// //           _isMapReady = false;
// //         });
// //       }
// //     }
// //   }
// Future<void> _fetchRoute(List<LatLng> points) async {
//   final coords = points.map((e) => '${e.longitude},${e.latitude}').join(';');
//   final url = Uri.parse(
//     'http://117.221.68.183:5000/route/v1/driving/$coords?overview=full&geometries=geojson',
//   );

//   final response = await http.get(url);
//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     final geometry = data['routes'][0]['geometry'];
//     final List<LatLng> polylinePoints = List<LatLng>.from(
//       geometry['coordinates'].map((coord) => LatLng(coord[1], coord[0])),
//     );

//     setState(() {
//       _routePoints = polylinePoints;
//       _isMapReady = false;
//     });
//   } else {
//     log('Failed to fetch route');

//     throw Exception('Failed to fetch route');
//   }
// }

//   // Future<void> _fetchBusLiveLocation(BuildContext context) async {
//   //   final updatedBusLocation =
//   //       await SearchFun.instance.fetchLiveBusLoc(widget.stoploc, context);
//   //   if (!mounted) return;

//   //   if (updatedBusLocation != null &&
//   //       updatedBusLocation.latitude != null &&
//   //       updatedBusLocation.longitude != null) {
//   //     busLocation = updatedBusLocation;

//   //     final updatedPosition = LatLng(
//   //       double.parse(busLocation!.latitude!),
//   //       double.parse(busLocation!.longitude!),
//   //     );

//   //     _popupMarkers.removeWhere((m) => m.key == const ValueKey('bus_marker'));

//   //     _popupMarkers.add(
//   //       fmap.Marker(
//   //         key: const ValueKey('bus_marker'),
//   //         point: updatedPosition,
//   //         width: 40,
//   //         height: 40,
//   //         child: Image.asset(
//   //           'assets/image/tracking/Untitled_design__8_-removebg-preview.png',
//   //           width: 40,
//   //           height: 40,
//   //         ),
//   //       ),
//   //     );

//   //     if (!_isUserInteracting) {
//   //       _mapController.move(updatedPosition, 15);
//   //     }

//   //     if (mounted) setState(() {});
//   //   }
//   //   else if (_starting != null) {
//   //   _popupMarkers.removeWhere((m) => m.key == const ValueKey('bus_marker'));

//   //   _popupMarkers.add(
//   //     fmap.Marker(
//   //       key: const ValueKey('bus_marker'),
//   //       point: _starting!,
//   //       width: 40,
//   //       height: 40,
//   //       child: Image.asset(
//   //                 'assets/image/tracking/Untitled_design__8_-removebg-preview.png',
//   //                 width: 40,
//   //                 height: 40,
//   //               )
//   //       // const Icon(Icons.directions_bus_filled, color: Colors.indigo, size: 32),
//   //     ),
//   //   );
//   //     if (mounted) setState(() {});
//   // }
//   // }
//  Future<void> _fetchBusLiveLocation(BuildContext context) async {
//   final updated = await SearchFun.instance.fetchLiveBusLoc(widget.stoploc, context);
//   if (!mounted) return;

//   // ------------------------------------------------------------------//
//   // 1. Decide which coordinates to use                                //
//   // ------------------------------------------------------------------//
//   final double busLat, busLng;
//   if (updated != null && updated.latitude != null && updated.longitude != null) {
//     busLocation = updated;
//     busLat = double.parse(updated.latitude!);
//     busLng = double.parse(updated.longitude!);
//   } else if (_starting != null) {
//     busLat = _starting!.latitude;
//     busLng = _starting!.longitude;
//   } else {
//     return; // nothing to show yet
//   }
//   _lastBusPos = LatLng(busLat, busLng);

//   // ------------------------------------------------------------------//
//   // 2. Update (or create) the BUS marker                              //
//   // ------------------------------------------------------------------//
//   _popupMarkers.removeWhere((m) => m.key == const ValueKey('bus_marker'));
//   _popupMarkers.add(
//     fmap.Marker(
//       key: const ValueKey('bus_marker'),
//       point: _lastBusPos!,
//       width: 40,
//       height: 40,
//       child: Image.asset(
//         'assets/image/tracking/Untitled_design__8_-removebg-preview.png',
//         width: 40,
//         height: 40,
//       ),
//     ),
//   );

//   // ------------------------------------------------------------------//
//   // 3. Find NEAREST stop                                              //
//   // ------------------------------------------------------------------//
//   final Distance hv = const Distance();
//   int? nearestDist;
//   _StopMarker? nearestStopMarker;

//   for (final m in _popupMarkers) {
//     if (m is _StopMarker) {
//       final d = hv(m.point, _lastBusPos!).round(); // metres
//       if (nearestDist == null || d < nearestDist) {
//         nearestDist = d;
//         nearestStopMarker = m;
//       }
//     }
//   }

//   // threshold ≈ 200 m
//   if (nearestStopMarker != null && nearestDist! < 200) {
//     // Show ONLY that stop’s popup
//     _popupLayerController.showPopupsOnlyFor([nearestStopMarker]);
//   } else {
//     _popupLayerController.hideAllPopups();
//   }

//   // ------------------------------------------------------------------//
//   // 4. Keep map centred unless user dragged it                        //
//   // ------------------------------------------------------------------//
//   if (!_isUserInteracting) {
//     _mapController.move(_lastBusPos!, 15);
//   }

//   if (mounted) setState(() {});
// }

//   void _recenterMap() {
//     if (busLocation != null &&
//         busLocation!.latitude != null &&
//         busLocation!.longitude != null) {
//       final position = LatLng(
//         double.parse(busLocation!.latitude!),
//         double.parse(busLocation!.longitude!),
//       );
//       _mapController.move(position, 15);
//       _isUserInteracting = false;
//       setState(() => _showRecenter = false);
//     }
//   }

//   @override
//   void dispose() {
//     _busLocationTimer?.cancel();
//     Livelocationfun.instance.stopTracking();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_isMapReady && _routePoints.isNotEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Future.delayed(Duration.zero, () {
//           final bounds = fmap.LatLngBounds.fromPoints(_routePoints);
//           _mapController.fitCamera(
//             fmap.CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
//           );
//           _isMapReady = true;
//         });
//       });
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         title: Text(
//           'Tracking',
//           style: TextStyle(
//             fontFamily: 'Poppins-Medium',
//             fontSize: 20.sp,
//             fontWeight: FontWeight.bold,
//             color: Theme.of(context).colorScheme.onPrimary,
//           ),
//           textScaler: TextScaler.noScaling,
//         ),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Stack(
//               children: [
//                 fmap.FlutterMap(
//                   mapController: _mapController,
//                   options: fmap.MapOptions(
//                     initialCenter: _starting ?? LatLng(0, 0),
//                     initialZoom: 15,
//                     minZoom: 5,
//                     maxZoom: 18,
//                     onTap: (_, __) => _popupLayerController.hideAllPopups(),
//                     onPositionChanged: (position, hasGesture) {
//                       if (hasGesture) {
//                         _isUserInteracting = true;
//                         if (!_showRecenter) {
//                           setState(() => _showRecenter = true);
//                         }
//                       }
//                     },
//                   ),
//                   children: [
//                     // fmap.TileLayer(
//                     //   urlTemplate:
//                     //       'https://tile.openstreetmap.org/{z}/{x}/{y}.png?key=Pm9Ul6BqvQ3zxhbRXQ5T',
//                     //   userAgentPackageName: 'com.example.pompompay',
//                     // ),
//                   //   fmap.TileLayer(
//                   //   urlTemplate:
//                   //     'http://117.221.68.183:7001/tiles/{z}/{x}/{y}.png',
//                   //   userAgentPackageName: 'com.example.pompompay',
//                   // ),
//                   fmap.TileLayer(
//                     urlTemplate: 'http://117.221.68.183:7001/tile/{z}/{x}/{y}.png',
//                     tileProvider:  NetworkTileProvider(),
//                     errorTileCallback: (tile, error, stackTrace) {
//                       debugPrint('Tile load error: $error │ $tile');
//                       log('Tile load error: $error │ $tile');
//                     },
//                   ),

//                     if (_routePoints.isNotEmpty)
//                       fmap.PolylineLayer(
//                         polylines: [
//                           fmap.Polyline(
//                             points: _routePoints,
//                             color: Colors.blue,
//                             strokeWidth: 4,
//                           ),
//                         ],
//                       ),
//                     PopupMarkerLayer(
//                       options: PopupMarkerLayerOptions(
//                         markers: _popupMarkers,
//                         popupController: _popupLayerController,
//                         popupDisplayOptions: PopupDisplayOptions(
//                           builder: (BuildContext context, fmap.Marker marker) {
//                             if (marker is _StopMarker) {
//                                int? dist;
//                                 if (_lastBusPos != null) {
//                                   dist = const Distance().call(marker.point, _lastBusPos!).round();
//                                 }
//                               return Card(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text(marker.stop.stopName ?? 'N/A'),
//                                       const SizedBox(height: 4),
//                                       Text('Arriving: ${marker.stop.arrivingTime ?? 'N/A'}'),
//                                       if (dist != null) ...[
//                                         const SizedBox(height: 4),
//                                         Text('Distance ≈ $dist m away',
//                                             style: const TextStyle(color: Colors.grey)),
//                                       ],
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }
//                             return const SizedBox.shrink();
//                           },
//                         ),
//                       ),
//                     ),
//                     const CurrentLocationLayer(),
//                     // Align(
//                     //   alignment: Alignment.bottomRight,
//                     //   child: Padding(
//                     //     padding: const EdgeInsets.all(8.0),
//                     //     child: Text(
//                     //       '© MapTiler © OpenStreetMap contributors',
//                     //       style: TextStyle(
//                     //         fontSize: 10.sp,
//                     //         fontWeight: FontWeight.bold,
//                     //         color: Theme.of(context).colorScheme.onPrimary,
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 ),

//                 // Recenter Button
//                 if (_showRecenter)
//                   Positioned(
//                     bottom: 90,
//                     right: 16,
//                     child: FloatingActionButton(
//                       heroTag: 'recenter',
//                       mini: true,
//                       onPressed: _recenterMap,
//                       child: const Icon(Icons.center_focus_strong),
//                     ),
//                   ),
//               ],
//             ),
//       floatingActionButton: FloatingActionButton(
//         heroTag: 'mylocation',
//         onPressed: () => _mapController.move(
//           _routePoints.firstOrNull ?? LatLng(0, 0),
//           14,
//         ),
//         child: const Icon(Icons.my_location),
//       ),
//     );
//   }
// }

// // class _ScreenMapTrackState extends State<ScreenMapTrack> {
// //   final fmap.MapController _mapController = fmap.MapController();
// //   final PopupController _popupLayerController = PopupController();

// //   bool isLoading = true;
// //   bool _isMapReady = false;

// //   List<LatLng> _routePoints = [];
// //   LatLng? _starting;
// //   // LatLng? _destination;
// //   List<Stop> stops = [];
// //   List<fmap.Marker> _popupMarkers = [];
// //   BusLocation? busLocation;
// //   Timer? _busLocationTimer;

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) => _initialize(context));
// //   }

// //   Future<void> _initialize(BuildContext context) async {
// //   Livelocationfun.instance.startTracking(
// //     context: context,
// //     onLocationUpdate: (position) async {
// //       if (position.latitude != 0 && position.longitude != 0) {
// //         if (!mounted) return;
// //         setState(() => isLoading = false);

// //         final stopValue = await SearchFun.instance.fetchStopLoc(widget.stoploc, context);
// //         stops = stopValue?.stops ?? [];
// //         busLocation = stopValue?.busLocation;

// //         List<LatLng> points = stops
// //             .map((s) => LatLng(double.parse(s.latitude!), double.parse(s.longitude!)))
// //             .toList();

// //         if (points.isNotEmpty) {
// //           _starting = points.first;
// //           _routePoints = points;
// //           await _fetchRoute(points);
// //         }

// //         _buildMarkers();

// //         if (!mounted) return;
// //         setState(() {});

// //         _busLocationTimer = Timer.periodic(const Duration(seconds: 3), (_) {
// //           _fetchBusLiveLocation(context);
// //         });
// //       }
// //     },
// //   );
// // }

// //   void _buildMarkers() {
// //     _popupMarkers = [
// //       if (_starting != null)
// //         fmap.Marker(
// //           point: _starting!,
// //           width: 30,
// //           height: 30,
// //           child: const Icon(Icons.flag, color: Colors.green, size: 35),
// //         ),
// //       for (int i = 1; i < stops.length; i++) _StopMarker(stop: stops[i],stoploc: widget.stoploc),
// //       // if (_destination != null)
// //       //   fmap.Marker(
// //       //     point: _destination!,
// //       //     width: 30,
// //       //     height: 30,
// //       //     child: const Icon(Icons.location_on, color: Colors.red, size: 40),
// //       //   ),
// //       // for (final stop in stops)
// //       // fmap.Marker(
// //       //   point: LatLng(double.parse(stop.latitude!), double.parse(stop.longitude!)),
// //       //   width: 30,
// //       //   height: 30,
// //       //   child: Icon(
// //       //     Icons.location_on,
// //       //     color: stop.stopName == widget.stoploc.to ? Colors.red : Colors.orange,
// //       //     size: stop.stopName == widget.stoploc.to ? 40 : 25,
// //       //   ),
// //       // ),

// //       if (busLocation?.latitude != null && busLocation?.longitude != null)
// //         fmap.Marker(
// //           key: const ValueKey('bus_marker'),
// //           point: LatLng(
// //             double.parse(busLocation!.latitude!),
// //             double.parse(busLocation!.longitude!),
// //           ),
// //           width: 40,
// //           height: 40,
// //           child: Image.asset(
// //                   'assets/image/tracking/Untitled_design__8_-removebg-preview.png',
// //                   width: 40,
// //                   height: 40,
// //                 )
// //          // const Icon(Icons.directions_bus_filled, color: Colors.indigo, size: 32),
// //         ),
// //     ];
// //   }

// //   Future<void> _fetchRoute(List<LatLng> points) async {
// //     final coords = points.map((p) => '${p.longitude},${p.latitude}').join(';');
// //     final url = Uri.parse(
// //       'http://router.project-osrm.org/route/v1/driving/$coords'
// //       '?overview=full&geometries=polyline',
// //     );
// //     final resp = await http.get(url);
// //     if (resp.statusCode == 200) {
// //       final data = json.decode(resp.body);
// //       final geometry = data['routes']?[0]['geometry'];
// //       if (geometry != null) {
// //         final decoded = PolylinePoints().decodePolyline(geometry);
// //         _routePoints =
// //             decoded.map((pt) => LatLng(pt.latitude, pt.longitude)).toList();

// //         setState(() {
// //           _isMapReady = false;
// //         });
// //       }
// //     }
// //   }

// //   // Future<void> _fetchBusLiveLocation() async {
// //   //   final updatedBusLocation =
// //   //       await SearchFun.instance.fetchLiveBusLoc(widget.stoploc, context);
// //   //   if (updatedBusLocation != null &&
// //   //       updatedBusLocation.latitude != null &&
// //   //       updatedBusLocation.longitude != null) {
// //   //     busLocation = updatedBusLocation.busLocation;

// //   //     final updatedPosition = LatLng(
// //   //       double.parse(busLocation!.latitude!),
// //   //       double.parse(busLocation!.longitude!),
// //   //     );

// //   //     _popupMarkers.removeWhere((m) => m.key == const ValueKey('bus_marker'));

// //   //     _popupMarkers.add(
// //   //       fmap.Marker(
// //   //         key: const ValueKey('bus_marker'),
// //   //         point: updatedPosition,
// //   //         width: 32,
// //   //         height: 32,
// //   //         child: const Icon(Icons.directions_bus_filled, color: Colors.indigo, size: 32),
// //   //       ),
// //   //     );

// //   //     setState(() {});
// //   //   }
// //   // }
// //   Future<void> _fetchBusLiveLocation(BuildContext context) async {
// //   final updatedBusLocation =
// //       await SearchFun.instance.fetchLiveBusLoc(widget.stoploc, context);

// //   if (!mounted) return;

// //   if (updatedBusLocation != null &&
// //       updatedBusLocation.latitude != null &&
// //       updatedBusLocation.longitude != null) {
// //     busLocation = updatedBusLocation;

// //     final updatedPosition = LatLng(
// //       double.parse(busLocation!.latitude!),
// //       double.parse(busLocation!.longitude!),
// //     );

// //     _popupMarkers.removeWhere((m) => m.key == const ValueKey('bus_marker'));

// //     _popupMarkers.add(
// //       fmap.Marker(
// //         key: const ValueKey('bus_marker'),
// //         point: updatedPosition,
// //         width: 40,
// //         height: 40,
// //         child:Image.asset(
// //                   'assets/image/tracking/Untitled_design__8_-removebg-preview.png',
// //                   width: 40,
// //                   height: 40,
// //                 )
// //         //  const Icon(Icons.directions_bus_filled, color: Colors.indigo, size: 32),
// //       ),
// //     );
// //   } else if (_starting != null) {
// //     _popupMarkers.removeWhere((m) => m.key == const ValueKey('bus_marker'));

// //     _popupMarkers.add(
// //       fmap.Marker(
// //         key: const ValueKey('bus_marker'),
// //         point: _starting!,
// //         width: 40,
// //         height: 40,
// //         child: Image.asset(
// //                   'assets/image/tracking/Untitled_design__8_-removebg-preview.png',
// //                   width: 40,
// //                   height: 40,
// //                 )
// //         // const Icon(Icons.directions_bus_filled, color: Colors.indigo, size: 32),
// //       ),
// //     );
// //   }

// //   if (!mounted) return;
// //   setState(() {});
// // }

// //  @override
// // void dispose() {
// //   _busLocationTimer?.cancel();
// //   Livelocationfun.instance.stopTracking();
// //   super.dispose();
// // }

// //   @override
// //   Widget build(BuildContext context) {
// //     if (!_isMapReady && _routePoints.isNotEmpty) {
// //       WidgetsBinding.instance.addPostFrameCallback((_) {
// //         Future.delayed(Duration.zero, () {
// //           final bounds = fmap.LatLngBounds.fromPoints(_routePoints);
// //           _mapController.fitCamera(
// //             fmap.CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
// //           );
// //           _isMapReady = true;
// //         });
// //       });
// //     }

// //     return Scaffold(
// //       appBar: AppBar(
// //           backgroundColor: Theme.of(context).colorScheme.primary,

// //           title: Text(
// //             'Tracking',
// //             style: TextStyle(
// //               fontFamily: 'Poppins-Medium',
// //               fontSize: 20.sp,
// //               fontWeight: FontWeight.bold,
// //               color: Theme.of(context).colorScheme.onPrimary,
// //             ),
// //             textScaler: TextScaler.noScaling,
// //           ),
// //         ),
// //       body: isLoading
// //           ? const Center(child: CircularProgressIndicator())
// //           : fmap.FlutterMap(
// //               mapController: _mapController,
// //               options: fmap.MapOptions(
// //                 initialCenter: _starting ?? LatLng(0, 0),
// //                 initialZoom: 15,
// //                 minZoom: 5,
// //                 maxZoom: 18,
// //                 onTap: (_, __) => _popupLayerController.hideAllPopups(),
// //               ),
// //               children: [
// //                 // fmap.TileLayer(
// //                 //   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
// //                 // ),
// //                 fmap.TileLayer(
// //                   urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png?key=Pm9Ul6BqvQ3zxhbRXQ5T',
// //                   userAgentPackageName: 'com.example.pompompay',
// //                 ),

// //                 if (_routePoints.isNotEmpty)
// //                   fmap.PolylineLayer(
// //                     polylines: [
// //                       fmap.Polyline(
// //                         points: _routePoints,
// //                         color: Colors.blue,
// //                         strokeWidth: 4,
// //                       ),
// //                     ],
// //                   ),
// //                 PopupMarkerLayer(
// //                   options: PopupMarkerLayerOptions(
// //                     markers: _popupMarkers,
// //                     popupController: _popupLayerController,
// //                     popupDisplayOptions: PopupDisplayOptions(
// //                       builder: (BuildContext context, fmap.Marker marker) {
// //                         if (marker is _StopMarker) {
// //                           return Card(
// //                             child: Padding(
// //                               padding: const EdgeInsets.all(8.0),
// //                               child: Column(
// //                                 mainAxisSize: MainAxisSize.min,
// //                                 children: [
// //                                   Text(marker.stop.stopName ?? 'N/A'),
// //                                   const SizedBox(height: 4),
// //                                   Text('Arriving: ${marker.stop.arrivingTime ?? 'N/A'}'),
// //                                 ],
// //                               ),
// //                             ),
// //                           );
// //                         }
// //                         return const SizedBox.shrink();
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //                 const CurrentLocationLayer(),
// //                 Align(
// //               alignment: Alignment.bottomRight,
// //               child: Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: Text(
// //                   '© MapTiler © OpenStreetMap contributors',
// //                   style: TextStyle(fontSize: 10.sp,
// //               fontWeight: FontWeight.bold,
// //               color: Theme.of(context).colorScheme.onPrimary,),
// //                 ),
// //               ),
// //             )

// //               ],
// //             ),

// //         floatingActionButton: FloatingActionButton(
// //         onPressed: () => _mapController.move(
// //           _routePoints.firstOrNull ?? LatLng(0, 0),
// //           14,
// //         ),
// //         child: const Icon(Icons.my_location),
// //       ),
// //     );
// //   }
// // }

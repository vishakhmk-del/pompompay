import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:pompompay/core/hook/hooks.dart';

class Livelocationfun {
  Livelocationfun._internal();
  static Livelocationfun instance = Livelocationfun._internal();
  Livelocationfun factory() {
    return instance;
  }

  StreamSubscription<Position>? _positionSubscription;
  Timer? _locationCheckTimer;
  bool _isServiceRestarting = false; // Flag to prevent multiple restarts

  void startTracking({
    required BuildContext context,
    required Function(Position) onLocationUpdate,
  }) async {
    await requestLocationPermission(context);
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) await _showLocationSettingsDialog(context);
      return;
    }
    if (!context.mounted) return;

    await _getInitialLocation(context, onLocationUpdate);
    if (!context.mounted) return;

    _startLiveLocationStream(context, onLocationUpdate);
    if (!context.mounted) return;

    _startLocationCheckTimer(context);
  }

  Future<void> _getInitialLocation(
    BuildContext context,
    Function(Position) onLocationUpdate,
  ) async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      onLocationUpdate(position);
    } catch (e) {
      _showErrorToast("Loading.........");
    }
  }

  void _startLiveLocationStream(
    BuildContext context,
    Function(Position) onLocationUpdate,
  ) {
    try {
      _positionSubscription?.cancel(); // Cancel any previous subscription
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          onLocationUpdate(position);
        },
        onError: (error) async {
          log("Stream error: $error");
          if (error is LocationServiceDisabledException) {
            _positionSubscription?.cancel();
            if (!_isServiceRestarting) {
              _isServiceRestarting = true;
              if(!context.mounted) return;
              await _handleLocationDisabled(context);
              _isServiceRestarting = false;
            }
          } else {
            _showErrorToast("Location error occurred.");
          }
        },
      );
    } catch (e) {
      _showErrorToast("Failed to start location tracking.");
    }
  }

  Future<void> _handleLocationDisabled(BuildContext context) async {
    stopTracking();
    if (context.mounted) await _showLocationSettingsDialog(context);
  }

  void _startLocationCheckTimer(BuildContext context) {
    _locationCheckTimer = Timer.periodic(const Duration(seconds: 30), (
      timer,
    ) async {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log("Location service disabled. Stopping stream...");
        timer.cancel();
        if (context.mounted) await _showLocationSettingsDialog(context);
      }
      // else if (_positionSubscription == null ||_positionSubscription!.isPaused) {
      //   log("Restarting location service...");

      //   _showErrorToast("GPS connection lost");

      //  // if (!context.mounted) return;
      //  // _startLiveLocationStream(context, (position) => {});
      // }
      // else{
      //   log("GPS connection lost");
      //   _showErrorToast("waiting for GPS connection");

      // }
    });
  }

  void stopTracking() {
    _positionSubscription?.cancel();
    _locationCheckTimer?.cancel();
    _positionSubscription = null;
  }

  Future<void> requestLocationPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) _showPermissionPermanentlyDeniedDialog(context);
    }
  }

  Future<void> _showLocationSettingsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primaryFixed,
            title: const Text("Enable Location Services"),
            content: const Text("Location services need to be enabled."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await Geolocator.openLocationSettings();
                },
                child: const Text("Open Settings"),
              ),
            ],
          ),
    );
  }

  void _showPermissionPermanentlyDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primaryFixed,
            title: const Text("Permission Denied Forever"),
            content: const Text(
              "Location permission is permanently denied. Please enable it in settings.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await openAppSettings();
                },
                child: const Text("Open Settings"),
              ),
            ],
          ),
    );
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 14.0,
    );
  }
}

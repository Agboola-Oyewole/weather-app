import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double? longitude;
  double? latitude;

  Future<void> determinePosition(BuildContext context) async {
    LocationPermission permission;
    bool serviceEnabled;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, show a prompt to the user
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Location Permission Required'),
            content: Text(
                'This app needs location permissions to work properly. Please grant them in your device settings and restart the app.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
        Navigator.pop(context);
        return Future.error('Location permissions are denied');
      }
    }

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, prompt the user to enable it
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Enable Location Services'),
          content: Text(
              'Location services are disabled. Please enable them in your device settings and restart the app.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      Navigator.pop(context);
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Location Permission Denied Forever'),
          content: Text(
              'Location permissions are permanently denied. Please enable them in your device settings and restart the app.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      Navigator.pop(context);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue accessing the position of the device
    Position gpsLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
    longitude = gpsLocation.longitude;
    latitude = gpsLocation.latitude;
  }
}

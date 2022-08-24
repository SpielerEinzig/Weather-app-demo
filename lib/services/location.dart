import 'package:geolocator/geolocator.dart';
import 'package:weather_checker/utilities/show_snack_bar.dart';

class Location {
  Future<Map> getCurrentLocation(context) async {
    Position position = await _determinePosition(context);

    return {"longitude": position.longitude, "latitude": position.latitude};
  }

  Future<Position> _determinePosition(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackBar(message: "Enable device location", context: context);
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackBar(message: "Permission denied", context: context);
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnackBar(message: "Permission denied permanently", context: context);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}

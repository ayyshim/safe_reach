import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_reach/src/constants/apiKeys.dart';
import 'package:safe_reach/src/data/model/loc_model.dart';

class LocationRepository {
  final Firestore _firestore;

  final Location _location;
  final Geocoding _geocoding;
  LocationRepository(
      {Location location, Geocoding geocoding, Firestore firestore})
      : _location = location ?? Location(),
        _geocoding = geocoding ?? Geocoder.local,
        _firestore = firestore ?? Firestore();

  Future<Loc> getCurrentLocation() async {
    LocationData locationData = await _location.getLocation();
    Coordinates coordinates =
        new Coordinates(locationData.latitude, locationData.longitude);

    var address = await _geocoding.findAddressesFromCoordinates(coordinates);
    return Loc(label: address.first.addressLine, coordinates: coordinates);
  }

  Future<List<Loc>> getLocationSuggestion({String keyword}) async {
    var addresses = await _geocoding.findAddressesFromQuery('$keyword');
    print(addresses);
    return addresses.map((address) {
      return Loc(coordinates: address.coordinates, label: address.addressLine);
    }).toList();
  }

  Future<PermissionStatus> getLocationPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.location]);
      return permissionStatus[PermissionGroup.location] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  Future<void> saveRouteToDB({Loc start, Loc end, String uid}) async {
    Map<String, dynamic> data = {
      "initLabel": start.label,
      "finalLabel": end.label,
      "initPoint": {
        "lat": start.coordinates.latitude,
        "lng": start.coordinates.longitude
      },
      "finalPoint": {
        "lat": end.coordinates.latitude,
        "lng": end.coordinates.longitude
      },
      "uid": uid
    };

    return await _firestore.collection("saved_route").add(data);
  }

  Future<Loc> getMarkerLocation(LatLng latLng) async {
    final address = await _geocoding.findAddressesFromCoordinates(
        Coordinates(latLng.latitude, latLng.longitude));
    final topRes = address.first;
    return Loc(label: topRes.addressLine, coordinates: topRes.coordinates);
  }

  Future<List<LatLng>> getPolylines(LatLng origin, LatLng destination) async {
    print('$origin, $destination');
    GoogleMapPolyline googleMapPolyline =
        GoogleMapPolyline(apiKey: ApiKey.DIRECTION_API);
    final coordinates = await googleMapPolyline.getCoordinatesWithLocation(
        origin: LatLng(40.677939, -73.941755),
        destination: LatLng(40.698432, -73.924038),
        mode: RouteMode.driving);
    print(coordinates);
    return coordinates;
  }
}

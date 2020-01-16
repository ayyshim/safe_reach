import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';
import 'package:location/location.dart';
import 'package:safe_reach/src/data/model/loc_model.dart';
import 'package:safe_reach/src/data/model/user_model.dart';

class TrackingRepository {
  final Location _location;
  final Geocoding _geocoding;

  TrackingRepository({Location location, Geocoding geocoding})
      : _location = location ?? Location(),
        _geocoding = geocoding ?? Geocoder.local;

  Stream<Loc> userCurrentLocation() {
    return _location.onLocationChanged().asyncMap((LocationData data) async {
      var address = await _geocoding.findAddressesFromCoordinates(
          Coordinates(data.latitude, data.longitude));
      return Loc(
          coordinates: Coordinates(data.latitude, data.longitude),
          label: address.first.addressLine);
    });
  }

  Stream<int> alertTicker(int duration) {
    return Stream.periodic(Duration(seconds: 1), (x) => duration - x - 1);
  }

  Future<void> sendAlert({User user, Loc location}) async {
    final contacts = await Firestore()
        .collection("emergency_contact")
        .where("uid", isEqualTo: user.uid)
        .getDocuments();
    List phoneNumbers = contacts.documents.map((DocumentSnapshot ds) {
      return ds.data["phoneNumber"];
    }).toList();

    final body = {
      "name": user.displayName,
      "phoneNumbers": phoneNumbers,
      "location": {
        "lat": location.coordinates.latitude,
        "lng": location.coordinates.longitude,
        "placeMark": location.label
      }
    };

    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient
        .postUrl(Uri.parse("https://safe-reach-msg.herokuapp.com/msg/send"));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    await response.transform(utf8.decoder).join();
    httpClient.close();
  }
}

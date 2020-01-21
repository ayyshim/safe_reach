import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/services/base.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:safe_reach/src/data/model/loc_model.dart';
import 'package:safe_reach/src/data/model/user_model.dart';
import 'package:safe_reach/src/helpers/number_santizer.dart';
import 'package:sms/sms.dart';

class TrackingRepository {
  final Location _location;
  final Geocoding _geocoding;

  TrackingRepository({Location location, Geocoding geocoding})
      : _location = location ?? Location(),
        _geocoding = geocoding ?? Geocoder.local;

  Stream<LatLng> userCurrentLocation() {
    return _location.onLocationChanged().asyncMap((LocationData data) async {
      return LatLng(data.latitude, data.longitude);
    });
  }

  Stream<int> alertTicker(int duration) {
    return Stream.periodic(Duration(seconds: 1), (x) => duration - x - 1);
  }

  Future<void> sendAlert({User user, LatLng location}) async {
    final contacts = await Firestore()
        .collection("emergency_contact")
        .where("uid", isEqualTo: user.uid)
        .getDocuments();
    List<String> phoneNumbers = contacts.documents.map((DocumentSnapshot ds) {
      return ds.data["phoneNumber"] as String;
    }).toList();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print("Is offline!");
      print("Sending message via Offline SMS.");
      sendSMS(
          user: user.displayName,
          contacts: phoneNumbers,
          coordinates: Coordinates(location.latitude, location.longitude));
      await Future.delayed(Duration(seconds: 1));
    } else {
      print("Is online");
      List<Address> address = await _geocoding.findAddressesFromCoordinates(Coordinates(location.latitude, location.longitude));
      final body = {
        "name": user.displayName,
        "phoneNumbers": phoneNumbers,
        "location": {
          "lat": location.latitude,
          "lng": location.longitude,
          "placeMark": address.first.addressLine
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

  void sendSMS({String user, Coordinates coordinates, List<String> contacts}) {
    String msg = """Sending behalf of $user.
    Need some help.
    https://www.google.com/maps/search/?api=1&query=${coordinates.latitude},${coordinates.longitude}.
    """;
    contacts.forEach((String contact) {
      contact = NumberSanitizer.sanitize(contact);
      SmsSender sender = SmsSender();
      SmsMessage message = SmsMessage("+91$contact", msg);
      message.onStateChanged.listen((state) {
        if (state == SmsMessageState.Sent) {
          print("SMS is sent!");
        } else if (state == SmsMessageState.Delivered) {
          print("SMS is delivered!");
        }
      });
      sender.sendSms(message);
    });
  }

  Future<LatLng> getCurrentLocation() async {
    LocationData locationData = await _location.getLocation();
    return LatLng(locationData.latitude, locationData.longitude);
  }
}

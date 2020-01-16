import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SavedRoute extends Equatable {
  final String _uid;
  final String _id;
  final String _initLabel;
  final String _finalLabel;
  final Point _initPoint;
  final Point _finalPoint;
  final List<LatLng> _polylines;

  String get uid => _uid;
  String get id => _id;
  String get initLabel => _initLabel;
  String get finalLabel => _finalLabel;
  Point get initPoint => _initPoint;
  Point get finalPoint => _finalPoint;
  List<LatLng> get polylines => _polylines;

  SavedRoute(
      {@required String uid,
      @required String id,
      @required String initLabel,
      @required String finalLabel,
      @required Point initPoint,
      @required Point finalPoint,
      List<LatLng> polylines})
      : _id = id,
        _uid = uid,
        _initPoint = initPoint,
        _finalPoint = finalPoint,
        _initLabel = initLabel,
        _finalLabel = finalLabel,
        _polylines = polylines;

  factory SavedRoute.fromDoc(DocumentSnapshot doc) {
    var coordinates = doc.data["polylines"] as List;
    List<LatLng> polylines =
        coordinates.map((coord) => LatLng(coord["lat"], coord["lng"])).toList();

    return SavedRoute(
        id: doc.documentID,
        uid: doc.data["uid"],
        initLabel: doc.data["initLabel"],
        finalLabel: doc.data["finalLabel"],
        finalPoint: Point(
            lat: doc.data["finalPoint"]["lat"],
            lng: doc.data["finalPoint"]["lng"]),
        initPoint: Point(
            lat: doc.data["initPoint"]["lat"],
            lng: doc.data["initPoint"]["lng"]),
        polylines: polylines);
  }

  @override
  List<Object> get props =>
      [_uid, _id, _initPoint, _initLabel, _finalPoint, _finalLabel];
}

class Point extends Equatable {
  final double _lat;
  final double _lng;

  get lat => _lat;
  get lng => _lng;

  Point({@required double lat, @required double lng})
      : _lat = lat,
        _lng = lng;

  @override
  List<Object> get props => [_lat, _lng];
}

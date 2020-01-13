import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class SavedRoute extends Equatable {
  final String _id;
  final String _initLabel;
  final String _finalLabel;
  final Point _initPoint;
  final Point _finalPoint;

  get id => _id;
  get initLabel => _initLabel;
  get finalLabel => _finalLabel;
  get initPoint => _initPoint;
  get finalPoint => _finalPoint;

  SavedRoute(
      {@required String id,
      @required String initLabel,
      @required String finalLabel,
      @required Point initPoint,
      @required Point finalPoint})
      : _id = id,
        _initPoint = initPoint,
        _finalPoint = finalPoint,
        _initLabel = initLabel,
        _finalLabel = finalLabel;

  factory SavedRoute.fromDoc(DocumentSnapshot doc) {
    return SavedRoute(
      id: doc.documentID,
      initLabel: doc.data["initLabel"],
      finalLabel: doc.data["finalLabel"],
      finalPoint: Point(
          lat: doc.data["finalPoint"]["lat"],
          lng: doc.data["finalPoint"]["lng"]),
      initPoint: Point(
          lat: doc.data["initPoint"]["lat"], lng: doc.data["initPoint"]["lng"]),
    );
  }

  @override
  List<Object> get props =>
      [_id, _initPoint, _initLabel, _finalPoint, _finalLabel];
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

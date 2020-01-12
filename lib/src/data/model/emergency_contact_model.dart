import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class EmergencyContact extends Equatable {
  final String _id;
  final String _title;
  final String _phoneNumber;
  final String _uid;

  get id => _id;
  get title => _title;
  get phoneNumber => _phoneNumber;
  get uid => _uid;

  EmergencyContact(
      {@required String id,
      @required String title,
      @required String phoneNumber,
      @required String uid})
      : _id = id,
        _title = title,
        _phoneNumber = phoneNumber,
        _uid = uid;

  factory EmergencyContact.fromDoc(DocumentSnapshot doc) {
    return EmergencyContact(
        id: doc.documentID,
        phoneNumber: doc.data["phoneNumber"],
        title: doc.data["title"],
        uid: doc.data["uid"]);
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
        id: map["id"],
        phoneNumber: map["phoneNumber"],
        title: map["title"],
        uid: map["uid"]);
  }

  @override
  List<Object> get props => [_id, _title, _phoneNumber, _uid];
}

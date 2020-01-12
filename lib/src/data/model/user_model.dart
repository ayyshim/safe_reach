import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final String _uid;
  final String _displayName;
  final String _email;
  final String _photoUrl;
  final String _phoneNumber;
  final String _address;

  get uid => this._uid;
  get displayName => this._displayName;
  get email => this._email;
  get photoUrl => this._photoUrl;
  get phoneNumber => this._phoneNumber;
  get address => this._address;

  User({
    @required String uid,
    @required String email,
    @required String displayName,
    @required String photoUrl,
    String phoneNumber,
    String address,
  })  : _uid = uid,
        _displayName = displayName,
        _email = email,
        _phoneNumber = phoneNumber,
        _photoUrl = photoUrl,
        _address = address;

  factory User.fromFirebaseUser({@required FirebaseUser user}) {
    return User(
        displayName: user.displayName,
        email: user.email,
        photoUrl: user.photoUrl,
        phoneNumber: user.phoneNumber,
        uid: user.uid,
        address: null);
  }

  @override
  List<Object> get props =>
      [_uid, _displayName, _email, _phoneNumber, _photoUrl, _address];
}

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  final String _uid;
  final String _displayName;
  final String _email;
  final String _photoUrl;
  final String _phoneNumber;

  get uid => this.uid;
  get displayName => this._displayName;
  get email => this._email;
  get photoUrl => this._photoUrl;
  get phoneNumber => this._phoneNumber;

  User(
      {@required String uid,
      @required String email,
      @required String displayName,
      @required String photoUrl,
      String phoneNumber})
      : _uid = uid,
        _displayName = displayName,
        _email = email,
        _phoneNumber = phoneNumber,
        _photoUrl = photoUrl;

  factory User.fromFirebaseUser({@required FirebaseUser user}) {
    return User(
        displayName: user.displayName,
        email: user.email,
        photoUrl: user.photoUrl,
        phoneNumber: user.phoneNumber,
        uid: user.uid);
  }

  @override
  List<Object> get props =>
      [_uid, _displayName, _email, _phoneNumber, _photoUrl];
}

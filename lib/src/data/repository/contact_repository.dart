import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactRepository {
  final Firestore _firestore;

  ContactRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore();

  Future<List<Contact>> getContacts() async {
    return await ContactsService.getContacts().then((res) {
      return res.toList();
    });
  }

  Future<PermissionStatus> getPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);

    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  Future<void> addContact({Map<String, dynamic> data}) async {
    return await _firestore.collection("emergency_contact").add(data);
  }
}

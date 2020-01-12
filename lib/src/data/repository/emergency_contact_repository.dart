import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_reach/src/data/model/emergency_contact_model.dart';

class EmergencyContactRepository {
  final Firestore _firestore;

  EmergencyContactRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore();

  Stream<List<EmergencyContact>> getEmergencyContacts({String uid}) {
    return _firestore
        .collection("emergency_contact")
        .where("uid", isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot qs) {
      return qs.documents.map((d) {
        return EmergencyContact.fromDoc(d);
      }).toList();
    });
  }

  Future<void> deleteEmergencyContact({String id}) {
    return _firestore.collection("emergency_contact").document(id).delete();
  }
}

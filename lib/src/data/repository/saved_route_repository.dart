import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_reach/src/data/model/saved_route_model.dart';

class SavedRouteRepository {
  final Firestore _firestore;

  SavedRouteRepository({Firestore firestore})
      : _firestore = firestore ?? Firestore();

  Stream<List<SavedRoute>> getEmergencyContacts({String uid}) {
    return _firestore
        .collection("saved_route")
        .where("uid", isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot qs) {
      return qs.documents.map((d) {
        return SavedRoute.fromDoc(d);
      }).toList();
    });
  }

  Future<void> deleteEmergencyContact({String id}) {
    return _firestore.collection("saved_route").document(id).delete();
  }
}

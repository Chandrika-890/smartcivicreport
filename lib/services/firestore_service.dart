import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addComplaint(
      String userId, String issue, String description) async {
    await _firestore.collection('complaints').add({
      'userId': userId,
      'issue': issue,
      'description': description,
      'status': 'Pending',
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getUserComplaints(String userId) {
    return _firestore
        .collection('complaints')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }
}

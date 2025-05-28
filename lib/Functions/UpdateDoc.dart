import 'package:cloud_firestore/cloud_firestore.dart';

void updateDocument(String collection, String docId, Map<String, dynamic> data) async {
  await FirebaseFirestore.instance
      .collection(collection)
      .doc(docId)
      .update(data);
}
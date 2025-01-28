import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Future<void> register(String email, String name) async {
    List<String> words = splitName(name);
    await _fireStore.collection('users').doc(email).set({
      'name': name,
      'dn': words[0],
      'email': email,
    });
  }

  Future<List<Map<String, dynamic>>> getPlaces(String district) async {
    var collection = FirebaseFirestore.instance.collection('places');
    var snapshot =
        await collection.where("district", isEqualTo: district).get();
    List<Map<String, dynamic>> places = [];
    for (var doc in snapshot.docs) {
      places.add(doc.data());
    }
    // print("_____________$places");
    return places;
  }

  Future<Map<String, dynamic>> getPlace(String district, String id) async {
    var collection = FirebaseFirestore.instance.collection('places');
    var snapshot = await collection
        .where("district", isEqualTo: district)
        .where("id", isEqualTo: id)
        .get();
    Map<String, dynamic> places;
    places = snapshot.docs[0].data();

    return places;
  }

  Future<Map<String, dynamic>> getActivity(String id) async {
    var collection = FirebaseFirestore.instance.collection('activities');
    var snapshot = await collection.where("id", isEqualTo: id).get();
    Map<String, dynamic> places;
    places = snapshot.docs[0].data();

    return places;
  }

  Future<List<Map<String, dynamic>>> getPopularActivities() async {
    var collection = FirebaseFirestore.instance.collection('activities');
    var snapshot = await collection.get();
    List<Map<String, dynamic>> activities = [];
    for (var doc in snapshot.docs) {
      activities.add(doc.data());
    }
    return activities;
  }

  // Get all documents from a collection
  Future<List<Map<String, dynamic>>> getDocuments(
      String col1, String email, String col2) async {
    final collectionRef =
        _fireStore.collection(col1).doc(email).collection(col2);
    final snapshot = await collectionRef.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocuments2(
      String col1, String email) {
    return _fireStore.collection(col1).doc(email).get();
  }

  Future<List<String>> getDocumentNames(
      String col1, String email, String col2) async {
    final collectionRef =
        _fireStore.collection(col1).doc(email).collection(col2);
    final snapshot = await collectionRef.get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<void> deleteCollection(String col1, String email, String col2) async {
    final collection =
        FirebaseFirestore.instance.collection(col1).doc(email).collection(col2);
    // Get all documents in the collection
    final snapshot = await collection.get();
    // Loop through and delete each document
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  List<String> splitName(String name) {
    List<String> words = name.split(" ");
    return words;
  }
}

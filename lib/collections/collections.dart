import 'package:cloud_firestore/cloud_firestore.dart';

class Collections {
  static CollectionReference users =
      FirebaseFirestore.instance.collection("users");
}

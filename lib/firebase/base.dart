import 'package:firebase_core/firebase_core.dart';

class FirebaseBase {
  Future<void> initFirebase() async {
    Firebase.initializeApp();
  }
}

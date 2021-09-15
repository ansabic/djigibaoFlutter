import 'package:djigibao_manager/constants.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseBase {
  Future<void> initFirebase() async {
    await Firebase.initializeApp(name: APP_NAME);
  }
}

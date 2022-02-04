import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<Future<FirebaseApp>> initializeFirebase() async {
  await Firebase.initializeApp().then((_) {
    FirebaseFirestore.instance.settings =
    const Settings(persistenceEnabled: false);
  });
  if (Platform.isIOS || Platform.isMacOS) {
    return Firebase.initializeApp();
  } else {
    return Firebase.initializeApp(options: firebaseOptions);
  }
}

import 'dart:developer' show log;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Connnect to the firebase emulator
Future connectToFirebaseEmulator() async {
  log('configuring firebase emulator..', name: 'FirebaseEmulator');

  final localHostString = Platform.isAndroid ? '10.0.2.2' : 'localhost';

  await FirebaseAuth.instance.useAuthEmulator(localHostString, 9099);

  await FirebaseStorage.instance.useStorageEmulator(localHostString, 9199);

  FirebaseFirestore.instance.useFirestoreEmulator(localHostString, 8080);

  FirebaseDatabase.instance.useDatabaseEmulator(localHostString, 9000);
}

import 'package:cloud_firestore/cloud_firestore.dart';

DateTime firestoreDateOnFromJson(Timestamp timestamp) => timestamp.toDate();

Timestamp firestoreDateOnToJson(DateTime date) => Timestamp.fromDate(date);
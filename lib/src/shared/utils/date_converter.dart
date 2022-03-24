import 'package:cloud_firestore/cloud_firestore.dart';

// firebase date converter
DateTime firestoreDateOnFromJson(Timestamp timestamp) => timestamp.toDate();

Timestamp firestoreDateOnToJson(DateTime date) => Timestamp.fromDate(date);

// deta date converter
DateTime detaDateOnFromJson(String stringDate) => DateTime.parse(stringDate);

String detaDateOnToJson(DateTime date) => date.toIso8601String();

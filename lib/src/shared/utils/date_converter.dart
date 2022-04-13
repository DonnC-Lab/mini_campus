import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timeago/timeago.dart' as timeago;

// firebase date converter
DateTime firestoreDateOnFromJson(Timestamp timestamp) => timestamp.toDate();

Timestamp firestoreDateOnToJson(DateTime date) => Timestamp.fromDate(date);

// general date converter
DateTime generalDateOnFromJson(String stringDate) => DateTime.parse(stringDate);

String generalDateOnToJson(DateTime date) => date.toIso8601String();

String elapsedTimeAgo(DateTime? date) => timeago.format(date!);

import 'package:cloud_firestore/cloud_firestore.dart';

bool isNew(Timestamp timestamp) {

  DateTime now = DateTime.now();

  DateTime date = timestamp.toDate();

  Duration difference = now.difference(date);

  if (difference.inDays < 7) {
    return true;
  } else {
    return false;
  }
}
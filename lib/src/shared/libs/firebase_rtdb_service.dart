library firebase_rtdb_service;

import 'package:firebase_database/firebase_database.dart';

class FirebaseRtdbService {
  FirebaseRtdbService._();
  static final instance = FirebaseRtdbService._();

  static final _dbInstance = FirebaseDatabase.instance;

  /// add data: path e.g: "users/123"
  ///
  /// with user defined doc key | id
  Future<void> addData(
      {required String path, required Map<String, dynamic> data}) async {
    final ref = _dbInstance.ref(path);

    await ref.set(data);
  }

  /// get data: path e.g: "users/123"
  Future<DataSnapshot> getData({required String path}) async {
    final ref = _dbInstance.ref(path);

    return await ref.get();
  }

  /// set data: path e.g: "users" with unique auto gen id
  ///
  ///
  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    await _dbInstance.ref().child(path).push().set(data);
  }

  /// update data: path e.g: "users/123" | "users"
  ///
  /// method accepts a sub-path to nodes, allowing you to update multiple nodes on the database at once
  ///
  /// ```dart
  ///await ref.update({
  ///  "123/age": 19,
  ///  "123/address/line1": "1 Mountain View",
  ///});
  ///```
  Future<void> updateData(
      {required String path, required Map<String, dynamic> data}) async {
    await _dbInstance.ref().child(path).update(data);
  }

  /// remove doc at path e.g "posts/1"
  Future<void> deleteData({required String path}) async {
    await _dbInstance.ref().child(path).remove();
  }
}

library firestore_service;

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();
  static final _fbInstance = FirebaseFirestore.instance;

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    await _fbInstance.doc(path).set(data, SetOptions(merge: merge));
  }

  Future addData({
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    final _res = await _fbInstance.collection(collectionName).add(data);
    return _res.id;
  }

  Future<void> deleteData({required String path}) async {
    await _fbInstance.doc(path).delete();
  }

  Future<void> addToArray({
    required String path,
    required String data,
    required String fieldName,
  }) async {
    await _fbInstance.doc(path).update({
      fieldName: FieldValue.arrayUnion([data])
    });
  }

  Future<void> removeFromArray({
    required String path,
    required String data,
    required String fieldName,
  }) async {
    await _fbInstance.doc(path).update({
      fieldName: FieldValue.arrayRemove([data]),
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getData({
    required String path,
  }) async =>
      await _fbInstance.doc(path).get();

  Future<QuerySnapshot<Map<String, dynamic>>> getPathSubCollectionData({
    required String path,
    required String subcollectionName,
  }) async =>
      await _fbInstance.doc(path).collection(subcollectionName).get();

  Future<void> deletePathSubCollectionData({
    required String path,
    required String subcollectionName,
  }) async {
    final snaps =
        await _fbInstance.doc(path).collection(subcollectionName).get();

    for (var subData in snaps.docs) {
      await subData.reference.delete();
    }
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
    Query<Map<String, dynamic>>? Function(Query<Map<String, dynamic>> query)?
        queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query<Map<String, dynamic>> query = _fbInstance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query)!;
    }
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data(), snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) {
    final DocumentReference<Map<String, dynamic>> reference =
        _fbInstance.doc(path);
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        reference.snapshots();

    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }
}

library firestore_service;

import 'package:cloud_firestore/cloud_firestore.dart';

/// {@template store_service}
/// Firebase Firestore Service
///
/// a wrapper service class around the firebase firestore service
///
/// {@endtemplate}
///
class FirestoreService {
  FirestoreService._();

  /// {@macro store_service}
  static final instance = FirestoreService._();
  static final _fbInstance = FirebaseFirestore.instance;

  /// add data with user generated doc id
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    await _fbInstance.doc(path).set(data, SetOptions(merge: merge));
  }

  /// add data with auto generated doc id
  Future<String> addData({
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    final _res = await _fbInstance.collection(collectionName).add(data);
    return _res.id;
  }

  /// delete record at [path]
  Future<void> deleteData({required String path}) async {
    await _fbInstance.doc(path).delete();
  }

  /// add item, [data] to document array
  ///
  /// document array [fieldName] at [path]
  Future<void> addToArray({
    required String path,
    required String data,
    required String fieldName,
  }) async {
    await _fbInstance.doc(path).update({
      fieldName: FieldValue.arrayUnion([data])
    });
  }

  /// remove item, [data] in document array
  ///
  /// document array [fieldName] at [path]
  Future<void> removeFromArray({
    required String path,
    required String data,
    required String fieldName,
  }) async {
    await _fbInstance.doc(path).update({
      fieldName: FieldValue.arrayRemove([data]),
    });
  }

  /// get data at [path]
  ///
  /// return [DocumentSnapshot]
  Future<DocumentSnapshot<Map<String, dynamic>>> getData({
    required String path,
  }) async =>
      _fbInstance.doc(path).get();

  /// get data at document sub-collection
  ///
  /// return [QuerySnapshot]
  Future<QuerySnapshot<Map<String, dynamic>>> getPathSubCollectionData({
    required String path,
    required String subcollectionName,
  }) async =>
      _fbInstance.doc(path).collection(subcollectionName).get();

  /// delete all data at sub-collection
  Future<void> deletePathSubCollectionData({
    required String path,
    required String subcollectionName,
  }) async {
    final snaps =
        await _fbInstance.doc(path).collection(subcollectionName).get();

    for (final subData in snaps.docs) {
      await subData.reference.delete();
    }
  }

  /// stream collection
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
    final snapshots = query.snapshots();
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

  /// stream document
  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) {
    final reference = _fbInstance.doc(path);
    final snapshots = reference.snapshots();

    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }
}

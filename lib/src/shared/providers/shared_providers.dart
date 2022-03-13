import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// ? TODO: consider theme mode set in sharedprefs by user
final themeNotifierProvider = StateProvider<ValueNotifier<ThemeMode>>(
    (ref) => ValueNotifier(ThemeMode.system));

/// dio instance provider
final dioProvider = StateProvider<Dio>((ref) => dioInstance(null));

final imgPickerProvider = Provider((_) => ImagePicker());

Dio dioInstance(String? authKey, {bool isJsonHeader = true}) {
  return Dio(
    BaseOptions(
      baseUrl: 'baseUrl', // ! add proper base url
      connectTimeout: 60000,
      receiveTimeout: 50000,
      sendTimeout: 60000,
      headers: authKey == null
          ? {
              'Content-Type': isJsonHeader
                  ? 'application/json'
                  : 'application/x-www-form-urlencoded',
            }
          : {
              "Authorization": 'Bearer $authKey',
              'Content-Type': isJsonHeader
                  ? 'application/json'
                  : 'application/x-www-form-urlencoded',
            },
    ),
  );
}

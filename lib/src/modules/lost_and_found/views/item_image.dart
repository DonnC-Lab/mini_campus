import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_campus/src/shared/index.dart';

import '../services/storage_service.dart';

class ItemImage extends ConsumerWidget {
  const ItemImage({
    Key? key,
    this.img,
    this.size = 60.0,
    this.radius = 8.0,
    this.isNetwork = false,
  }) : super(key: key);

  final String? img;

  final double size;

  final double radius;

  final bool isNetwork;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final api = ref.read(lostFoundStorageProvider);

    return SizedBox(
      height: size,
      width: size,
      child: img == null
          ? _ItemImageContainer(
              size: size,
              radius: radius,
              fileSource: lostFoundPlaceholder,
            )
          : FutureBuilder<File?>(
              future: api.downloadItemImageFuture(img!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data == null
                      ? _ItemImageContainer(
                          size: size,
                          radius: radius,
                          fileSource: lostFoundPlaceholder,
                        )
                      : _ItemImageContainer(
                          size: size,
                          radius: radius,
                          fileSource: snapshot.data,
                        );
                }

                if (snapshot.hasError) {
                  return _ItemImageContainer(
                    size: size,
                    radius: radius,
                    fileSource: lostFoundPlaceholder,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }
}

class _ItemImageContainer extends StatelessWidget {
  const _ItemImageContainer({
    Key? key,
    required this.size,
    required this.radius,
    required this.fileSource,
  }) : super(key: key);

  final double size;
  final double radius;
  final dynamic fileSource;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.white,
        image: DecorationImage(
          image: fileSource is File
              ? FileImage(fileSource) as ImageProvider
              : AssetImage(fileSource),
          fit: fileSource is File ? BoxFit.cover : BoxFit.contain,
        ),
      ),
    );
  }
}

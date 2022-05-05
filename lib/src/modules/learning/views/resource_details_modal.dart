import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:mini_campus/src/shared/index.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:relative_scale/relative_scale.dart';

import '../data/models/course.dart';
import '../data/models/resource/file_resource.dart';
import '../services/course_repo.dart';

// ignore: non_constant_identifier_names
void ResourceDetailsModal(BuildContext context, FileResource item) {
  showMaterialModalBottomSheet(
    context: context,
    isDismissible: true,
    useRootNavigator: true,
    builder: (context) =>
        RelativeBuilder(builder: (context, height, width, sy, sx) {
      return Consumer(builder: (_, ref, __) {
        return SizedBox(
          height: 300,
          width: double.infinity,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Details',
                      style: Theme.of(context).textTheme.headline1?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(FontAwesome.file_pdf_o, size: 50),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.resource.filename,
                            style:
                                Theme.of(context).textTheme.headline1?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                          const SizedBox(height: 8),
                          FutureBuilder<Course?>(
                            future: ref
                                .read(courseRepProvider)
                                .getSingleCourse(item.courseCode),
                            builder: (ctx, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data?.name ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      ?.copyWith(
                                        fontSize: 15,
                                        color: greyTextShade,
                                      ),
                                );
                              } else {
                                return const Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        DateFormat.yMMMMd().format(item.createdOn),
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            ?.copyWith(fontSize: 11, color: greyTextShade),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          item.year.toString(),
                          style:
                              Theme.of(context).textTheme.subtitle2?.copyWith(
                                    fontSize: 13,
                                    color: greyTextShade,
                                  ),
                        ),
                        Text(
                          item.part,
                          style:
                              Theme.of(context).textTheme.subtitle2?.copyWith(
                                    fontSize: 13,
                                    color: greyTextShade,
                                  ),
                        ),
                        Text(
                          item.dpt,
                          style:
                              Theme.of(context).textTheme.subtitle2?.copyWith(
                                    fontSize: 13,
                                    color: greyTextShade,
                                  ),
                        ),
                        Text(
                          item.category,
                          style:
                              Theme.of(context).textTheme.subtitle2?.copyWith(
                                    fontSize: 13,
                                    color: greyTextShade,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  CustomProfileAvatar(
                    studentId: item.uploadedBy,
                    title: 'Uploaded By',
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }),
  );
}

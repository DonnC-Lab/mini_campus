import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mini_campus/src/shared/index.dart';

import 'profile_stats_card.dart';

class DetailedProfileView extends ConsumerStatefulWidget {
  const DetailedProfileView({Key? key, this.extStudent}) : super(key: key);

  final Student? extStudent;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailedProfileViewState();
}

class _DetailedProfileViewState extends ConsumerState<DetailedProfileView> {
  bool updatingProfile = false;

  @override
  Widget build(BuildContext context) {
    final currentStudent = ref.watch(studentProvider);

    final storageApi = ref.read(gStorageProvider);

    final studentService = ref.watch(studentStoreProvider);

    final img = ref.watch(pickedImgProvider);

    final _dialog = ref.watch(dialogProvider);

    var student = widget.extStudent ?? currentStudent;

    bool _isOwner = widget.extStudent == null;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: !_isOwner
                      ? null
                      : () async {
                          final imgSource = await ImageSourceSelector(context);

                          if (imgSource != null) {
                            setState(() {
                              updatingProfile = true;
                            });

                            await customImgPicker(ref, imgSource);

                            // upload student img
                            if (img != null) {
                              // upload img to cloud
                              final String? imgUrl =
                                  await storageApi.uploadMediaFile(
                                      image: img.path,
                                      path: CloudStoragePath.profilePicture(
                                          student!.id!));

                              if (imgUrl != null) {
                                _dialog.showToast('profile image uploaded');

                                // update profile pic
                                await studentService.updateStudent(
                                    student.copyWith(profilePicture: imgUrl));
                              } else {
                                _dialog.showToast(
                                    'failed to upload profile image');
                              }

                              // reset img provider
                              ref.read(pickedImgProvider.notifier).state = null;
                            }

                            setState(() {
                              updatingProfile = false;
                            });
                          }
                        },
                  child: AdvancedAvatar(
                    size: 120,
                    bottomLeft: !_isOwner
                        ? null
                        : CircleAvatar(
                            backgroundColor: Theme.of(context).cardColor,
                            child: updatingProfile
                                ? const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: CircularProgressIndicator(),
                                  )
                                : IconButton(
                                    onPressed: () {},
                                    color: greyTextShade,
                                    icon: const Icon(Icons.camera_alt),
                                  ),
                          ),
                    decoration: BoxDecoration(
                      color: bluishColor,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    name: student?.name,
                    image: NetworkImage(student?.profilePicture ?? ''),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  student?.alias ?? student?.name ?? 'Student',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              // const SizedBox(height: 20),
              // Center(
              //   child: Text(
              //     student!.faculty,
              //     style: Theme.of(context)
              //         .textTheme
              //         .subtitle2
              //         ?.copyWith(color: greyTextShade),
              //   ),
              // ),
              const SizedBox(height: 30),
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About',
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          student!.about.isEmpty
                              ? 'Hey 👋 I\'m using MiniCampus'
                              : student.about,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              ?.copyWith(fontSize: 13, color: greyTextShade),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            DateFormat.yMMMMd().format(student.createdOn),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                ?.copyWith(fontSize: 11, color: greyTextShade),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ProfileStatsCard(extStudent: widget.extStudent),
              const SizedBox(height: 30),
              ExpansionTile(
                title: const Text('Profile'),
                children: [
                  CustomFormField(
                    context: context,
                    formName: 'email',
                    readOnly: true,
                    initialText: student.email,
                    title: 'Email',
                  ),
                  CustomFormField(
                    context: context,
                    formName: 'name',
                    readOnly: true,
                    initialText: student.name,
                    title: 'Fullname',
                  ),
                  CustomFormField(
                    context: context,
                    formName: 'gender',
                    readOnly: true,
                    initialText: student.gender,
                    title: 'Gender',
                  ),
                  CustomFormField(
                    context: context,
                    formName: 'phone',
                    initialText: student.whatsappNumber,
                    hintText: 'e.g 0712345678',
                    title: 'WhatsApp Number',
                  ),
                  CustomFormField(
                    context: context,
                    formName: 'location',
                    initialText: student.campusLocation,
                    hintText: 'e.g Riverside',
                    title: 'Campus Location',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

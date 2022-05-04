import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:mini_campus/src/shared/index.dart';

import 'about_alias_update.dart';
import 'profile_stats_card.dart';

class DetailedProfileView extends ConsumerStatefulWidget {
  const DetailedProfileView({Key? key, this.extStudent, this.showAppbar = true})
      : super(key: key);

  final Student? extStudent;

  final bool showAppbar;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailedProfileViewState();
}

class _DetailedProfileViewState extends ConsumerState<DetailedProfileView> {
  final updateFormKey = GlobalKey<FormBuilderState>();
  final aboutAliasFormKey = GlobalKey<FormBuilderState>();

  bool updatingProfile = false;

  bool toggleOwnerProfileEdit = true;

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
        appBar: widget.showAppbar ? AppBar(title: const Text('Profile')) : null,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FormBuilder(
            key: updateFormKey,
            enabled: _isOwner,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: !_isOwner
                        ? null
                        : () async {
                            final imgSource =
                                await ImageSourceSelector(context);

                            if (imgSource != null) {
                              await customImgPicker(ref, imgSource);

                              // upload student img
                              if (img != null) {
                                setState(() {
                                  updatingProfile = true;
                                });

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
                                ref.read(pickedImgProvider.notifier).state =
                                    null;
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
                const SizedBox(height: 30),
                Card(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'About',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              GestureDetector(
                                onTap: _isOwner
                                    ? () {
                                        UpdateAboutAliasModal(
                                          context,
                                          student!,
                                          aboutAliasFormKey,
                                        );
                                      }
                                    : () {},
                                child: Icon(
                                  Icons.edit,
                                  size: 17,
                                  color: _isOwner
                                      ? Theme.of(context).iconTheme.color
                                      : greyTextShade,
                                ),
                              ),
                            ],
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
                                  ?.copyWith(
                                      fontSize: 11, color: greyTextShade),
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
                    _isOwner
                        ? CustomFormField(
                            context: context,
                            formName: 'email',
                            readOnly: true,
                            initialText: student.email,
                            title: 'Email',
                          )
                        : const SizedBox.shrink(),
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
                      autoFocus: true,
                      readOnly: toggleOwnerProfileEdit,
                      initialText: student.whatsappNumber,
                      hintText: 'e.g 0712345678',
                      title: 'WhatsApp Number',
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(context, errorText: '')
                        ],
                      ),
                    ),
                    CustomFormField(
                      context: context,
                      formName: 'location',
                      readOnly: toggleOwnerProfileEdit,
                      initialText: student.campusLocation,
                      hintText: 'e.g Riverside',
                      title: 'Campus Location',
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(context, errorText: '')
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isOwner
                        ? Row(
                            children: [
                              Expanded(
                                child: CustomRoundedButton(
                                  text: toggleOwnerProfileEdit
                                      ? 'Edit'
                                      : 'Update',
                                  onTap: toggleOwnerProfileEdit
                                      ? () {
                                          setState(() {
                                            toggleOwnerProfileEdit = false;
                                          });
                                        }
                                      : () async {
                                          if (updateFormKey.currentState!
                                              .validate()) {
                                            updateFormKey.currentState!.save();
                                            final _data = updateFormKey
                                                .currentState!.value;

                                            String _appNumber = '';

                                            // verify num
                                            if (_data['phone']
                                                .toString()
                                                .isNotEmpty) {
                                              var isValidNumber =
                                                  await contactHelper(
                                                      _data['phone']);

                                              if (isValidNumber == null) {
                                                _dialog.showTopFlash(context,
                                                    title: "Mobile Number",
                                                    mesg:
                                                        'Invalid mobile number, please double check and try again!');
                                                return;
                                              }

                                              _appNumber = isValidNumber;
                                            }

                                            modalLoader(context);

                                            // update student
                                            final Student _student =
                                                student.copyWith(
                                              whatsappNumber: _appNumber,
                                              campusLocation: _data['location'],
                                            );

                                            var _updated = await studentService
                                                .updateStudent(_student);

                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();

                                            if (_updated == null) {
                                              _dialog.showTopFlash(context,
                                                  title: "Account",
                                                  mesg:
                                                      'Failed to update account. Try again later');
                                            }

                                            // success
                                            else {
                                              _dialog.showTopFlash(context,
                                                  title: "Account",
                                                  mesg:
                                                      'Your account has been updated!');

                                              setState(() {
                                                toggleOwnerProfileEdit = true;
                                              });
                                            }
                                          }
                                        },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomRoundedButton(
                                  text: 'Cancel',
                                  onTap: () {
                                    setState(() {
                                      toggleOwnerProfileEdit = true;
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

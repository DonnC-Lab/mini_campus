import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:mini_campus_components/mini_campus_components.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';
import 'package:mini_campus_core/mini_campus_core.dart';
import 'package:mini_campus_core/src/features/profile/views/about_alias_update.dart';
import 'package:mini_campus_core/src/features/profile/views/profile_stats_card.dart';
import 'package:mini_campus_core/src/services/firebase/storage_service.dart';
import 'package:mini_campus_core/src/services/firebase/student_service.dart';

/// Profile view
///
/// a detailed student profile
class DetailedProfileView extends ConsumerStatefulWidget {
  /// profile view
  const DetailedProfileView({
    super.key,
    this.externalStudent,
    this.showAppbar = true,
  });

  /// external student to show profile
  final Student? externalStudent;

  /// toggle app bar
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

    final storageApi = ref.read(cloudStorageProvider);

    final studentService = ref.watch(studentStoreProvider);

    final img = ref.watch(pickedImgProvider);

    final student = widget.externalStudent ?? currentStudent;

    final _isOwner = widget.externalStudent == null;

    final profPic = student?.profilePicture ?? '';

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
                  child: AdvancedAvatar(
                    size: 120,
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: !_isOwner
                            ? const SizedBox.shrink()
                            : CircleAvatar(
                                backgroundColor: Theme.of(context).cardColor,
                                child: updatingProfile
                                    ? const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      )
                                    : IconButton(
                                        onPressed: !_isOwner
                                            ? () {}
                                            : () async {
                                                final imgSource =
                                                    await ImageSourceSelector(
                                                  context,
                                                );

                                                if (imgSource != null) {
                                                  await customImgPicker(
                                                    ref,
                                                    isCamera: imgSource,
                                                  );

                                                  // upload student img
                                                  if (img != null) {
                                                    setState(() {
                                                      updatingProfile = true;
                                                    });

                                                    // upload img to cloud
                                                    final imgUrls = await storageApi
                                                        .uploadMultipleMediaFile(
                                                      images: [img.path],
                                                      path: CloudStoragePath
                                                          .kProfilePicture(
                                                        student!.id!,
                                                      ),
                                                    );

                                                    if (imgUrls.isNotEmpty) {
                                                      AppDialog.showToast(
                                                        'profile image uploaded',
                                                      );

                                                      // update profile pic
                                                      await studentService
                                                          .updateStudent(
                                                        student.copyWith(
                                                          profilePicture:
                                                              imgUrls.first,
                                                        ),
                                                      );
                                                    } else {
                                                      AppDialog.showToast(
                                                        'failed to upload profile image',
                                                      );
                                                    }

                                                    // reset img provider
                                                    ref
                                                        .read(
                                                          pickedImgProvider
                                                              .notifier,
                                                        )
                                                        .state = null;
                                                  }

                                                  setState(() {
                                                    updatingProfile = false;
                                                  });
                                                }
                                              },
                                        color: AppColors.kGreyShadeColor,
                                        icon: const Icon(Icons.camera_alt),
                                      ),
                              ),
                      ),
                    ],
                    decoration: BoxDecoration(
                      color: AppColors.kPrimaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    name: student?.name,
                    child: profPic.isEmpty
                        ? null
                        : CircleAvatar(
                            radius: 120,
                            backgroundImage: NetworkImage(profPic),
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
                      padding: const EdgeInsets.all(8),
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
                                        updateAboutAliasModal(
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
                                      : AppColors.kGreyShadeColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            student!.about.isEmpty
                                ? "Hey 👋 I'm using MiniCampus"
                                : student.about,
                            style:
                                Theme.of(context).textTheme.subtitle2?.copyWith(
                                      fontSize: 13,
                                      color: AppColors.kGreyShadeColor,
                                    ),
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
                                    fontSize: 11,
                                    color: AppColors.kGreyShadeColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ProfileStatsCard(externalStudent: widget.externalStudent),
                const SizedBox(height: 30),
                ExpansionTile(
                  title: const Text('Profile'),
                  children: [
                    if (_isOwner)
                      CustomFormField(
                        context: context,
                        formName: 'email',
                        readOnly: true,
                        initialText: student.email,
                        title: 'Email',
                      )
                    else
                      const SizedBox.shrink(),
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
                        [FormBuilderValidators.required(errorText: '')],
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
                        [FormBuilderValidators.required(errorText: '')],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isOwner)
                      Row(
                        children: [
                          Expanded(
                            child: CustomRoundedButton(
                              text: toggleOwnerProfileEdit ? 'Edit' : 'Update',
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
                                        final _data =
                                            updateFormKey.currentState!.value;

                                        // check for changes, minimize fb writes
                                        if (_data['phone'] ==
                                                student.whatsappNumber &&
                                            _data['location'] ==
                                                student.campusLocation) {
                                          AppDialog.showToast(
                                            'no changes detected',
                                          );

                                          setState(() {
                                            toggleOwnerProfileEdit = true;
                                          });

                                          return;
                                        }

                                        var _appNumber = '';

                                        // verify num
                                        if (_data['phone']
                                            .toString()
                                            .isNotEmpty) {
                                          final isValidNumber =
                                              await contactHelper(
                                            _data['phone'] as String,
                                          );

                                          if (isValidNumber == null) {
                                            AppDialog.showTopFlash(
                                              context,
                                              title: 'Mobile Number',
                                              mesg:
                                                  'Invalid mobile number, please double check and try again!',
                                            );
                                            return;
                                          }

                                          _appNumber = isValidNumber;
                                        }

                                        modalLoader(context);

                                        // update student
                                        final _student = student.copyWith(
                                          whatsappNumber: _appNumber,
                                          campusLocation:
                                              _data['location'] as String,
                                        );

                                        final _updated = await studentService
                                            .updateStudent(_student);

                                        Navigator.of(
                                          context,
                                          rootNavigator: true,
                                        ).pop();

                                        if (_updated == null) {
                                          AppDialog.showTopFlash(
                                            context,
                                            title: 'Account',
                                            mesg:
                                                'Failed to update account. Try again later',
                                          );
                                        }

                                        // success
                                        else {
                                          AppDialog.showTopFlash(
                                            context,
                                            title: 'Account',
                                            mesg:
                                                'Your account has been updated!',
                                          );

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
                    else
                      const SizedBox.shrink(),
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

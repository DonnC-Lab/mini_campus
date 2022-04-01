// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:mini_campus/src/shared/constants/index.dart';
import 'package:relative_scale/relative_scale.dart';

import 'custom_input_decoration.dart';
import 'form_constants.dart';

Widget CustomDateField({
  String? title,
  required BuildContext context,
  required String? formName,
  TextEditingController? controller,
  FormFieldValidator<DateTime?>? validator,
  DateFormat? format,
  String hintText = '',
  String? initialText,
  bool autoFocus = false,
  int maxLines = 1,
  bool obscureText = false,
  bool isPhoneField = false,
  bool readOnly = false,
  bool enforceLength = false,
  bool unfocus = false,
  TextInputType? keyboardType = TextInputType.text,
  Color? titleColor,
  Function? customOnChangeCallback,

  /// determine if this is a custom phone input field or general textfield. Text by default
  String labelText = '',
  Widget suffixIcon = const SizedBox.shrink(),
}) {
  return RelativeBuilder(
    builder: (context, height, width, sy, sx) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title ?? '', style: titleTextStyle(context)),
            customDateField(
              formName: formName,
              context: context,
              controller: controller,
              hintText: hintText,
              maxLines: maxLines,
              autoFocus: autoFocus,
              format: format,
              obscureText: obscureText,
              readOnly: readOnly,
              validator: validator,
              labelText: labelText,
              enforceLength: enforceLength,
              unfocus: unfocus,
              suffixIcon: suffixIcon,
              keyboardType: keyboardType,
              initialText: initialText,
              customOnChangeCallback: customOnChangeCallback,
            ),
          ],
        ),
      );
    },
  );
}

Widget customDateField({
  TextEditingController? controller,
  required BuildContext context,
  TextInputType? keyboardType,
  String? initialText,
  String hintText = '',
  String? formName,
  int maxLines = 1,
  bool readOnly = false,
  bool obscureText = false,
  bool unfocus = false,
  bool enforceLength = false,
  String labelText = '',
  bool autoFocus = false,
  var customOnChangeCallback,
  FormFieldValidator<DateTime?>? validator,
  Widget suffixIcon = const SizedBox.shrink(),
  DateFormat? format,
}) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: FormBuilderDateTimePicker(
        name: formName!,
        controller: controller,
        autofocus: autoFocus,
        alwaysUse24HourFormat: true,
        format: format,
        validator: validator,
        transitionBuilder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
                colorScheme:
                    const ColorScheme.light().copyWith(primary: bluishColor)),
            child: child!,
          );
        },
        style: fieldTextStyle(context),
        inputType: InputType.date,
        maxLines: maxLines,
        obscureText: obscureText,
        // initialValue: DateTime.now(),
        onEditingComplete: () => unfocus
            ? FocusScope.of(context).unfocus()
            : FocusScope.of(context).nextFocus(),
        onChanged: customOnChangeCallback,
        decoration: CustomInputDecoration(
          radius: borderRadius,
          textStyle: fieldTextStyle(context)!,
          labelText: labelText,
          hintText: hintText,
          suffixIcon: suffixIcon,
        ),
      ),
    ),
  );
}

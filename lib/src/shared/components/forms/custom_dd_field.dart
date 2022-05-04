// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:relative_scale/relative_scale.dart';

import 'custom_input_decoration.dart';
import 'form_constants.dart';

Widget CustomDDField({
  String? title,
  required BuildContext context,
  required String? formName,
  TextEditingController? controller,
  required List<DropdownMenuItem<Object?>> items,
  FormFieldValidator<Object>? validator,
  String hintText = '',
  String? initialText,
  bool autoFocus = false,
  int maxLines = 1,
  bool obscureText = false,
  bool isPhoneField = false,
  bool readOnly = false,
  bool enforceLength = false,
  bool unfocus = true,
  Widget hint = const Text(
    '-- select --',
    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
  ),
  TextInputType? keyboardType = TextInputType.text,
  Color? titleColor,
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
            Text(
              title ?? '',
              style: titleTextStyle(context),
            ),
            customDropDownField(
              formName: formName,
              context: context,
              controller: controller,
              hintText: hintText,
              maxLines: maxLines,
              autoFocus: autoFocus,
              obscureText: obscureText,
              readOnly: readOnly,
              validator: validator,
              labelText: labelText,
              enforceLength: enforceLength,
              unfocus: unfocus,
              suffixIcon: suffixIcon,
              hint: hint,
              keyboardType: keyboardType,
              initialText: initialText,
              items: items,
            ),
          ],
        ),
      );
    },
  );
}

Widget customDropDownField({
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
  required List<DropdownMenuItem<Object?>> items,
  var customOnChangeCallback,
  FormFieldValidator<Object>? validator,
  Widget suffixIcon = const SizedBox.shrink(),
  Widget hint = const Text('-- select --'),
}) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: FormBuilderDropdown<Object?>(
        name: formName!,
        hint: hint,
        initialValue: initialText,
        autofocus: autoFocus,
        style: fieldTextStyle(context),
        validator: validator,
        items: items,
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

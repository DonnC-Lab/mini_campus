// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:mini_campus_components/src/forms/index.dart';

/// custom datetime field
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
  void Function(DateTime?)? customOnChangeCallback,
  String labelText = '',
  Widget suffixIcon = const SizedBox.shrink(),
  InputType inputType = InputType.date,
}) {
  return Padding(
    padding: const EdgeInsets.all(5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title == null)
          const SizedBox.shrink()
        else
          Text(title, style: titleTextStyle(context)),
        _customDateField(
          formName: formName,
          context: context,
          controller: controller,
          hintText: hintText,
          maxLines: maxLines,
          autoFocus: autoFocus,
          format: format,
          inputType: inputType,
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
}

Widget _customDateField({
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
  InputType inputType = InputType.date,
  void Function(DateTime?)? customOnChangeCallback,
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
        format: format,
        validator: validator,
        transitionBuilder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light().copyWith(
                primary: Theme.of(context).appBarTheme.backgroundColor,
              ),
            ),
            child: child!,
          );
        },
        style: fieldTextStyle(context),
        inputType: inputType,
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

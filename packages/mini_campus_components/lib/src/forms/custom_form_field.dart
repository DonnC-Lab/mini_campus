// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mini_campus_components/src/forms/index.dart';

/// custom [FormBuilderTextField] widget
Widget CustomFormField({
  String? title,
  required BuildContext context,
  required String? formName,
  FocusNode? focusNode,
  TextEditingController? controller,
  String validateError = '',
  FormFieldValidator<String>? validator,
  String hintText = '',
  String? initialText,
  bool autoFocus = false,
  int maxLines = 1,
  bool obscureText = false,
  bool isPhoneField = false,
  bool readOnly = false,
  bool enforceLength = false,
  int? maxLength,
  bool unfocus = false,
  bool filled = true,
  ThemeMode themeMode = ThemeMode.system,
  TextInputType? keyboardType = TextInputType.text,
  Color? titleColor,
  void Function(String?)? customOnChangeCallback,
  String labelText = '',
  Widget suffixIcon = const SizedBox.shrink(),
  Widget? prefixIcon,
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
        _customTextField(
          formName: formName,
          context: context,
          controller: controller,
          hintText: hintText,
          maxLength: maxLength,
          maxLines: maxLines,
          autoFocus: autoFocus,
          obscureText: obscureText,
          prefixIcon: prefixIcon,
          readOnly: readOnly,
          errorString: validateError,
          validator: validator,
          labelText: labelText,
          enforceLength: enforceLength,
          unfocus: unfocus,
          focusNode: focusNode,
          suffixIcon: suffixIcon,
          keyboardType: keyboardType,
          initialText: initialText,
          customOnChangeCallback: customOnChangeCallback,
          filled: filled,
          themeMode: themeMode,
        ),
      ],
    ),
  );
}

Widget _customTextField({
  TextEditingController? controller,
  required BuildContext context,
  FocusNode? focusNode,
  TextInputType? keyboardType,
  String? initialText,
  String hintText = '',
  String? formName,
  int maxLines = 1,
  bool readOnly = false,
  bool obscureText = false,
  bool unfocus = false,
  bool enforceLength = false,
  int? maxLength,
  String labelText = '',
  bool autoFocus = false,
  bool filled = true,
  ThemeMode themeMode = ThemeMode.system,
  void Function(String?)? customOnChangeCallback,
  FormFieldValidator<String>? validator,
  String errorString = 'this field is required',
  Widget suffixIcon = const SizedBox.shrink(),
  Widget? prefixIcon,
}) {
  return Padding(
    padding: const EdgeInsets.all(12),
    child: Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(borderRadius)),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ThemeData()
              .colorScheme
              .copyWith(primary: Theme.of(context).primaryIconTheme.color),
        ),
        child: FormBuilderTextField(
          name: formName!,
          readOnly: readOnly,
          focusNode: focusNode,
          initialValue: initialText,
          controller: controller,
          autofocus: autoFocus,
          style: fieldTextStyle(context),
          maxLines: maxLines,
          maxLength: enforceLength ? maxLength : null,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          onEditingComplete: () => unfocus
              ? FocusScope.of(context).unfocus()
              : FocusScope.of(context).nextFocus(),
          onChanged: customOnChangeCallback,
          decoration: CustomInputDecoration(
            radius: borderRadius,
            themeMode: themeMode,
            filled: filled,
            prefixIcon: prefixIcon,
            textStyle: fieldTextStyle(context)!,
            labelText: labelText,
            hintText: hintText,
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    ),
  );
}

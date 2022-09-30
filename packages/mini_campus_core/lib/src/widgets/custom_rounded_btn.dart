import 'package:flutter/material.dart';
import 'package:mini_campus_constants/mini_campus_constants.dart';

/// Custom [StatelessWidget]
///
/// create an outlined / border rounded button
class CustomRoundedButton extends StatelessWidget {
  /// Custom [StatelessWidget]
  ///
  /// create an outlined / border rounded button
  const CustomRoundedButton({
    super.key,
    required this.text,
    this.onTap,
    this.widthRatio = 1.0,
    this.height = 52,
    this.isOutlined = false,
    this.radius = 12,
    this.fontWeight = FontWeight.w600,
  });

  /// button text to display
  final String text;

  /// optional callback on button press
  final VoidCallback? onTap;

  /// button width as %age of device width size
  final double widthRatio;

  /// button height
  final double height;

  /// toggle between border or outlined button type
  final bool isOutlined;

  /// circular border radius
  final double radius;

  /// button text font weight
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor:
            isOutlined ? AppColors.kPrimaryColor : AppColors.kLightShadeColor,
        backgroundColor:
            isOutlined ? AppColors.kLightShadeColor : AppColors.kPrimaryColor,
        side: const BorderSide(color: AppColors.kPrimaryColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        fixedSize: Size(MediaQuery.of(context).size.width * widthRatio, height),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              // color: isOutlined ?
              // AppColors.kPrimaryColor : AppColors.kLightShadeColor,
              color: Colors.white,
              fontWeight: fontWeight,
            ),
      ),
    );
  }
}

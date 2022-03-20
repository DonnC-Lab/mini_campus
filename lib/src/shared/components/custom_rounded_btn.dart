import 'package:flutter/material.dart';
import 'package:mini_campus/src/shared/constants/index.dart';

class CustomRoundedBtn extends StatelessWidget {
  const CustomRoundedBtn({
    Key? key,
    required this.text,
    this.onTap,
    this.widthRatio = 0.8,
    this.height = 50,
    this.isOutlined = false,
    this.radius = 13,
    this.fontWeight = FontWeight.w600,
  }) : super(key: key);

  final String text;
  final VoidCallback? onTap;

  /// button width as %age of device width size
  final double widthRatio;
  final double height;
  final bool isOutlined;
  final double radius;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: isOutlined
            ? Theme.of(context).scaffoldBackgroundColor
            : bluishColor,
        onPrimary: isOutlined
            ? bluishColor
            : Theme.of(context).scaffoldBackgroundColor,
        side: const BorderSide(color: bluishColor, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        fixedSize: Size(
          MediaQuery.of(context).size.width * widthRatio,
          height,
        ),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyText2?.copyWith(
              color: isOutlined
                  ? bluishColor
                  : Theme.of(context).scaffoldBackgroundColor,
              fontWeight: fontWeight,
            ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.onTap,
      required this.child,
      this.enabled = true,
      this.color})
      : super(key: key);
  final VoidCallback onTap;
  final Widget child;
  final bool? enabled;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // Brightness _bright = Theme.of(context).brightness;
    d.init(context);
    return SizedBox(
      width: double.infinity,
      height: d.pSH(45),
      child: TextButton(
        // key: const Key('customButton'),
        style: TextButton.styleFrom(
          backgroundColor: color ?? AppColors.kPrimaryColor,
          textStyle: const TextStyle(color: Colors.white),
        ),
        onPressed: enabled! ? onTap : null,
        child: child,
      ),
    );
  }
}

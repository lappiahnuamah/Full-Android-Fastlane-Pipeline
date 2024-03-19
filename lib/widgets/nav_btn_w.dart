import 'package:flutter/material.dart';


class NavBtn extends StatelessWidget {
  const NavBtn({
    Key? key,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.iconSize,
    this.image
  }) : super(key: key);

  final IconData icon;
  final Color? iconColor;
  final Function() onTap;
  final double? iconSize;
  final String? image;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // print('Height:: ${size.height}');
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:EdgeInsets.only(
          top: size.height * 0.03 /*24.0*/,
          left: size.width * 0.04 /*16.0*/,
          right: size.width * 0.01 /*4.0*/
        ),
        child:

        Icon(icon,
          color: iconColor ?? Colors.black,
          size: iconSize ?? size.height * 0.03 /*24*/,
        ),
      ),
    );
  }
}
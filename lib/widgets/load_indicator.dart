import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_colors.dart';

class LoadIndicator extends StatelessWidget {
  const LoadIndicator({Key? key, this.child}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    d.init(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      color: Colors.black.withOpacity(0.4),
      child: Center(
          child:child?? SizedBox(
              height: d.pSH(120),
              width: d.pSH(120),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                        color: AppColors.kPrimaryColor),
                    SizedBox(
                      height: d.pSH(12),
                    ),
                    const Text(
                      'Loading...',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ))),
    );
  }
}

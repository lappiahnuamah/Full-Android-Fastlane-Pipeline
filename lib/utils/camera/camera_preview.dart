import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../widgets/page_template.dart';
import '../../constants.dart';
import '../../resources/app_colors.dart';

class CameraImagePreview extends StatefulWidget {
  const CameraImagePreview(
      {Key? key,
        required this.file,
        required this.onCancelled,
        required this.onProceed})
      : super(key: key);
  final File file;
  final VoidCallback onCancelled;
  final VoidCallback onProceed;

  @override
  State<CameraImagePreview> createState() => _CameraImagePreviewState();
}

class _CameraImagePreviewState extends State<CameraImagePreview> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      hasTopNav: false,
      child: SizedBox(
        height: d.getPhoneScreenHeight(),
        width: double.infinity,
        child: Stack(
          children: [
            SizedBox(
              height: d.getPhoneScreenHeight(),
              width: double.infinity,
              child:
                   Image.file(
                    widget.file,
                    height: d.getPhoneScreenHeight(),
                    fit: BoxFit.fill,
                  )
            ),
            Positioned(
              bottom: d.pSH(5),
              left: 0,
              right: 0,
              child: SizedBox(
                height: d.pSH(80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: d.pSH(60),
                      width: d.pSH(60),
                      child: TextButton(
                        onPressed: widget.onCancelled,
                        style: TextButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: AppColors.kGameRed ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: d.pSH(60),
                      width: d.pSH(60),
                      child: TextButton(
                        onPressed: widget.onProceed,
                        style: TextButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: AppColors.kPrimaryColor),
                        child: const Icon(
                          Icons.done,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
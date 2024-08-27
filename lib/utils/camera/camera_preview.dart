import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../widgets/page_template.dart';
import '../../constants.dart';
import '../../resources/app_colors.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview(
      {Key? key,
      required this.file,
      required this.onCancelled,
      required this.onProceed})
      : super(key: key);
  final File file;
  final VoidCallback onCancelled;
  final VoidCallback onProceed;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
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
      child: Container(
        color: Colors.black,
        height: d.getPhoneScreenHeight(),
        width: double.infinity,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                  height: d.getPhoneScreenHeight()*(1/2),
                  width: double.infinity,
                  child: Image.file(
                    widget.file,
                    height: d.getPhoneScreenHeight(),
                    fit: BoxFit.fill,
                  )),
            ),
            Positioned(
                bottom: d.pSH(25),
                right: d.pSH(20),
                child: FloatingActionButton(
                  onPressed: widget.onProceed,
                  heroTag: 'camera-upload-picture',
                  child: Icon(Icons.upload),
                )),
            Positioned(
                top: d.pSH(10),
                left: d.pSH(5),
                child: IconButton(
                    onPressed: widget.onCancelled,
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ))),
          ],
        ),
      ),
    );
  }
}

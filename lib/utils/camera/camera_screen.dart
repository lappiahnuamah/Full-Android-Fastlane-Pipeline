import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants.dart';
import '../../resources/app_colors.dart';
import 'camera_preview.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraScreen({Key? key, required this.cameras}) : super(key: key);
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  bool _isRearCameraSelected = true;
  PageController controller = PageController(initialPage: 0);
  int currentIndex = 0;
  File file = File('');
  bool hideRedDot = false;

  @override
  void initState() {
    super.initState();
    initCamera(widget.cameras![0]);
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (val) {
            currentIndex = val;
          },
          children: [
            Stack(
              children: [
                Positioned(
                  right: 0,
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: CameraPreview(
                    _cameraController,
                  ),
                ),


                ///////////////////////// Gallery, Camera, Switch Camera /////////////////
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 90,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 25, vertical: d.pSH(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        SizedBox(
                          height: d.pSH(40),
                          width: d.pSH(40),
                        ),
                        ////////////// Take Picture /////////////////
                        TextButton(
                          onPressed:takePicture,

                          style: TextButton.styleFrom(
                            shape: const CircleBorder(
                              side: BorderSide(color: Colors.white),
                            ),
                            visualDensity: VisualDensity.comfortable,
                          ),
                          child: Icon(
                            Icons.circle,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        /////// / Rotate Camera /////////
                        _cameraController.value.isRecordingVideo
                            ? const SizedBox(height: 20, width: 30)
                            : IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 32,
                          icon: Icon(
                              _isRearCameraSelected
                                  ? CupertinoIcons.switch_camera
                                  : CupertinoIcons.switch_camera_solid,
                              color: Colors.white),
                          onPressed: () {
                            setState(() => _isRearCameraSelected =
                            !_isRearCameraSelected);
                            initCamera(widget
                                .cameras![_isRearCameraSelected ? 0 : 1]);
                          },
                        )
                      ],
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ////////////////////////////////////////////
                        ////////////// Pop /////////////////
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context, file);
                          },
                          padding: EdgeInsets.zero,
                          iconSize: 30,
                          constraints: const BoxConstraints(),
                          icon:
                          const Icon(Icons.arrow_back, color: Colors.white),
                        ),

                        /////// / Flash Light /////////
                        _cameraController.value.isRecordingVideo
                            ? hideRedDot
                            ? const SizedBox()
                            : Container(
                          height: d.pSH(20),
                          width: d.pSH(20),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.kPrimaryColor),
                        )
                            : IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 30,
                          icon: Icon(
                              _cameraController.value.flashMode ==
                                  FlashMode.off
                                  ? Icons.flash_off
                                  : _cameraController.value.flashMode ==
                                  FlashMode.torch
                                  ? Icons.flash_on
                                  : Icons.flash_auto,
                              color: Colors.white),
                          onPressed: _cameraController.value.flashMode ==
                              FlashMode.off
                              ? () {
                            _cameraController
                                .setFlashMode(FlashMode.torch)
                                .then((value) {
                              setState(() {});
                            });
                          }
                              : _cameraController.value.flashMode ==
                              FlashMode.torch
                              ? () {
                            _cameraController
                                .setFlashMode(FlashMode.auto)
                                .then((value) {
                              setState(() {});
                            });
                          }
                              : () {
                            _cameraController
                                .setFlashMode(FlashMode.off)
                                .then((value) {
                              setState(() {});
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),

            //////////////////// Image or Video Preview ///////////////
            CameraImagePreview(
              file: file,
              onCancelled: () {
                controller.animateToPage(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
              },
              onProceed: () {
                //TODO: Upload file to server
                Navigator.pop(context, file);
              },
            )
          ],
        ),
      ),
    );
  }

  Future initCamera(CameraDescription cameraDescription) async {
// create a CameraController
    _cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
    );
    lg("Lens direction ${_cameraController.description.lensDirection.name}");
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      lg("Camera error $e");
    }
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      await _cameraController.setFlashMode(FlashMode.off);
      await _cameraController.takePicture().then((value) async {
        if (_cameraController.description.lensDirection.name == "back") {
          file = File(value.path);
        } else {
          Directory documentDirectory =
          await getApplicationDocumentsDirectory();
          final path =
          join(documentDirectory.path, "$FRONT_CAMERA_FLAG-${value.name}");
          value.saveTo(path);
          file = File(path);
        }

        if (file.path.isNotEmpty) {
          controller.animateToPage(1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.linear);
          setState(() {});
        }
        //_cameraController.resumePreview();
      });
    } on CameraException catch (e) {
      lg('Error occured while taking picture: $e');
      return null;
    }
  }



  @override
  void dispose() {

    super.dispose();
  }
}
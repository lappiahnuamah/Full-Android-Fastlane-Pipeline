import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../widgets/page_template.dart';
import '../../constants.dart';
import '../../functions/user_functions.dart';
import '../../widgets/load_indicator.dart';
import '../func_new.dart';

class FullViewScreen extends StatefulWidget {
  const FullViewScreen({
    Key? key,
    required this.file,
  }) : super(key: key);
  final File file;

  @override
  State<FullViewScreen> createState() => _FullViewScreenState();
}

class _FullViewScreenState extends State<FullViewScreen> {
  bool updatingPhoto = false;
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
     
      floatingActionBtn: FloatingActionButton(

          onPressed: ()async {
            //TODO: Upload file to server
            setState(() {
              updatingPhoto = true;
            });
            final result =
                await UserFunctions.updateProfilePicture(
                context: context,
                displayImage: widget.file.path);
            if (result != null) {
              Fluttertoast.showToast(
                  msg: 'Profile Photo updated successfully');
              Navigator.pop(context);
            } else {
              Fluttertoast.showToast(
                  msg:
                  'Oops something went wrong. Please try again.');
              setState(() {
                updatingPhoto = false;
              });
            }
          },
        child: Icon(Icons.upload),
        heroTag: 'upload-picture',),
      child: Container(
        color: Colors.black,
        height: d.getPhoneScreenHeight(),
        width: double.infinity,
        child: Stack(
          key: UniqueKey(),
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      height: d.getPhoneScreenHeight()/2,
                      width: double.infinity,
                      child: Image.file(
                        widget.file,
                        height: d.getPhoneScreenHeight(),
                        fit: BoxFit.fill,
                      )),
                ),
                
                Positioned(
                    top: d.pSH(10),
                    left: d.pSH(5),
                    child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white,),
                  onPressed: (){
                    Navigator.pop(context);

                  },
                ))
              ],
            ),
            ///////////////////////////////////////////////////////////
            ///////////// CIRCULAR PROGRESS INDICATOR///////////////////
            /////////////////////////////////////////////////////////
            updatingPhoto
                ? LoadIndicator(
                    child: appDialog(
                        context: context,
                        loadingMessage: "Updating picture..."))
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

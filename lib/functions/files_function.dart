import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../constants.dart';
import '../utils/connection_check.dart';

List<String> imageExtensions = ['jpg','jpeg','png'];

class FilesFunction {
  
  static Future<File?> pickFile(
      {required List<String> extensions,
      FileType fileType = FileType.any}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: extensions.isNotEmpty ? FileType.custom : fileType,
        allowedExtensions: extensions.isNotEmpty ? extensions : null);

    if (result != null) {
      File file = File(result.files.single.path!);

      return file;
    } else {
      // User canceled the picker
      return null;
    }
  }

  static Future<List<File?>> pickFiles({
    required FileType type,
    List<String>? allowedExtensions,
  }) async {

    List<File> files = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: type,
      allowMultiple: true,
      allowedExtensions: allowedExtensions,
    );

    if (result != null) {
      for (var platformFile in result.files) {
        if (Platform.isIOS) {
          File file = File(platformFile.path ?? '');
          final documentPath = (await getApplicationDocumentsDirectory()).path;
          file = await file.copy('$documentPath/${path.basename(file.path)}');
          files.add(file);
        } else {
          files.add(File(platformFile.path!));
        }
      }

      return files;
    } else {
      // User canceled the picker
      return [];
    }
  }

  static Future<List<File?>> pickLocalFiles(
      {required List<String> extensions,
      FileType fileType = FileType.any}) async {
    List<File> files = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: extensions.isNotEmpty ? FileType.custom : fileType,
        allowMultiple: true,
        allowedExtensions: extensions.isNotEmpty ? extensions : null);

    if (result != null) {
      for (var platformFile in result.files) {
        files.add(File(platformFile.path!));
      }

      return files;
    } else {
      // User canceled the picker
      return [];
    }
  }


  Future createGroupChat(
      {required BuildContext context,
        required String displayTitle,
        required String displayImage,
        required String accessToken,
        required String groupDescription,
        required List<int> members}) async {
    if (await ConnectionCheck().hasConnection()) {
      try {

        Map<String, dynamic> _data = {
          "members": members,
          "title": displayTitle,
          "chatroom_type": "Group",
          "description": groupDescription,
          'image': await MultipartFile.fromFile(displayImage)
        };

        var formData = FormData.fromMap(_data);

        var _res = await Dio().post('',
            data: formData,
            options: Options(
              contentType: 'multipart/form-data',
              headers: {"Authorization": "Bearer  $accessToken"},
              responseType: ResponseType.json,
            ));
        if (_res.statusCode == 201) {
          return true;
        } else {
          lg('${_res.data}');
          // showSnackBar(context, 'Failed to create chatroom');
          return false;
        }
      } catch (e) {
        //showSnackBar(context, 'Failed to create chatroom');
        lg('e: $e');
        return false;
      }
    } else {
      //showSnackBar(context, 'No internet connection');
      return false;
    }
  }


}
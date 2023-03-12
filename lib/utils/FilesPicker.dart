import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../screens/fragments/SVAddPostFragment.dart';

int isImagePicked = 0;

var path;
pickFile(context) async {
  int fromCamera = 0;
  await AwesomeDialog(
    context: context,
    dialogType: DialogType.info,
    borderSide: const BorderSide(
      color: Colors.green,
      width: 2,
    ),
    btnCancelText: "Camera",
    btnCancelColor: Colors.black,
    btnOkColor: Colors.black,
    btnOkText: "Gallary",
    width: 280,
    buttonsBorderRadius: const BorderRadius.all(
      Radius.circular(2),
    ),
    dismissOnTouchOutside: false,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: false,
    animType: AnimType.bottomSlide,
    title: 'Add Photo!',
    //desc: 'This Dialog can be dismissed touching outside',
    showCloseIcon: true,
    btnCancelOnPress: () {
      fromCamera = 1;
    },
    btnOkOnPress: () {
      fromCamera = 2;
    },
  ).show();
  List<AssetEntity>? result = [];
  AssetEntity? entity;
  if (fromCamera == 2) {
    result = await AssetPicker.pickAssets(context,
        pickerConfig: const AssetPickerConfig());
    if (result != null) {
      var f = await result[0].file;
      path = f;
      if (result[0].type == AssetType.image) {
        isImagePicked = 1;
        // SVAddPostFragment.assetEntity = await f.readAsBytes();
      } else {
        isImagePicked = 2;
      }
      SVAddPostFragment.isImage = true;
    }
  } else if (fromCamera == 1) {
    entity = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: CameraPickerConfig(
          textDelegate: cameraPickerTextDelegateFromLocale(const Locale('en')),
          enableAudio: true,
          enablePinchToZoom: true,
          enableRecording: true,
          enableTapRecording: true,
          maximumRecordingDuration: const Duration(seconds: 30),
          enablePullToZoomInRecord: true),
    );
    if (entity != null) {
      var f = await entity.file;

      path = f;
      if (entity.type == AssetType.image) {
        isImagePicked = 1;
        // SVAddPostFragment.assetEntity = await f.readAsBytes();
      } else {
        isImagePicked = 2;
      }
      SVAddPostFragment.isImage = true;
    }
  }
  // final camera
  // print('shahid');
}

import 'package:biit_social/Controllers/PostController.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../Controllers/SettingController.dart';
import '../../utils/IPHandleClass.dart';
import '../../utils/SVConstants.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({super.key});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  String? path = "1";
  String status = "No file attached...";
  PlatformFile? file;

  getFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'xml'],
      );
      if (result!.count > 0) {
        path = result.files[0].path;
        file = result.files[0];
      } else {
        path = "1";
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      status = 'File attached';
    });
  }

  @override
  Widget build(BuildContext context) {
    IPHandle.settingController = context.read<SettingController>();
    var postController = context.read<PostController>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        bottom: context.watch<SettingController>().isConnected
            ? null
            : PreferredSize(
                preferredSize: Size(context.width(), context.width() * 0.01),
                child: Container(
                  height: context.height() * 0.013,
                  width: context.width(),
                  color: Colors.red,
                  child: FittedBox(
                    child: Center(
                        child: Text(
                      'No internet connection!',
                      style: TextStyle(
                          fontFamily: svFontRoboto, color: Colors.white),
                    )),
                  ),
                )),
        title: const Text(
          'Upload',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                getFile();
                //await get();
              },
              child: Container(
                height: 130,
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    color: context.primaryColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.browse_gallery_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Upload File",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ).cornerRadiusWithClipRRect(10),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(status),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  String toUpload = '';
                  if (path != "1") {
                    await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('To Upload?'),
                        content: SizedBox(
                          height: context.height() * 0.2,
                          child: Column(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    toUpload = 'timeTable';
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Time Table')),
                              TextButton(
                                  onPressed: () {
                                    toUpload = 'dateSheet';
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Date Sheet')),
                            ],
                          ),
                        ),
                      ),
                    );
                    if (toUpload != '') {
                      // ignore: use_build_context_synchronously
                      postController.uploadFile(path, context, toUpload);
                    }
                  } else {
                    EasyLoading.showToast('please select file.');
                  }
                },
                child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}

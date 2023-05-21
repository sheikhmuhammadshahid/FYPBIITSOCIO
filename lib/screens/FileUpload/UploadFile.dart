import 'dart:io';

import 'package:biit_social/Controllers/PostController.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:excel/excel.dart' as ex;

class UploadFile extends StatefulWidget {
  const UploadFile({super.key});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  String? path = "1";
  String status = "No file attached...";
  PlatformFile? file;
  get() async {
    try {
      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'xml'],
        allowMultiple: false,
      );

      /// file might be picked

      var bytes = await File(pickedFile!.files[0].path!).readAsBytes();
      var excel = ex.Excel.createExcel();
      for (var table in excel.tables.keys) {
        print(table); //sheet Name

        for (var row in excel.tables[table]!.rows) {
          for (var element in row) {
            print(element.toString());
          }
        }
      }
    } catch (e) {}
  }

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
    var postController = context.read<PostController>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
                          height: context.height() * 0.3,
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
                              TextButton(
                                  onPressed: () {
                                    toUpload = 'callender';
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Callender'))
                            ],
                          ),
                        ),
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    postController.uploadFile(path, context, toUpload);
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

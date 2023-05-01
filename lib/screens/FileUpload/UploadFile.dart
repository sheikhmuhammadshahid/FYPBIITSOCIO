import 'package:biit_social/Controllers/PostController.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

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
        allowedExtensions: ['xlsx', 'xls', 'xml', 'pdf'],
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
              onTap: () {
                getFile();
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
                onPressed: () {
                  if (path != "1") {
                    postController.uploadFile(path, context);
                  }
                },
                child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}

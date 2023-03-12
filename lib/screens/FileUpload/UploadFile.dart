import 'package:biit_social/Controllers/PostController.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({super.key});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  String? path = "no file uploaded";
  getFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'xml'],
      );
      if (result!.count > 0) {
        path = result.files[0].path;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var postController = Provider.of<PostController>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  getFile();
                },
                child: const Text('Upoaed')),
            Text(path!),
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

import 'package:biit_social/utils/SVCommon.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/FilesPicker.dart';
import 'GroupsListScreen.dart';

class SvCreateGroupScreen extends StatefulWidget {
  const SvCreateGroupScreen({super.key});

  @override
  State<SvCreateGroupScreen> createState() => _SvCreateGroupScreenState();
}

class _SvCreateGroupScreenState extends State<SvCreateGroupScreen> {
  TextEditingController titleController = TextEditingController();
  String? category;
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 90,
                        backgroundImage:
                            AssetImage('images/socialv/faces/face_4.png'),
                      ),
                      Positioned(
                          bottom: 10,
                          right: 30,
                          child: GestureDetector(
                            onTap: () {
                              pickFile(context);
                            },
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: 50,
                              color: context.primaryColor,
                            ),
                          ))
                    ],
                  ),
                  svGetTextField(context,
                      hint: 'Group Title',
                      label: 'Group Title',
                      controller: titleController),
                  svGetTextField(context,
                      inputBorder: const OutlineInputBorder(),
                      maxLine: 5,
                      hint: 'Description',
                      label: 'Description',
                      controller: descriptionController),
                  svGetTextField(context,
                      hint: 'Category', readOnly: true, onTap: () {}),
                  const SizedBox(
                    height: 50,
                  ),
                  svAppButton(
                      context: context,
                      text: 'Add Members',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupsListScreen(
                                toShow: 'Add Member',
                              ),
                            ));
                      },
                      width: MediaQuery.of(context).size.width),
                ],
              ),
            )));
  }
}

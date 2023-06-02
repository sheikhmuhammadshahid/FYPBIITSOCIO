import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart' as aws;
import 'package:biit_social/utils/SVCommon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import '../../../Controllers/AuthController.dart';
import '../../../Controllers/SettingController.dart';
import '../../../utils/IPHandleClass.dart';
import '../../../utils/SVColors.dart';
import '../../../utils/SVConstants.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController sectionController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = loggedInUser!.name!;
    email.text = loggedInUser!.email!;
    phone.text = loggedInUser!.phone!;
    sectionController.text = loggedInUser!.section ?? '';
    file = null;
  }

  bool isChanged = false;
  late AuthController authController;
  @override
  Widget build(BuildContext context) {
    authController = context.read<AuthController>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
        ),
        backgroundColor: context.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GetProfileScreen().paddingOnly(left: 30),
              // 10.height,
              Form(
                key: formKey,
                child: Column(
                  children: [
                    20.height,
                    AppTextField(
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        }
                        return "Please enter aridNo or CNIC!";
                      },
                      onChanged: (p0) => isChanged = true,
                      controller: nameController,
                      textFieldType: TextFieldType.OTHER,
                      textStyle: boldTextStyle(),
                      decoration: svInputDecoration(
                        context,
                        label: 'email',
                        labelStyle: secondaryTextStyle(
                            weight: FontWeight.w600, color: svGetBodyColor()),
                      ),
                    ).paddingSymmetric(horizontal: 16),
                    8.height,
                    AppTextField(
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        }
                        return "Please enter email!";
                      },
                      onChanged: (p0) => isChanged = true,
                      controller: email,
                      textFieldType: TextFieldType.OTHER,
                      textStyle: boldTextStyle(),
                      decoration: svInputDecoration(
                        context,
                        label: 'Username',
                        labelStyle: secondaryTextStyle(
                            weight: FontWeight.w600, color: svGetBodyColor()),
                      ),
                    ).paddingSymmetric(horizontal: 16),
                    8.height,
                    AppTextField(
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        }
                        return "Please enter phone!";
                      },
                      onChanged: (p0) => isChanged = true,
                      controller: phone,
                      textFieldType: TextFieldType.OTHER,
                      textStyle: boldTextStyle(),
                      decoration: svInputDecoration(
                        context,
                        label: 'Phone',
                        labelStyle: secondaryTextStyle(
                            weight: FontWeight.w600, color: svGetBodyColor()),
                      ),
                    ).paddingSymmetric(horizontal: 16),
                    8.height,
                    if (loggedInUser!.userType == "1")
                      AppTextField(
                        controller: sectionController,
                        enabled: false,
                        textFieldType: TextFieldType.OTHER,
                        textStyle: boldTextStyle(),
                        decoration: svInputDecoration(
                          context,
                          label: 'Section',
                          labelStyle: secondaryTextStyle(
                              weight: FontWeight.w600, color: svGetBodyColor()),
                        ),
                      ).paddingSymmetric(horizontal: 16),
                    8.height,
                    AppTextField(
                      validator: (value) {
                        if (value!.isEmpty && confirmPassword.text.isEmpty) {
                          return null;
                        } else if (confirmPassword.text.isNotEmpty) {
                          return "Please enter old password!";
                        }
                        return null;
                      },
                      onChanged: (p0) => isChanged = true,
                      controller: passwordController,
                      textFieldType: TextFieldType.PASSWORD,
                      textStyle: boldTextStyle(),
                      suffixIconColor: svGetBodyColor(),
                      suffixPasswordInvisibleWidget: Image.asset(
                              'images/socialv/icons/ic_Hide.png',
                              height: 16,
                              width: 16,
                              fit: BoxFit.fill)
                          .paddingSymmetric(vertical: 16, horizontal: 14),
                      suffixPasswordVisibleWidget:
                          svRobotoText(text: 'Show', color: SVAppColorPrimary)
                              .paddingOnly(top: 20),
                      decoration: svInputDecoration(
                        context,
                        label: 'Old-Password',
                        contentPadding: const EdgeInsets.all(0),
                        labelStyle: secondaryTextStyle(
                            weight: FontWeight.w600, color: svGetBodyColor()),
                      ),
                    ).paddingSymmetric(horizontal: 16),
                    16.height,
                    AppTextField(
                      onChanged: (p0) => isChanged = true,
                      validator: (value) {
                        if (value == null && passwordController.text.isEmpty) {
                          return null;
                        } else if (value != passwordController.text) {
                          return "Password must match!";
                        }
                        return null;
                      },
                      controller: confirmPassword,
                      textFieldType: TextFieldType.PASSWORD,
                      textStyle: boldTextStyle(),
                      suffixIconColor: svGetBodyColor(),
                      suffixPasswordInvisibleWidget: Image.asset(
                              'images/socialv/icons/ic_Hide.png',
                              height: 16,
                              width: 16,
                              fit: BoxFit.fill)
                          .paddingSymmetric(vertical: 16, horizontal: 14),
                      suffixPasswordVisibleWidget:
                          svRobotoText(text: 'Show', color: SVAppColorPrimary)
                              .paddingOnly(top: 20),
                      decoration: svInputDecoration(
                        context,
                        label: 'New-Password',
                        contentPadding: const EdgeInsets.all(0),
                        labelStyle: secondaryTextStyle(
                            weight: FontWeight.w600, color: svGetBodyColor()),
                      ),
                    ).paddingSymmetric(horizontal: 16),
                    40.height,
                    svAppButton(
                      context: context,
                      text: 'Update',
                      onTap: () async {
                        if ((formKey.currentState!.validate() && isChanged) ||
                            file != null) {
                          FormData f = FormData.fromMap({
                            'name': nameController.text,
                            'email': email.text,
                            'phone': phone.text,
                            'password': passwordController.text.isEmpty
                                ? loggedInUser!.password
                                : passwordController.text,
                            'CNIC': loggedInUser!.CNIC,
                            'image': file != null
                                ? await MultipartFile.fromFile(file!.path)
                                : null,
                          });
                          EasyLoading.showInfo('Saving',
                              duration: const Duration(minutes: 300));
                          var res = await authController.updateProfile(f);
                          EasyLoading.dismiss();
                          if (res) {
                            loggedInUser!.name = nameController.text;
                            loggedInUser!.email = email.text;
                            loggedInUser!.phone = phone.text;
                            loggedInUser!.password = passwordController.text;
                            authController.saveLoggedInUser();

                            EasyLoading.showSuccess(
                                'Profile updated Successfully!');
                          }
                        } else {
                          EasyLoading.showToast(
                              'Please update something to save');
                        }
                        //dynamic result = await userApi().Login(user, context);

                        //}
                        // SVDashboardScreen().launch(context);
                      },
                    ),
                    16.height,
                  ],
                ),
              )
            ],
          ),
        ).paddingOnly(top: 20),
      ),
    );
  }
}

int fromCamera = 0;
showAwesomeDialogue(BuildContext context) async {
  await aws.AwesomeDialog(
    context: context,
    dialogType: aws.DialogType.noHeader,
    borderSide: BorderSide(
      color: context.dividerColor,
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
    animType: aws.AnimType.bottomSlide,
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
}

XFile? file;

class GetProfileScreen extends StatefulWidget {
  const GetProfileScreen({
    super.key,
  });

  @override
  State<GetProfileScreen> createState() => _GetProfileScreenState();
}

class _GetProfileScreenState extends State<GetProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontFamily: svFontRoboto, color: context.iconColor),
        ),
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
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: context.height() * 0.15,
                width: context.width() * 0.4,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: file != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(file!.path)))
                        : loggedInUser!.profileImage == ''
                            ? const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'images/socialv/faces/face_4.png'))
                            : DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    IPHandle.profileimageAddress +
                                        loggedInUser!.profileImage))),
              ),
              Positioned(
                  bottom: 3,
                  right: 15,
                  child: IconButton(
                      onPressed: () async {
                        fromCamera = 0;

                        await showAwesomeDialogue(context);
                        if (fromCamera == 1) {
                          file = await ImagePicker()
                              .pickImage(source: ImageSource.camera);
                        } else if (fromCamera == 2) {
                          file = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                        }
                        if (file != null) {
                          setState(() {});
                        }
                      },
                      icon: Icon(
                        Icons.camera,
                        size: 30,
                        color: context.cardColor,
                      )))
            ],
          ),
        ],
      ),
    );
  }
}

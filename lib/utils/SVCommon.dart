import 'dart:io';

import 'package:biit_social/Controllers/FriendsStoriesController.dart';
import 'package:biit_social/models/User/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/main.dart';
import 'package:biit_social/screens/addPost/components/SVSharePostBottomSheetComponent.dart';
import 'package:biit_social/utils/SVColors.dart';
import 'package:biit_social/utils/SVConstants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

String ipp = '';
FriendsStoriesController? friendsStoriesController;

User? loggedInUser;
String ip = "http://192.168.87.231/BiitSocioApis/api/";
String imageAddress = "http://192.168.87.231/BiitSocioApis/postImages/";
String profileimageAddress = "http://192.168.87.231/BiitSocioApis/Images/";
String storyAddress = 'http://192.168.87.231/BiitSocioApis/Status/';
var headers = {"Content-Type": "application/json"};
String selectedOptions = "";
Future<String> getIp() async {
  try {
    // Get a list of network interfaces
    List<NetworkInterface> interfaces = await NetworkInterface.list();

    // Loop through the interfaces
    for (NetworkInterface ni in interfaces) {
      // Check if the interface is a WiFi interface
      if (ni.name.startsWith('Wi')) {
        // Get the gateway address of the WiFi interface
        List<InternetAddress> addresses = ni.addresses;
        for (InternetAddress address in addresses) {
          return 'http://${address.address}';
        }
      }
    }
  } catch (ex) {
    // Get.snackbar('', 'Could not load IP address.\nTry Again');
  }
  return 'http://';
}

getSelector(context, lable, List<Items> items) async {
  await showModalBottomSheet(
    isScrollControlled: true, // required for min/max child size
    context: context,
    builder: (ctx) {
      return MultiSelectBottomSheet<Items>(
        searchable: true,
        separateSelectedItems: true,
        searchHint: 'Search sections...',
        title: Text(lable),
        listType: MultiSelectListType.CHIP,

        items: items
            .map((animal) => MultiSelectItem<Items>(animal, animal.name!))
            .toList(),
        initialValue: const [],
        // .map((animal) =>Items(animal, animal))
        // .toList(),
        onConfirm: (values) {
          selectedOptions = "";
          for (Items i in values) {
            selectedOptions += "${i.name!}:";
          }
          print(selectedOptions);
        },
        maxChildSize: 0.8,
      );
    },
  );
}

getSnackBar(
    {context,
    String? message,
    Duration? duration = const Duration(seconds: 3),
    Color? backgroundColor}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message!,
      style: const TextStyle(color: Colors.white),
    ),
    duration: duration!,
    backgroundColor: Colors.black,
  ));
}

getPostsShimmer(context) {
  return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              height: 60,
              width: 60,
              color: Colors.white,
            ),
            title: Container(
              height: 20,
              width: double.infinity,
              color: Colors.white,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                Container(
                  height: 16,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 4),
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width - 32,
                  color: Colors.white,
                ),
              ],
            ),
          );
        },
      ));
}

getNotificationShimmer(context) {
  return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
            ),
            title: Container(
              height: 20,
              width: double.infinity,
              color: Colors.white,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 20,
                width: 150,
                color: Colors.white,
              ),
            ),
          );
        },
      ));
}

class Items {
  final int? id;
  final String? name;

  Items({
    this.id,
    this.name,
  });
}

InputDecoration svInputDecoration(BuildContext context,
    {String? hint,
    String? label,
    TextStyle? hintStyle,
    InputBorder? inputBorder,
    TextStyle? labelStyle,
    Widget? prefix,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixIcon}) {
  return InputDecoration(
    contentPadding: contentPadding,
    labelText: label,
    hintText: hint,
    hintStyle: hintStyle ?? secondaryTextStyle(),
    labelStyle: labelStyle ?? secondaryTextStyle(),
    prefix: prefix,
    prefixIcon: prefixIcon,
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    enabledBorder: inputBorder == null
        ? const UnderlineInputBorder(
            borderSide: BorderSide(color: SVAppBorderColor))
        : const OutlineInputBorder(
            borderSide: BorderSide(color: SVAppBorderColor)),
    focusedBorder: inputBorder == null
        ? const UnderlineInputBorder(
            borderSide: BorderSide(color: SVAppColorPrimary))
        : const OutlineInputBorder(
            borderSide: BorderSide(color: SVAppColorPrimary)),
    border: inputBorder == null
        ? const UnderlineInputBorder(
            borderSide: BorderSide(color: SVAppBorderColor))
        : const OutlineInputBorder(),
    focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0)),
    errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0)),
    alignLabelWithHint: true,
  );
}

Widget svGetTextField(BuildContext context,
    {String? hint,
    Function()? onTap,
    int? maxLine,
    InputBorder? inputBorder,
    bool readOnly = false,
    String? label,
    var validator,
    TextStyle? hintStyle,
    TextStyle? labelStyle,
    TextEditingController? controller,
    Widget? prefix,
    EdgeInsetsGeometry? contentPadding,
    Widget? prefixIcon}) {
  return Column(
    children: [
      const SizedBox(
        height: 20,
      ),
      TextFormField(
        maxLines: maxLine,
        onTap: onTap,
        validator: validator,
        readOnly: readOnly,
        controller: controller,
        decoration: svInputDecoration(context,
            hint: hint,
            label: label,
            inputBorder: inputBorder,
            hintStyle: hintStyle,
            labelStyle: labelStyle,
            prefix: prefix,
            contentPadding: contentPadding,
            prefixIcon: prefixIcon),
      ),
    ],
  );
}

Widget svRobotoText(
    {required String text,
    Color? color,
    FontStyle? fontStyle,
    Function? onTap,
    TextAlign? textAlign}) {
  return Text(
    text,
    style: secondaryTextStyle(
      fontFamily: svFontRoboto,
      color: color ?? svGetBodyColor(),
      fontStyle: fontStyle ?? FontStyle.normal,
    ),
    textAlign: textAlign ?? TextAlign.center,
  ).onTap(onTap,
      splashColor: Colors.transparent, highlightColor: Colors.transparent);
}

Color svGetBodyColor() {
  if (appStore.isDarkMode) {
    return SVBodyDark;
  } else {
    return SVBodyWhite;
  }
}

Color svGetScaffoldColor() {
  if (appStore.isDarkMode) {
    return appBackgroundColorDark;
  } else {
    return SVAppLayoutBackground;
  }
}

Widget svHeaderContainer(
    {required Widget child, required BuildContext context}) {
  return Stack(
    alignment: Alignment.bottomCenter,
    children: [
      Container(
        width: context.width(),
        decoration: BoxDecoration(
            color: SVAppColorPrimary,
            borderRadius: radiusOnly(
                topLeft: SVAppContainerRadius, topRight: SVAppContainerRadius)),
        padding: const EdgeInsets.all(24),
        child: child,
      ),
      Container(
        height: 20,
        decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: radiusOnly(
                topLeft: SVAppContainerRadius, topRight: SVAppContainerRadius)),
      )
    ],
  );
}

Widget svAppButton(
    {required String text,
    required Function onTap,
    double? width,
    required BuildContext context}) {
  return AppButton(
    shapeBorder:
        RoundedRectangleBorder(borderRadius: radius(SVAppCommonRadius)),
    text: text,
    textStyle: boldTextStyle(color: Colors.white),
    onTap: onTap,
    elevation: 0,
    color: SVAppColorPrimary,
    width: width ?? context.width() - 32,
    height: 56,
  );
}

Future<File> svGetImageSource() async {
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(source: ImageSource.camera);
  if (pickedImage != null) {
    return File(pickedImage.path);
  }
  return File('');
}

void svShowShareBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    backgroundColor: context.cardColor,
    shape: RoundedRectangleBorder(
        borderRadius: radiusOnly(topLeft: 30, topRight: 30)),
    builder: (context) {
      return const SVSharePostBottomSheetComponent();
    },
  );
}

sVProfileImageProvider(url, height, width) {
  return CachedNetworkImage(
    imageUrl: url,
    progressIndicatorBuilder: (context, url, downloadProgress) => GFAvatar(
      maxRadius: 30,
      // shape: GFAvatarShape.square,
      // backgroundColor: Colors.grey,
      // borderRadius: BorderRadius.circular(10),
      child: CircularProgressIndicator(
        value: downloadProgress.progress,
        color: Colors.white,
      ),
    ),
    errorWidget: (context, url, error) => const GFAvatar(
      maxRadius: 30,
      // borderRadius: BorderRadius.circular(10),
      backgroundColor: Colors.grey,
      child: Icon(
        Icons.error,
        size: 20,
      ),
    ),
    imageBuilder: (context, imageProvider) => GFAvatar(
      //shape: shape,
      backgroundImage: imageProvider,
      maxRadius: 30,
      //size: GFSize.LARGE,
      // borderRadius: BorderRadius.circular(10),
      // child: Image.network(
      //   url,
      //   height: height,
      //   filterQuality: FilterQuality.high,
      //   width: width,
      //   fit: BoxFit.contain,
      // ).cornerRadiusWithClipRRect(SVAppCommonRadius).center(),
      //size: 200,
    ),
  );
}

sVImageProvider(url, height, width, GFAvatarShape shape) {
  return SizedBox(
    height: height,
    width: width,
    child: CachedNetworkImage(
      imageUrl: url,
      progressIndicatorBuilder: (context, url, downloadProgress) => GFAvatar(
        maxRadius: 30,
        // shape: GFAvatarShape.square,
        // backgroundColor: Colors.grey,
        // borderRadius: BorderRadius.circular(10),
        child: CircularProgressIndicator(
          value: downloadProgress.progress,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => GFAvatar(
        maxRadius: 20,
        shape: shape,
        borderRadius: BorderRadius.circular(10),
        backgroundColor: Colors.grey,
        child: const Icon(
          Icons.error,
          size: 30,
        ),
      ),
      imageBuilder: (context, imageProvider) => GFAvatar(
        shape: shape,

        backgroundImage: width < 70.0 ? imageProvider : null,
        maxRadius: 50,
        //size: GFSize.LARGE,
        borderRadius: BorderRadius.circular(10),
        child: width > 70.0
            ? Image.network(
                url,
                filterQuality: FilterQuality.high,
              ).center()
            : null,
        //size: 200,
      ),
    ),
  );
}

onlineUserIcon(bool isOnline) {
  return isOnline
      ? const CircleAvatar(radius: 10, backgroundColor: Colors.green)
      : const SizedBox();
}

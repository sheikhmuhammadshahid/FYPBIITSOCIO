import 'package:biit_social/utils/SVCommon.dart';

class SVDrawerModel {
  String? title;
  String? image;

  SVDrawerModel({this.image, this.title});
}

List<SVDrawerModel> getDrawerOptions() {
  List<SVDrawerModel> list = [];

  list.add(SVDrawerModel(
      image: 'images/socialv/icons/ic_Profile.png', title: 'Profile'));
  if (loggedInUser!.userType != '4') {
    list.add(SVDrawerModel(
        image: 'images/socialv/icons/ic_2User.png', title: 'Friends'));

    list.add(SVDrawerModel(
        image: 'images/socialv/icons/ic_3User.png', title: 'Groups'));

    // list.add(SVDrawerModel(
    //     image: 'images/socialv/icons/ic_Image.png', title: 'Gallery'));
    list.add(SVDrawerModel(
        image: 'images/socialv/icons/ic_Document.png', title: 'Diary'));
    list.add(SVDrawerModel(
        image: 'images/socialv/icons/ic_Image.png', title: 'Events'));
    // list.add(SVDrawerModel(image: 'images/socialv/icons/ic_Send.png', title: 'Share App'));
    // list.add(SVDrawerModel(image: 'images/socialv/icons/ic_Star.png', title: 'Rate Us'));
  }
  list.add(SVDrawerModel(
      image: 'images/socialv/icons/ic_Logout.png', title: 'Logout'));

  return list;
}

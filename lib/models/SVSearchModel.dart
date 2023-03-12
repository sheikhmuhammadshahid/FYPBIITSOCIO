import 'User/UserModel.dart';

class SVSearchModel {
  String? name;
  String? profileImage;
  String? subTitle;
  bool? isOfficialAccount;
  bool? doSend;
  bool? isFriend;
  List<User> users = [];
  SVSearchModel(
      {this.name,
      this.profileImage,
      this.subTitle,
      this.isOfficialAccount,
      this.doSend});
}

List<SVSearchModel> getRecentList() {
  List<SVSearchModel> list = [];

  list.add(SVSearchModel(
      name: 'Jane_ui ux ',
      profileImage: 'images/socialv/faces/face_1.png',
      subTitle: '@Jane_Cooper',
      isOfficialAccount: true));
  list.add(SVSearchModel(
      name: 'Anne T. Kwayted',
      profileImage: 'images/socialv/faces/face_2.png',
      subTitle: '😈Anne Attack😇',
      isOfficialAccount: false));
  list.add(SVSearchModel(
      name: 'Tim Midsaylesman',
      profileImage: 'images/socialv/faces/face_3.png',
      subTitle: 'Tim_mid',
      isOfficialAccount: false));
  list.add(SVSearchModel(
      name: 'Hope Furaletter',
      profileImage: 'images/socialv/faces/face_4.png',
      subTitle: 'Hope✌ Furaletter_12',
      isOfficialAccount: true));
  list.add(SVSearchModel(
      name: 'Cherry Blossom',
      profileImage: 'images/socialv/faces/face_5.png',
      subTitle: 'Cherryblossom_',
      isOfficialAccount: false));

  return list;
}

List<SVSearchModel> getSharePostList() {
  List<SVSearchModel> list = [];

  list.add(SVSearchModel(
      name: 'Jane_ui ux ',
      profileImage: 'images/socialv/faces/face_1.png',
      isOfficialAccount: true,
      doSend: false));
  list.add(SVSearchModel(
      name: 'Anne T. Kwayted',
      profileImage: 'images/socialv/faces/face_2.png',
      isOfficialAccount: false,
      doSend: false));
  list.add(SVSearchModel(
      name: 'Tim Midsaylesman',
      profileImage: 'images/socialv/faces/face_3.png',
      isOfficialAccount: false,
      doSend: false));
  list.add(SVSearchModel(
      name: 'Hope Furaletter',
      profileImage: 'images/socialv/faces/face_4.png',
      isOfficialAccount: true,
      doSend: false));
  list.add(SVSearchModel(
      name: 'Cherry Blossom',
      profileImage: 'images/socialv/faces/face_5.png',
      isOfficialAccount: false,
      doSend: false));

  return list;
}

import 'package:biit_social/Controllers/SettingController.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/screens/auth/components/SVLoginInComponent.dart';
import 'package:biit_social/screens/auth/components/SVSignUpComponent.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:biit_social/utils/SVConstants.dart';
import '../../../utils/IPHandleClass.dart';
import '../../../utils/SVColors.dart';
import 'package:provider/provider.dart';

class SVSignInScreen extends StatefulWidget {
  const SVSignInScreen({Key? key}) : super(key: key);

  @override
  State<SVSignInScreen> createState() => _SVSignInScreenState();
}

class _SVSignInScreenState extends State<SVSignInScreen> {
  bool doRemember = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(svGetScaffoldColor());
    });
  }

  late SettingController settingController;
  Widget getFragment() {
    if (selectedIndex == 0) {
      return SVLoginInComponent(
        callback: () {
          selectedIndex = 1;
          setState(() {});
        },
      );
    } else {
      return SVSignUpComponent(
        callback: () {
          selectedIndex = 0;
          setState(() {});
        },
      );
    }
  }

  @override
  void dispose() {
    setStatusBarColor(svGetScaffoldColor());
    super.dispose();
  }

  TextEditingController ipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SettingController settingController = context.read<SettingController>();
    IPHandle.settingController = settingController;
    return Scaffold(
      backgroundColor: svGetScaffoldColor(),
      body: Column(
        children: [
          SizedBox(height: context.statusBarHeight + 50),
          Image.asset('images/socialv/gifs/BIITLOGO.png',
                  height: 150, width: 150, fit: BoxFit.cover)
              .onTap(() async {
            ipController.text = IPHandle.ippp;
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Enter ip to update'),
                  content: Padding(
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        controller: ipController,
                        decoration: const InputDecoration(
                            hintText: 'Enter ip', border: OutlineInputBorder()),
                      )),
                  actions: [
                    TextButton(
                        onPressed: () {
                          if (ipController.text.isNotEmpty) {
                            IPHandle.setIp(ipController.text.trim());

                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Save'))
                  ],
                );
              },
            );
          }),
          5.height,
          Text(svAppName,
              style: primaryTextStyle(
                  color: SVAppColorPrimary,
                  size: 28,
                  weight: FontWeight.w500,
                  fontFamily: svFontRoboto)),
          8.width,
          20.height,
          svHeaderContainer(
            context: context,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: Text('LOGIN',
                      style: boldTextStyle(
                          color: selectedIndex == 0
                              ? Colors.white
                              : Colors.white54,
                          size: 16)),
                  onPressed: () async {},
                ),
                // TextButton(
                //   child: Text('SIGNUP',
                //       style: boldTextStyle(
                //           color: selectedIndex == 1
                //               ? Colors.white
                //               : Colors.white54,
                //           size: 16)),
                //   onPressed: () {
                //     selectedIndex = 1;
                //     setState(() {});
                //   },
                // ),
              ],
            ),
          ),
          getFragment().expand(),
        ],
      ),
    );
  }
}

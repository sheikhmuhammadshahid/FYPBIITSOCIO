import 'package:biit_social/Controllers/AuthController.dart';
import 'package:biit_social/utils/SVConstants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class SVSplashScreen extends StatefulWidget {
  const SVSplashScreen({Key? key}) : super(key: key);

  @override
  State<SVSplashScreen> createState() => _SVSplashScreenState();
}

class _SVSplashScreenState extends State<SVSplashScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);
    sharedPreferences = await SharedPreferences.getInstance();
    await 3.seconds.delay;
    // ignore: use_build_context_synchronously
    finish(context);
    // ignore: use_build_context_synchronously
    context.read<AuthController>().checkisLoggedIn(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'images/socialv/svSplashImage.jpg',
            height: context.height(),
            width: context.width(),
            fit: BoxFit.fill,
          ),
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/socialv/svAppIcon.png',
                    height: 50,
                    width: 52,
                    fit: BoxFit.cover,
                    color: Colors.white),
                8.width,
                Text(svAppName,
                    style: primaryTextStyle(
                        color: Colors.white,
                        size: 40,
                        weight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/screens/auth/screens/SVForgetPasswordScreen.dart';
import 'package:biit_social/utils/SVColors.dart';
import 'package:biit_social/utils/SVCommon.dart';
import 'package:provider/provider.dart';
import '../../../Controllers/AuthController.dart';
import '../../../models/User/UserModel.dart';

class SVLoginInComponent extends StatefulWidget {
  static int loggedIn = 1;
  final VoidCallback? callback;
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static bool isChecked = false;

  const SVLoginInComponent({super.key, this.callback});

  @override
  State<SVLoginInComponent> createState() => _SVLoginInComponentState();
}

class _SVLoginInComponentState extends State<SVLoginInComponent> {
  bool doRemember = false;

  @override
  Widget build(BuildContext context) {
    var authController = Provider.of<AuthController>(context);
    return Form(
      key: SVLoginInComponent.formKey,
      child: Container(
        width: context.width(),
        color: context.cardColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              Text('Welcome!', style: boldTextStyle(size: 24))
                  .paddingSymmetric(horizontal: 16),
              8.height,
              Text('You Have Been Missed For Long Time',
                      style: secondaryTextStyle(
                          weight: FontWeight.w500, color: svGetBodyColor()))
                  .paddingSymmetric(horizontal: 16),
              Container(
                child: Column(
                  children: [
                    30.height,
                    AppTextField(
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        }
                        return "Please enter aridNo or CNIC!";
                      },
                      controller: SVLoginInComponent.userController,
                      textFieldType: TextFieldType.OTHER,
                      textStyle: boldTextStyle(),
                      decoration: svInputDecoration(
                        context,
                        label: 'Username',
                        labelStyle: secondaryTextStyle(
                            weight: FontWeight.w600, color: svGetBodyColor()),
                      ),
                    ).paddingSymmetric(horizontal: 16),
                    16.height,
                    AppTextField(
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return null;
                        }
                        return "Please enter password!";
                      },
                      controller: SVLoginInComponent.passwordController,
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
                        label: 'Password',
                        contentPadding: const EdgeInsets.all(0),
                        labelStyle: secondaryTextStyle(
                            weight: FontWeight.w600, color: svGetBodyColor()),
                      ),
                    ).paddingSymmetric(horizontal: 16),
                    12.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Consumer<AuthController>(
                              builder: (context, value, child) {
                                return Checkbox(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: radius(2)),
                                  activeColor: SVAppColorPrimary,
                                  value: authController.rememberMe,
                                  onChanged: (val) {
                                    authController.saveStatus(val);
                                    //setState(() {});
                                  },
                                );
                              },
                            ),
                            svRobotoText(text: 'Remember Me'),
                          ],
                        ),
                        svRobotoText(
                          text: 'Forget Password?',
                          color: SVAppColorPrimary,
                          fontStyle: FontStyle.italic,
                          onTap: () {
                            const SVForgetPasswordScreen().launch(context);
                          },
                        ).paddingSymmetric(horizontal: 16),
                      ],
                    ),
                    32.height,
                    svAppButton(
                      context: context,
                      text: 'LOGIN',
                      onTap: () async {
                        try {
                          SVLoginInComponent.loggedIn =
                              int.parse(SVLoginInComponent.userController.text);
                        } catch (ex) {}
                        if (SVLoginInComponent.formKey.currentState!
                            .validate()) {
                          User user = User(
                              profileImage: '',
                              CNIC: SVLoginInComponent.userController.text,
                              aridNo: SVLoginInComponent.userController.text,
                              password:
                                  SVLoginInComponent.passwordController.text);
                          authController.login(user, context);
                        }
                        //dynamic result = await userApi().Login(user, context);

                        //}
                        // SVDashboardScreen().launch(context);
                      },
                    ),
                    16.height,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     svRobotoText(text: 'Don’t Have An Account?'),
                    //     4.width,
                    //     Text(
                    //       'Sign Up',
                    //       style: secondaryTextStyle(
                    //           color: SVAppColorPrimary,
                    //           decoration: TextDecoration.underline),
                    //     ).onTap(() {
                    //       widget.callback?.call();
                    //     },
                    //         highlightColor: Colors.transparent,
                    //         splashColor: Colors.transparent)
                    //   ],
                    // ),
                    // 50.height,
                    // svRobotoText(text: 'OR Continue With'),
                    // 16.height,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Image.asset('images/socialv/icons/ic_Google.png',
                    //         height: 36, width: 36, fit: BoxFit.cover),
                    //     8.width,
                    //     Image.asset('images/socialv/icons/ic_Facebook.png',
                    //         height: 36, width: 36, fit: BoxFit.cover),
                    //     8.width,
                    //     Image.asset('images/socialv/icons/ic_Twitter.png',
                    //         height: 36, width: 36, fit: BoxFit.cover),
                    //   ],
                    // ),
                    // 50.height,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

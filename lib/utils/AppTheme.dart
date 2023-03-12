import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:biit_social/utils/SVColors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: SVAppLayoutBackground,
    primaryColor: SVAppColorPrimary,
    primaryColorDark: SVAppColorPrimary,
    hoverColor: Colors.white54,
    dividerColor: viewLineColor,
    fontFamily: GoogleFonts.inter().fontFamily,
    appBarTheme: const AppBarTheme(
      color: SVAppLayoutBackground,
      iconTheme: IconThemeData(color: textPrimaryColor),
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black),
    cardTheme: const CardTheme(color: Colors.white),
    cardColor: SVAppSectionBackground,
    iconTheme: const IconThemeData(color: textPrimaryColor),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: whiteColor),
    textTheme: const TextTheme(
      labelLarge: TextStyle(color: SVAppColorPrimary),
      titleLarge: TextStyle(color: textPrimaryColor),
      titleSmall: TextStyle(color: textSecondaryColor),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.light(primary: SVAppColorPrimary)
        .copyWith(error: Colors.red),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: const OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: const OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: const OpenUpwardsPageTransitionsBuilder(),
        }),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: appBackgroundColorDark,
    highlightColor: appBackgroundColorDark,
    appBarTheme: const AppBarTheme(
      color: appBackgroundColorDark,
      iconTheme: IconThemeData(color: blackColor),
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    ),
    primaryColor: color_primary_black,
    dividerColor: const Color(0xFFDADADA).withOpacity(0.3),
    primaryColorDark: color_primary_black,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),
    hoverColor: Colors.black12,
    fontFamily: GoogleFonts.inter().fontFamily,
    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: appBackgroundColorDark),
    primaryTextTheme: TextTheme(
        titleLarge: primaryTextStyle(color: Colors.white),
        labelSmall: primaryTextStyle(color: Colors.white)),
    cardTheme: const CardTheme(color: cardBackgroundBlackDark),
    cardColor: cardBackgroundBlackDark,
    iconTheme: const IconThemeData(color: whiteColor),
    textTheme: const TextTheme(
      labelLarge: TextStyle(color: color_primary_black),
      titleLarge: TextStyle(color: whiteColor),
      titleSmall: TextStyle(color: Colors.white54),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.dark(
            primary: appBackgroundColorDark, onPrimary: cardBackgroundBlackDark)
        .copyWith(secondary: whiteColor)
        .copyWith(error: Color(0xFFCF6676)),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: const OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: const OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: const OpenUpwardsPageTransitionsBuilder(),
        }),
  );
}

import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/app_constants.dart';

ThemeData lightTheme({Color color = AppConstants.lightPrimary}) => ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: color,
  primaryColorDark: const Color(0xFF42938B),
  disabledColor: const Color(0xFFBABFC4),
  dialogBackgroundColor: const Color(0xFFEEEEEE),
  scaffoldBackgroundColor: const Color(0xFF42938B),
  textTheme:  const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Color(0xff6B7675)),

  ),

  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),

  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: Colors.white,
  colorScheme: const ColorScheme.light(
      // primary: Color(0xFF81D8D0),
      primary: Color(0xFF42938B),
      //  secondary: Color(0xFF008C7B),
      error: Color(0xFFE84D4F),
      background: Color(0xFFF3F3F3),
      tertiary: Color(0xFF7CCD8B),
      tertiaryContainer: Color(0xFFC98B3E),
      secondaryContainer: Color(0xFFEE6464),
      onTertiary: Color(0xFFD9D9D9),
      onSecondary: Color(0xFF00FEE1),
      onSecondaryContainer: Color(0xFFA8C5C1),
      onTertiaryContainer: Color(0xFF425956),
      outline: Color(0xFF8CFFF1),
      onPrimaryContainer: Color(0xFFDEFFFB),
      primaryContainer: Color(0xFFFFA800),
      onErrorContainer: Color(0xFFFFE6AD),
      onPrimary: Color(0xFF14B19E),
      surfaceTint: Color(0xFF0B9722),
      errorContainer: Color(0xFFF6F6F6),
  ),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color)),
);

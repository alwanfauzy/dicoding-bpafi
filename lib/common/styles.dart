import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class Styles {
  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.mavenPro(
        fontSize: 103, fontWeight: FontWeight.w300, letterSpacing: -1.5),
    displayMedium: GoogleFonts.mavenPro(
        fontSize: 64, fontWeight: FontWeight.w300, letterSpacing: -0.5),
    displaySmall:
        GoogleFonts.mavenPro(fontSize: 51, fontWeight: FontWeight.w400),
    headlineMedium: GoogleFonts.mavenPro(
        fontSize: 36, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    headlineSmall:
        GoogleFonts.mavenPro(fontSize: 26, fontWeight: FontWeight.w400),
    titleLarge: GoogleFonts.mavenPro(
        fontSize: 21, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleMedium: GoogleFonts.mavenPro(
        fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 0.15),
    titleSmall: GoogleFonts.mavenPro(
        fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    bodyLarge: GoogleFonts.sourceSansPro(
        fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyMedium: GoogleFonts.sourceSansPro(
        fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    labelLarge: GoogleFonts.sourceSansPro(
        fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    bodySmall: GoogleFonts.sourceSansPro(
        fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.4),
    labelSmall: GoogleFonts.sourceSansPro(
        fontSize: 11, fontWeight: FontWeight.w400, letterSpacing: 1.5),
  );

  // TODO: Implement ColorScheme
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      textTheme: textTheme,
      primaryColor: isDarkTheme ? Colors.black : Colors.white,
      backgroundColor: isDarkTheme ? Colors.black : const Color(0xffF1F5FB),
      indicatorColor:
          isDarkTheme ? const Color(0xff0E1D36) : const Color(0xffCBDCF8),
      hintColor:
          isDarkTheme ? const Color(0xff280C0B) : const Color(0xffEECED3),
      highlightColor:
          isDarkTheme ? const Color(0xff372901) : const Color(0xffFCE192),
      hoverColor:
          isDarkTheme ? const Color(0xff3A3A3B) : const Color(0xff4285F4),
      focusColor:
          isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: isDarkTheme
                ? const ColorScheme.dark()
                : const ColorScheme.light(),
          ),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: isDarkTheme ? Colors.white : Colors.black,
      ),
    );
  }
}

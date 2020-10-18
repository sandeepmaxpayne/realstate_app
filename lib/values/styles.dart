import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  static TextStyle customTextStyle({
    Color color = const Color(0xFF797C82),
    FontWeight fontWeight = FontWeight.w600,
    double fontSize = 14.0,
    FontStyle fontStyle: FontStyle.normal,
  }) {
    return GoogleFonts.roboto(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    );
  }

  static TextStyle customTextStyle2({
    Color color = const Color(0xFF2F2F2F),
    FontWeight fontWeight = FontWeight.w600,
    double fontSize = 16.0,
    FontStyle fontStyle: FontStyle.normal,
  }) {
    return GoogleFonts.comfortaa(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  // Global font configuration
  static TextStyle get spaceGrotesk => GoogleFonts.spaceGrotesk();

  // Different font weights and sizes for common use cases
  static TextStyle get heading1 =>
      GoogleFonts.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.w700);

  static TextStyle get heading2 =>
      GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.w600);

  static TextStyle get heading3 =>
      GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.w600);

  static TextStyle get bodyLarge =>
      GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w400);

  static TextStyle get bodyMedium =>
      GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w400);

  static TextStyle get bodySmall =>
      GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w400);

  static TextStyle get button =>
      GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.w600);

  static TextStyle get caption =>
      GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w400);

  // Method to get custom font with specific properties
  static TextStyle custom({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) => GoogleFonts.spaceGrotesk(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
  );
}

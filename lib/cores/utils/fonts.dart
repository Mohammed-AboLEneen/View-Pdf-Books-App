import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/cores/utils/color_degree.dart';

class AppFonts {
  static TextStyle textStyle30 =
      GoogleFonts.aBeeZee().copyWith(fontWeight: FontWeight.w500, fontSize: 30);
  static TextStyle abelTextStyle18 =
      GoogleFonts.abel().copyWith(fontWeight: FontWeight.w400, fontSize: 18);

  static TextStyle aBeeZeeTextStyle20 = GoogleFonts.aBeeZee().copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 20,
  );
  static TextStyle abelTextStyle20 = GoogleFonts.abel().copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 20,
      color: Colors.white.withLightness(.95));

  static TextStyle aBeeZeeTextStyle25 = GoogleFonts.aBeeZee()
      .copyWith(fontWeight: FontWeight.w500, fontSize: 25, color: Colors.black);
}

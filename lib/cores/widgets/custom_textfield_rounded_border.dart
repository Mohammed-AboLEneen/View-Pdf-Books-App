import 'package:flutter/material.dart';
import 'package:test_app/cores/utils/fonts.dart';

class CustomTextFieldRoundedBorder extends StatelessWidget {
  final String? hint;
  final double? hintTextSize;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final Icon? icon;
  final Color? textColor;
  final Color? borderColor;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final double? topRight;
  final double? topLeft;
  final double? bottomRight;
  final double? bottomLeft;
  final TextInputType? keyboardType;

  const CustomTextFieldRoundedBorder(
      {super.key,
      this.hint,
      this.padding,
      this.icon,
      this.onChanged,
      this.textColor,
      this.borderColor,
      this.controller,
      this.onTap,
      this.maxLines,
      this.minLines,
      this.textInputAction,
      this.suffixIcon,
      this.topRight,
      this.topLeft,
      this.bottomRight,
      this.bottomLeft,
      this.hintTextSize,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextFormField(
        textInputAction: textInputAction ?? TextInputAction.next,
        onTap: onTap,
        keyboardType: keyboardType,
        controller: controller,
        maxLines: maxLines,
        minLines: minLines,
        textAlignVertical: TextAlignVertical.top,
        cursorColor: Colors.grey,
        onChanged: onChanged,
        validator: (value) {
          if (value!.isEmpty) {
            return 'This Field Is Required';
          }
          return null;
        },
        style: AppFonts.abelTextStyle20.copyWith(),
        decoration: InputDecoration(
          hintText: hint,
          errorStyle:
              TextStyle(color: textColor ?? Colors.white.withOpacity(.7)),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? Colors.white.withOpacity(.7),
              ),
              borderRadius: borderRadius()),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor ?? Colors.white.withOpacity(.7),
              ),
              borderRadius: borderRadius()),
          focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius(),
              borderSide: BorderSide(
                  color: borderColor ?? Colors.white.withOpacity(.5))),
          hintStyle: AppFonts.abelTextStyle20
              .copyWith(color: Colors.black.withOpacity(.7)),
          suffixIcon: suffixIcon,
          contentPadding: padding,
        ));
  }

  BorderRadius borderRadius() {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft ?? 10),
      topRight: Radius.circular(topRight ?? 10),
      bottomLeft: Radius.circular(bottomLeft ?? 10),
      bottomRight: Radius.circular(bottomRight ?? 10),
    );
  }
}

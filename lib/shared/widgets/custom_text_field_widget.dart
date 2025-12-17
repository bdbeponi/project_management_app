import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management/app/constants/text_font_style.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final Color? fillColor;
  final TextInputType keyboardType;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final TextAlign? textAlign;

  const CustomTextFieldWidget({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.borderColor,
    this.contentPadding,
    this.borderRadius,
    this.hintStyle,
    this.style,
    this.textAlign,
    this.fillColor,
  });

  OutlineInputBorder _buildBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(10.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor ?? Colors.white,
        labelText: labelText,
        hintText: hintText,
        hintStyle:
            hintStyle ??
            TextFontStyle.headline12w500c6C7278styleLexend.copyWith(
              fontSize: 14.sp,
              color: Colors.black87.withValues(alpha: .6),
            ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        // border: _buildBorder(Colors.transparent),
        // enabledBorder: _buildBorder(Colors.transparent),
        // focusedBorder: _buildBorder(Colors.transparent, width: 2),
        border: _buildBorder(borderColor ?? Colors.transparent),
        enabledBorder: _buildBorder(borderColor ?? Colors.transparent),
        focusedBorder: _buildBorder(
          borderColor ?? Colors.transparent,
          width: 2,
        ),
        errorBorder: _buildBorder(Colors.red),
        focusedErrorBorder: _buildBorder(Colors.red, width: 2),
      ),
      textAlign: textAlign ?? TextAlign.start,
      style:
          style ??
          TextFontStyle.headline12w500c6C7278styleLexend.copyWith(
            fontSize: 14.sp,
            color: Colors.black87,
          ),
    );
  }
}

class CustomTextFieldBottomWidget extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? borderColor;
  final TextInputType keyboardType;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final TextAlign? textAlign;

  const CustomTextFieldBottomWidget({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.borderColor,
    this.contentPadding,
    this.borderRadius,
    this.hintStyle,
    this.style,
    this.textAlign,
  });

  dynamic _buildBorder(Color color, {double width = 1}) {
    return UnderlineInputBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(10.r),
      borderSide: BorderSide(color: color, width: width),
      // borderSide: BorderSide(color: AppColors.c3449CF)
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        filled: false,
        fillColor: Colors.white,
        labelText: labelText,
        hintText: hintText,
        hintStyle:
            hintStyle ??
            TextFontStyle.headline12w500c6C7278styleLexend.copyWith(
              fontSize: 14.sp,
              color: Colors.black87.withValues(alpha: .6),
            ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        // border: _buildBorder(Colors.transparent),
        // enabledBorder: _buildBorder(Colors.transparent),
        // focusedBorder: _buildBorder(Colors.transparent, width: 2),
        border: _buildBorder(borderColor ?? Colors.transparent),
        enabledBorder: _buildBorder(borderColor ?? Colors.transparent),
        focusedBorder: _buildBorder(
          borderColor ?? Colors.transparent,
          width: 2,
        ),
        errorBorder: _buildBorder(Colors.red),
        focusedErrorBorder: _buildBorder(Colors.red, width: 2),
      ),
      textAlign: textAlign ?? TextAlign.start,
      style:
          style ??
          TextFontStyle.headline12w500c6C7278styleLexend.copyWith(
            fontSize: 14.sp,
            color: Colors.black87,
          ),
    );
  }
}

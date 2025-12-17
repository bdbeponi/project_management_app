import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:project_management/app/constants/text_font_style.dart';

/// A styled phone input field with Bangladesh (+880) as the default country.
/// ===============================================
///    phone_form_field: ^10.0.10
/// ===============================================

class CustomPhoneFieldWidget extends StatelessWidget {
  final PhoneController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(PhoneNumber?)? validator;
  final bool enabled;
  final Color? borderColor;

  const CustomPhoneFieldWidget({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.enabled = true,
    this.borderColor,
  });

  OutlineInputBorder _border(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    return PhoneFormField(
      controller:
          controller ??
          PhoneController(initialValue: PhoneNumber.parse('+880')),
      enabled: enabled,
      validator:
          validator ??
          PhoneValidator.compose([
            PhoneValidator.required(context),
            PhoneValidator.validMobile(context),
          ]),
      countrySelectorNavigator: const CountrySelectorNavigator.bottomSheet(),
      isCountrySelectionEnabled: true,
      isCountryButtonPersistent: true,
      countryButtonStyle: const CountryButtonStyle(
        showDialCode: true,
        showFlag: true,
        flagSize: 18,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextFontStyle.headline12w500c6C7278styleLexend.copyWith(
          fontSize: 14.sp,
          color: Colors.black.withValues(alpha: .6),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        border: _border(borderColor ?? Colors.transparent),
        enabledBorder: _border(borderColor ?? Colors.transparent),
        focusedBorder: _border(
          borderColor ?? Theme.of(context).primaryColor,
          width: 2,
        ),
        errorBorder: _border(Colors.red),
        focusedErrorBorder: _border(Colors.red, width: 2),
      ),
      style: TextFontStyle.headline12w500c6C7278styleLexend.copyWith(
        fontSize: 14.sp,
        color: Colors.black87,
      ),
    );
  }
}

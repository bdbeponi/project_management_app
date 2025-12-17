import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_management/app/constants/text_font_style.dart';
import 'package:project_management/utils/ui_helpers.dart';

class CustomAppbarWidget extends StatelessWidget {
  const CustomAppbarWidget({
    super.key,
    this.child,
    this.padding,
    this.actionButton,
    this.onBack,
    this.leading,
    this.title,
    this.bottomSpace,
  });

  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final Widget? actionButton;
  final VoidCallback? onBack;
  final Widget? leading;
  final String? title;
  final double? bottomSpace;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding:
                padding ??
                EdgeInsetsGeometry.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onBack,
                  child: SizedBox(
                    width: 30.w,
                    child: leading ?? Icon(Icons.arrow_back, size: 24.sp),
                  ),
                ),
                Text(
                  title ?? "",
                  style: TextFontStyle.headline12w500c6C7278styleLexend
                      .copyWith(
                        fontSize: 21.sp,
                        color: const Color(0xFF1F1F39),
                      ),
                ),
                SizedBox(width: 30.w, child: actionButton),
              ],
            ),
          ),
          UIHelper.verticalSpace(bottomSpace ?? 0),
          if (child != null) Expanded(child: child!),
        ],
      ),
    );
  }
}

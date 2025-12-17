// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:project_management/app/constants/text_font_style.dart';
// import 'package:project_management/app/router/config/route_extention.dart';
// import 'package:project_management/gen/assets.gen.dart';
// import 'package:project_management/gen/colors.gen.dart';

// class CustomDialogUtil {
//   CustomDialogUtil();

//   ///===========================================
//   /// **** Custom Dialoug Coin and Exam ****
//   ///===========================================

//   static Future<void> customCoinDialoug(
//     BuildContext context, {
//     required int requiredCoins,
//     required VoidCallback onBuyCoin,
//     VoidCallback? onQuit,
//   }) async {
//     if (!context.mounted) return;

//     await showDialog<void>(
//       context: context,
//       barrierDismissible: true,
//       builder: (_) => _CustomDialoug(
//         title: 'Sorry!',
//         body: Text.rich(
//           TextSpan(
//             children: [
//               TextSpan(
//                 text: 'You need ',
//                 style: TextFontStyle.headline18w400cB9B9B9styleLexend.copyWith(
//                   fontSize: 14.sp,
//                   color: AppColors.c333333,
//                 ),
//               ),
//               TextSpan(
//                 text: 'at least $requiredCoins more coin',
//                 style: TextFontStyle.headline12w600c4D81E7styleLexend.copyWith(
//                   fontSize: 14.sp,
//                   color: AppColors.c10B981,
//                 ),
//               ),
//               TextSpan(
//                 text: ' to give this exam',
//                 style: TextFontStyle.headline18w400cB9B9B9styleLexend.copyWith(
//                   fontSize: 14.sp,
//                   color: AppColors.c333333,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         greenButtonLebel: 'Buy Coin',
//         redButtonLebel: 'Quit',
//         onGreenButtonTap: () {},
//         onRedButtonTap: () {},
//         // title: Container(),
//       ),
//     );
//   }

//   static Future<void> customExamExitDialoug(
//     BuildContext context, {
//     required int requiredCoins,
//     required VoidCallback onBuyCoin,
//     VoidCallback? onQuit,
//   }) async {
//     if (!context.mounted) return;

//     await showDialog<void>(
//       context: context,
//       barrierDismissible: true,
//       builder: (_) => _CustomDialoug(
//         title: 'Leaving Exam?',
//         body: SizedBox(
//           width: double.infinity,
//           child: Text.rich(
//             textAlign: TextAlign.start,
//             TextSpan(
//               children: [
//                 TextSpan(
//                   text: 'If you exit, your exam will be ',
//                   style: TextFontStyle.headline18w400cB9B9B9styleLexend
//                       .copyWith(fontSize: 12.sp, color: AppColors.c333333),
//                 ),
//                 TextSpan(
//                   text: 'submitted. ',
//                   style: TextFontStyle.headline12w600c4D81E7styleLexend
//                       .copyWith(fontSize: 12.sp, color: AppColors.c10B981),
//                 ),
//                 TextSpan(
//                   text: 'Unanswered questions will be ',
//                   style: TextFontStyle.headline18w400cB9B9B9styleLexend
//                       .copyWith(fontSize: 12.sp, color: AppColors.c333333),
//                 ),
//                 TextSpan(
//                   text: 'skipped, ',
//                   style: TextFontStyle.headline12w600c4D81E7styleLexend
//                       .copyWith(fontSize: 12.sp, color: AppColors.c10B981),
//                 ),
//                 TextSpan(
//                   text: 'and coins spent will not be ',
//                   style: TextFontStyle.headline18w400cB9B9B9styleLexend
//                       .copyWith(fontSize: 12.sp, color: AppColors.c333333),
//                 ),
//                 TextSpan(
//                   text: 'refunded.',
//                   style: TextFontStyle.headline12w600c4D81E7styleLexend
//                       .copyWith(fontSize: 12.sp, color: AppColors.c10B981),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         greenButtonLebel: 'Cancel',
//         redButtonLebel: 'Quit Exam',
//         onGreenButtonTap: () => Navigator.of(context).pop(),
//         onRedButtonTap: () {
//           nav.goBack();
//           nav.goBack();
//         },
//         // title: Container(),
//       ),
//     );
//   }

//   ///===========================================
//   /// **** Custom Dialoug Exit and Logout ****
//   ///===========================================
//   static Future<void> showExitAppDialog(BuildContext context) async {
//     if (!context.mounted) return;

//     await showDialog<void>(
//       context: context,
//       barrierDismissible: true,
//       builder: (_) => _CustomDialoug(
//         title: 'Exit App?',
//         body: SizedBox(
//           width: double.infinity,
//           child: Text.rich(
//             textAlign: TextAlign.start,
//             TextSpan(
//               children: [
//                 TextSpan(
//                   text: 'Are you sure you want to ',
//                   style: TextFontStyle.headline18w400cB9B9B9styleLexend
//                       .copyWith(fontSize: 12.sp, color: AppColors.c333333),
//                 ),
//                 TextSpan(
//                   text: 'exit ',
//                   style: TextFontStyle.headline12w600c4D81E7styleLexend
//                       .copyWith(fontSize: 12.sp, color: AppColors.c10B981),
//                 ),
//                 TextSpan(
//                   text: 'the app? ',
//                   style: TextFontStyle.headline18w400cB9B9B9styleLexend
//                       .copyWith(fontSize: 12.sp, color: AppColors.c333333),
//                 ),
//                 TextSpan(
//                   text: 'Your progress will be ',
//                   style: TextFontStyle.headline12w600c4D81E7styleLexend
//                       .copyWith(fontSize: 12.sp, color: AppColors.c333333),
//                 ),
//                 TextSpan(
//                   text: 'saved automatically.',
//                   style: TextFontStyle.headline18w400cB9B9B9styleLexend
//                       .copyWith(fontSize: 12.sp, color: AppColors.c10B981),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         greenButtonLebel: 'Cancel',
//         redButtonLebel: 'Exit',
//         onGreenButtonTap: () => Navigator.of(context).pop(),
//         onRedButtonTap: () {
//           Navigator.of(context).pop();
//           Future.delayed(const Duration(milliseconds: 100), () {
//             exit(0);
//           });
//         },
//       ),
//     );
//   }

//   static Future<void> showLogoutDialog(
//     BuildContext context, {
//     required VoidCallback onConfirmLogout,
//   }) async {
//     if (!context.mounted) return;

//     await showDialog<void>(
//       context: context,
//       barrierDismissible: true,
//       builder: (_) => _CustomDialoug(
//         title: 'Logout?',
//         body: SizedBox(
//           width: double.infinity,
//           child: Text.rich(
//             textAlign: TextAlign.start,
//             TextSpan(
//               children: [
//                 TextSpan(
//                   text: 'Are you sure you want to ',
//                   style: TextFontStyle.headline18w400cB9B9B9styleLexend
//                       .copyWith(fontSize: 12.sp, color: AppColors.c333333),
//                 ),
//                 TextSpan(
//                   text: 'log out ',
//                   style: TextFontStyle.headline12w600c4D81E7styleLexend
//                       .copyWith(fontSize: 12.sp, color: AppColors.c10B981),
//                 ),
//                 TextSpan(
//                   text: 'from your account? ',
//                   style: TextFontStyle.headline18w400cB9B9B9styleLexend
//                       .copyWith(fontSize: 12.sp, color: AppColors.c333333),
//                 ),
//                 TextSpan(
//                   text: 'You can log in again anytime.',
//                   style: TextFontStyle.headline12w600c4D81E7styleLexend
//                       .copyWith(fontSize: 12.sp, color: AppColors.c10B981),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         greenButtonLebel: 'Cancel',
//         redButtonLebel: 'Logout',
//         onGreenButtonTap: () => Navigator.of(context).pop(),
//         onRedButtonTap: () {
//           Navigator.of(context).pop(); // close dialog
//           Future.delayed(const Duration(milliseconds: 100), () {
//             onConfirmLogout(); // perform logout action
//           });
//         },
//       ),
//     );
//   }
// }

// class _CustomDialoug extends StatelessWidget {
//   const _CustomDialoug({
//     required this.title,
//     required this.body,
//     required this.greenButtonLebel,
//     required this.redButtonLebel,
//     this.onGreenButtonTap,
//     this.onRedButtonTap,
//   });
//   final String title;
//   final Widget body;
//   final String greenButtonLebel;
//   final String redButtonLebel;
//   final VoidCallback? onGreenButtonTap;
//   final VoidCallback? onRedButtonTap;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 24.h),
//       backgroundColor: Colors.transparent,
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           _buildDialogBody(context),
//           _buildCloseButton(context),
//           _buildArrowDecoration(),
//         ],
//       ),
//     );
//   }

//   Widget _buildDialogBody(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(6.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 8.h),
//           Text(
//             title,
//             style: TextFontStyle.headline12w600c4D81E7styleLexend.copyWith(
//               fontSize: 15.sp,
//               color: const Color(0xFF484848),
//             ),
//           ),
//           SizedBox(height: 8.h),
//           body,
//           SizedBox(height: 24.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               BuildActionButton(
//                 label: greenButtonLebel,
//                 color: AppColors.c10B981,
//                 onTap:
//                     onGreenButtonTap ??
//                     () {
//                       Navigator.of(context).pop();
//                       // onBuyCoin();
//                     },
//               ),
//               BuildActionButton(
//                 label: redButtonLebel,
//                 color: const Color(0xFFCF1402),
//                 onTap:
//                     onRedButtonTap ??
//                     () {
//                       Navigator.of(context).pop();
//                     },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCloseButton(BuildContext context) {
//     return Positioned(
//       top: -12.h,
//       right: -12.w,
//       child: InkWell(
//         onTap: () => Navigator.of(context).pop(),
//         child: Container(
//           width: 30.w,
//           height: 30.h,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//             border: Border.all(
//               width: 1.w,
//               color: Colors.black.withOpacity(0.1),
//             ),
//           ),
//           child: Center(
//             child: Icon(Icons.close, size: 20.sp, color: AppColors.c481FBA),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildArrowDecoration() {
//     return Positioned(
//       bottom: -20.h,
//       right: 16.w,
//       child: SvgPicture.asset(
//         Assets.icons.arrowDialoug,
//         height: 20.h,
//         fit: BoxFit.fitHeight,
//       ),
//     );
//   }
// }

// class BuildActionButton extends StatelessWidget {
//   const BuildActionButton({
//     super.key,
//     required this.label,
//     required this.color,
//     required this.onTap,
//   });
//   final String label;
//   final Color color;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(8.r),
//         ),
//         child: Text(
//           label,
//           textAlign: TextAlign.center,
//           style: TextFontStyle.headline32w700c111827styleLexend.copyWith(
//             fontSize: 14.sp,
//             color: AppColors.cFFFFFF,
//           ),
//         ),
//       ),
//     );
//   }
// }

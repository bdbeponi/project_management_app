// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:imgori_app/gen/assets.gen.dart';
// import 'package:shimmer/shimmer.dart';

// class CustomNetworkImageWidget extends StatelessWidget {
//   final String urls;
//   final double? width;
//   final double? height;
//   final BoxFit? fit;
//   const CustomNetworkImageWidget({
//     super.key,
//     required this.urls,
//     this.width,
//     this.height,
//     this.fit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CachedNetworkImage(
//       // imageUrl: "$imageUrl/$urls",
//       imageUrl: urls,
//       width: width ?? 90.w,
//       height: height ?? 70.h,
//       fit: fit ?? BoxFit.cover,
//       placeholder:
//           (context, url) => Shimmer.fromColors(
//             baseColor: Colors.grey.shade300,
//             highlightColor: Colors.grey.shade100,
//             child: Container(decoration: BoxDecoration(color: Colors.white)),
//           ),
//       errorWidget:
//           (context, string, url) => Image.asset(
//             Assets.images.placeholderImage.path,
//             fit: BoxFit.cover,
//           ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadiusdouble;
  final BorderRadiusGeometry? borderRadiusCustom;
  final Widget? errorWidget;
  final bool showShimmer;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadiusdouble = 0,
    this.errorWidget,
    this.showShimmer = true,
    this.borderRadiusCustom,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          borderRadiusCustom ?? BorderRadius.circular(borderRadiusdouble),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => showShimmer
            ? Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: width,
                  height: height,
                  color: Colors.grey.shade300,
                ),
              )
            : Container(
                width: width,
                height: height,
                color: Colors.grey.shade300,
              ),
        errorWidget: (context, url, error) =>
            errorWidget ??
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: borderRadiusCustom ??
                    BorderRadius.circular(borderRadiusdouble),
                color: Colors.grey.shade200,
              ),
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
      ),
    );
  }
}

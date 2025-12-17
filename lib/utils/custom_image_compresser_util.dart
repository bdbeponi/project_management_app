// import 'dart:io';

// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart';

// /// Compress an image file to be under [maxSizeKB] (default 2048 KB / 2 MB)
// /// Returns a compressed File, or null if compression fails.
// Future<File?> compressImage(File file, {int maxSizeKB = 2048}) async {
//   int quality = 100; // start at max quality
//   File? compressedFile = file;

//   while (true) {
//     final bytes = await compressedFile!.length();
//     final kb = bytes / 1024;
//     if (kb <= maxSizeKB || quality <= 10) break;

//     final dir = await getTemporaryDirectory();
//     final targetPath = path.join(
//         dir.path, 'temp_${DateTime.now().millisecondsSinceEpoch}.jpg');

//     compressedFile = (await FlutterImageCompress.compressAndGetFile(
//       compressedFile.absolute.path,
//       targetPath,
//       quality: quality,
//       // minWidth: 1080,   // optional: scale down if needed
//       // minHeight: 1080,  // optional: scale down if needed
//       format: CompressFormat.jpeg,
//     )) as File?;

//     if (compressedFile == null) return null;

//     quality -= 10; // gradually reduce quality
//   }

//   return compressedFile;
// }

// lib/shared/utils/image_picker_helper.dart
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<File?> pickFromCamera() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    return picked != null ? File(picked.path) : null;
  }

  static Future<File?> pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    return picked != null ? File(picked.path) : null;
  }

  static void showPickerSheet({
    required BuildContext context,
    required ValueNotifier<File?> imageNotifier,
    bool showCamera = true,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Choose Image'),
        message:
            const Text('Select an image from your camera or existing gallery.'),
        actions: [
          if (showCamera)
            CupertinoActionSheetAction(
              onPressed: () async {
                final file = await pickFromCamera();
                if (file != null) imageNotifier.value = file;
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Camera'),
            ),
          CupertinoActionSheetAction(
            onPressed: () async {
              final file = await pickFromGallery();
              if (file != null) imageNotifier.value = file;
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Gallery'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }
}

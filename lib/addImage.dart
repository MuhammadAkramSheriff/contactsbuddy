import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> pickImage(BuildContext context) async {
  final picker = ImagePicker();
  final source = await showDialog<ImageSource>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Choose Image Source'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(ImageSource.camera),
            child: Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
            child: Text('Gallery'),
          ),
        ],
      );
    },
  );

  if (source == null) return null;

  final pickedFile = await picker.pickImage(source: source);

  if (pickedFile == null) return null;

  final imageBytes = await pickedFile.readAsBytes();

  return Uint8List.fromList(imageBytes);
}
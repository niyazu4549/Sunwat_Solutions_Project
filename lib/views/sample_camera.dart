import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class SampleCamera extends StatefulWidget {
  const SampleCamera({super.key});

  @override
  State<SampleCamera> createState() => _SampleCameraState();
}

class _SampleCameraState extends State<SampleCamera> {
  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      final imageTemperory = File(image.path);
      print('imageTemperory=${imageTemperory.path}');
      // final imagePermanent = await saveImagePermanently(image.path);
      setState(() => this.image = imageTemperory);
    } on PlatformException catch (e) {
      print('Failed to pic image: $e');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: const Text(
                  'Image Picker',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () => pickImage(ImageSource.camera),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: const Icon(Icons.camera_alt_outlined),
                      ),
                      Container(
                        child: const Text('Camera'),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 300,
                child: image != null ? Image.file(image!) : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }

  getApplicationDocumentsDirectory() {}

  basename(String imagePath) {}
}

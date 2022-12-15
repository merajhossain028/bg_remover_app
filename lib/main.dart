import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'models/bg_api.dart';
import 'view/added_new_bg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RemoveBackground(),
    );
  }
}

class RemoveBackground extends StatefulWidget {
  const RemoveBackground({super.key});

  @override
  RemoveBackgroundState createState() => RemoveBackgroundState();
}

class RemoveBackgroundState extends State<RemoveBackground> {
  Uint8List? imageFile;

  String? imagePath;

  ScreenshotController controller = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BG Remover'),
          actions: [
            IconButton(
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
                icon: const Icon(Icons.image)),
            IconButton(
                onPressed: () {
                  getImage(ImageSource.camera);
                },
                icon: const Icon(Icons.camera_alt)),
            IconButton(
                onPressed: () async {
                  imageFile = await ApiClient().removeBgApi(imagePath!);
                  setState(() {});
                },
                icon: const Icon(Icons.delete)),
            IconButton(
                onPressed: () async {
                  saveImage();
                },
                icon: const Icon(Icons.save))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (imageFile != null)
                  ? Screenshot(
                      controller: controller,
                      child: Image.memory(
                        imageFile!,
                      ),
                    )
                  : Container(
                      width: 300,
                      height: 300,
                      color: Colors.grey[300]!,
                      child: const Icon(
                        Icons.image,
                        size: 100,
                      ),
                    ),
              ElevatedButton(
                onPressed: () {
                  if (imageFile != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  AddNewBg(imageFile:imageFile),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please Select Image First'),
                      ),
                    );
                  }
                },
                child: const Text('Add New Background'),
              ),
            ],
          ),
        ));
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imagePath = pickedImage.path;
        imageFile = await pickedImage.readAsBytes();
        setState(() {});
      }
    } catch (e) {
      imageFile = null;
      setState(() {});
    }
  }

  void saveImage() async {
    bool isGranted = await Permission.storage.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.storage.request().isGranted;
    }

    if (isGranted) {
      String directory = (await getExternalStorageDirectory())!.path;
      String fileName = "${DateTime.now().microsecondsSinceEpoch}.png";
      controller.captureAndSave(directory, fileName: fileName);
    }
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

// ignore: must_be_immutable
class AddNewBg extends StatefulWidget {
  Uint8List? imageFile;

  AddNewBg({super.key, this.imageFile});

  @override
  State<AddNewBg> createState() => _AddNewBgState();
}

class _AddNewBgState extends State<AddNewBg> {
  String? imagePath;
  Uint8List? imageFileFromDevice;

  ScreenshotController controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Background'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (imageFileFromDevice != null)
                ? Stack(
                    children: [
                      Screenshot(
                        controller: controller,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(imageFileFromDevice!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Image.memory(widget.imageFile!),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(imageFileFromDevice!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Image.memory(widget.imageFile!),
                      ),
                    ],
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              child: const Text('Set a Background'),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                saveImage();
              },
              child: const Text('Download'),
            ),
          ],
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imagePath = pickedImage.path;
        imageFileFromDevice = await pickedImage.readAsBytes();
        setState(() {});
      }
    } catch (e) {
      imageFileFromDevice = null;
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
      String fileName = "${DateTime.now().microsecondsSinceEpoch}.jpg";
      controller.captureAndSave(directory, fileName: fileName);
    }
  }
}

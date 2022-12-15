

import 'dart:typed_data';

import 'package:flutter/material.dart';

class AddNewBg extends StatelessWidget {
  final Uint8List? imageFile;
  const AddNewBg({super.key, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Background'),
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/ewu.jpg'),
              fit: BoxFit.cover,
            ),
            
          ),
          child:  Image.memory(imageFile!),
        ),
      ),
    );
  }
}
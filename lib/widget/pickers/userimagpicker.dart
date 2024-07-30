import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Userimagpicker extends StatefulWidget {
  const Userimagpicker(this.imagepickfn);
  final Function(File picked) imagepickfn;
  @override
  State<Userimagpicker> createState() => _UserimagpickerState();
}

class _UserimagpickerState extends State<Userimagpicker> {
  File? _pickedimage;
  void pickImage() async{
    
    final pickedimagefile = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50, maxHeight: 150, maxWidth: 150); 
    setState(() {
      _pickedimage = File(pickedimagefile!.path); 
    });
    widget.imagepickfn(_pickedimage!);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: _pickedimage != null ? FileImage(_pickedimage!) : null,
        ),
        TextButton.icon(
          onPressed: pickImage,
          label: Text('add image'),
          icon: Icon(Icons.image),
        ),
      ],
    );
  }
}

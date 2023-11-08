import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  const AddImage(this.addImageFunc, {super.key});

  final Function(File pickedImage) addImageFunc;

  @override
  State<AddImage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddImage> {
  File? pickedImage; //변수의 값이 할당되지않았으므로 ?로 빨간 밑줄 해결
  void _pickImage() async {
    final imagePicker = ImagePicker();
    final pickedimagefile = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50, maxHeight: 150);
    setState(() {
      // 이 함수안에서의 호출은 state에서 무언가 변경된 사항이 있음을 framework에 알려주는 역할,
      // setState를 사용하지않고 pickImage의 경로를 지정해주면 이미지가 변경되지않는다
      if (pickedimagefile != null) {
        pickedImage = File(pickedimagefile.path);
      }
    });
    widget.addImageFunc(pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 10),
        width: 150,
        height: 300,
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              backgroundImage:
                  pickedImage != null ? FileImage(pickedImage!) : null,
            ),
            SizedBox(
              height: 10,
            ),
            OutlinedButton.icon(
                onPressed: () {
                  _pickImage();
                },
                icon: Icon(Icons.image),
                label: Text("add Icon")),
            SizedBox(
              height: 80,
            ),
            TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
                label: Text('close')),
          ],
        ));
  }
}

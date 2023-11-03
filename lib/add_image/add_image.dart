import 'package:flutter/material.dart';

class AddImage extends StatefulWidget {
  const AddImage({super.key});

  @override
  State<AddImage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<AddImage> {
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
            ),
            SizedBox(
              height: 10,
            ),
            OutlinedButton.icon(
                onPressed: () {},
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

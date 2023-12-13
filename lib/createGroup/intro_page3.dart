import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class IntroPage3 extends StatefulWidget {
    final Function(File) onImgSelected;
    IntroPage3({
    Key? key,
    required this.onImgSelected,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IntroPage3State createState() => _IntroPage3State();
}

class _IntroPage3State extends State<IntroPage3> {
  PageController _controller = PageController();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      color: Colors.white,
      width: 400,
      height: 650,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: 390,
              height: 390,

              // color: Colors.yellow,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.scaleDown,
                      image: AssetImage("images/teamGroups (2).jpeg"))),
              margin: EdgeInsets.all(20),
            ),
            Container(
              width: 411,
              height: 30,
              margin: EdgeInsets.only(left: 30, top: 5),
              child: Text(
                "Cover photo",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                width: 150,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Colors.amber,
                ),
                //padding: EdgeInsets.all(10),
                child: IconButton(
                  onPressed: () {
                    _pickImageFromGallery();
                  },
                  icon: Icon(Icons.image),
                )),
            const SizedBox(
              height: 30,
            ),
            _selectedImage != null
                ? Container(
                    child: Image.file(_selectedImage!),
                    width: 80,
                    height: 80,
                  )
                : Text("Please selected an image")
          ],
        ),
      ),
    ));
  }

  Future _pickImageFromGallery() async {
    final returnedPhoto =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedPhoto == null) {
      return;
    }

    setState(() {
      _selectedImage = File(returnedPhoto.path);
       widget.onImgSelected(_selectedImage!);
    });
  }
}

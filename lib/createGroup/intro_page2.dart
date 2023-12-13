import 'package:flutter/material.dart';

class IntroPage2 extends StatefulWidget {
  
    final Function(String) ondesChanged;
    IntroPage2({
    Key? key,
    required this.ondesChanged,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _IntroPage2State createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
  PageController _controller = PageController();
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
                      image: AssetImage("images/teamGroups (4).jpeg"))),
              margin: EdgeInsets.all(20),
            ),
            Container(
              width: 411,
              height: 30,
              margin: EdgeInsets.only(left: 30, top: 5),
              child: Text(
                "Describe",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.only(bottom: 10),
              child: TextField(
                keyboardType: TextInputType.name,
                maxLength: 50,
                maxLines: 3,
                minLines: 3,
                decoration: InputDecoration(
                  labelText: 'Describe your group',
                ),
                onChanged: (value) {
                  setState(() {
                  widget.ondesChanged(value);
                });
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

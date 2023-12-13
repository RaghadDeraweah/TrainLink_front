import 'package:flutter/material.dart';

class IntroPage1 extends StatefulWidget {

    final Function(String) onGroupNameChanged;
    final Function(String) onAboutChanged;
    IntroPage1({
    Key? key,
    required this.onGroupNameChanged,
    required this.onAboutChanged,
  }) : super(key: key);
   // String getter(){return groupname.text;}
  // void settername(String name){this.groupname.text=name;}
   //void setterabout(String about){this.about=about;}
  @override
  // ignore: library_private_types_in_public_api
  _IntroPage1State createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  PageController _controller = PageController();
  TextEditingController groupname = TextEditingController();
  String dropdownValue = "Flutter";

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
              width: 300,
              height: 300,

              // color: Colors.yellow,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/teamGroups (3).jpeg"))),
              margin: EdgeInsets.all(20),
            ),
            Container(
              width: 411,
              height: 30,
              margin: EdgeInsets.only(left: 30, top: 30),
              child: Text(
                "Name",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: groupname,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: 'Name your group',
                ),
                onChanged: (value) {
                setState(() {
                  groupname.text=value; 
                  widget.onGroupNameChanged(value);
                });
              },
              ),
            ),
            Divider(),
            Container(
              width: 411,
              height: 30,
              margin: EdgeInsets.only(left: 30, top: 10),
              child: Text(
                "About",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: 411,
              height: 30,
              margin: EdgeInsets.only(left: 18, top: 30),
              child: DropdownButton<String>(
                underline: Container(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18),
                alignment: Alignment.center,
                onChanged: (value) {
                setState(() {
                  dropdownValue = value!;
                  widget.onAboutChanged(value!);
                });
              },
                items: const [
                  DropdownMenuItem(
                    child: Text(
                      "Flutter",
                    ),
                    value: "Flutter",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "React",
                    ),
                    value: "React",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "Angular",
                    ),
                    value: "Angular",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "VueJs",
                    ),
                    value: "VueJs",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "Svelte",
                    ),
                    value: "Svelte",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "jQuery",
                    ),
                    value: "jQuery",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "Backbone.js",
                    ),
                    value: "Backbone.js",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "JavaScript",
                    ),
                    value: "JavaScript",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "Django",
                    ),
                    value: "Django",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "ExpressJS",
                    ),
                    value: "ExpressJS",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "Laravel",
                    ),
                    value: "Laravel",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "ASP .NET Core",
                    ),
                    value: "ASP .NET Core",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "Spring Boot",
                    ),
                    value: "Spring Boot",
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "-",
                    ),
                    value: "-",
                  ),
                ],
                value: dropdownValue,
                icon: Icon(Icons.arrow_drop_down_rounded),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

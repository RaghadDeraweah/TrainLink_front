import 'package:flutter/material.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:untitled4/Tabs/group.dart';
import 'package:untitled4/main.dart';

String? name = "Flutter Fall23";
String? members;

class MainSettings extends StatelessWidget {
  const MainSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: const Color(0xffff003566),
            icon: const Icon(Icons.arrow_back),
            iconSize: 30,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyApp();
              }));
            },
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Settings & Informations",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 290, top: 10),
                  child: Text(
                    "Account ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(right: 260, top: 10),
                    child: Text(
                      "Update your info",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    )),
                MaterialButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(Icons.account_circle_sharp),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text("Personal and account information")),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(Icons.security_sharp),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text("Password")),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                Container(
                    margin: EdgeInsets.only(right: 130, top: 10),
                    child: Text(
                      "Relationship & University",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                Container(
                  margin: EdgeInsets.only(right: 120, top: 10),
                  child: Text(
                    "View All data about Training students",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(Icons.handshake),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text("Dealing with the university")),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(Icons.engineering),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text("Trainees")),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                Container(
                  margin: EdgeInsets.only(right: 300, top: 10),
                  child: Text(
                    "Rating",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      "Evaluation of students about the company's dealings",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    )),
                MaterialButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(Icons.star_purple500_sharp),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Text("Trainees rating")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        
      ),
    );
  }
}

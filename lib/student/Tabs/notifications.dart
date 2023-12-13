import 'package:flutter/material.dart';

class Notification22 extends StatefulWidget {
  @override
  _Notification22State createState() => _Notification22State();
}

class _Notification22State extends State<Notification22> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                width: 411,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Notifications",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
                //  color: Colors.amber,
              ),
              Divider(),
              noti("images/studentBoy.jpeg", "Ahmad Khalel",
                  "Requisted your announced..", "1 minutes ago"),
              noti("images/studentBoy.jpeg", "Waleed Asad",
                  "Requisted your announced..", "5 minutes ago"),
              noti("images/studentGirl.jpeg", "Sally Qasem",
                  "Requisted your announced..", "10 minutes ago"),
              noti("images/studentBoy.jpeg", "Basem Ahmad",
                  "Submitted a report..", "50 minutes ago"),
              noti("images/studentGirl.jpeg", "Jana Belal",
                  "Requisted your announced..", "1 hour ago"),
              noti("images/studentGirl.jpeg", "Amal Hassan",
                  "Submitted a report..", "2 hours ago"),
              noti("images/studentGirl.jpeg", "Jana Belal",
                  "Requisted your announced..", "1 hour ago"),
              noti("images/studentGirl.jpeg", "Amal Hassan",
                  "Submitted a report..", "2 hours ago"),
              noti("images/studentGirl.jpeg", "Jana Belal",
                  "Requisted your announced..", "1 hour ago"),
              noti("images/studentGirl.jpeg", "Amal Hassan",
                  "Submitted a report..", "2 hours ago"),
              noti("images/studentGirl.jpeg", "Jana Belal",
                  "Requisted your announced..", "1 hour ago"),
              noti("images/studentGirl.jpeg", "Amal Hassan",
                  "Submitted a report..", "2 hours ago"),
            ],
          ),
        )));
  }
}

Widget noti(photo33, name33, contentpost33, time33) {
  return MaterialButton(
    onPressed: () {},
    // padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 411,
      height: 100,
      margin: EdgeInsets.only(bottom: 2),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                image: DecorationImage(
                    image: AssetImage(photo33), fit: BoxFit.cover)),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Column(
              children: [
                Container(
                  width: 200,

                  //color: Colors.amber,
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  child: Text(
                    name33,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  // alignment: Alignment.topLeft,
                ),
                Container(
                    width: 200,
                    // color: Colors.amber,
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      contentpost33,
                    )),
                Container(
                    width: 200,
                    //  color: Colors.amber,
                    child: Text(
                      time33,
                      style: TextStyle(color: Colors.grey.shade500),
                    ))
              ],
            ),
          ),
          Icon(Icons.more_horiz)
        ],
      ),
    ),
  );
}

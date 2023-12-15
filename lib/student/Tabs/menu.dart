import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled4/student/Tabs/contacts.dart';
import 'package:untitled4/student/Tabs/educational.dart';
import 'package:untitled4/student/Tabs/projects.dart';
import 'package:untitled4/student/Tabs/trainging.dart';


class Menu extends StatefulWidget {
    late Map<String,dynamic> stuinfo={};
    late bool fromstu;
  Menu(bool fromstu,Map<String,dynamic> stuinfo){
    super.key;
  this.stuinfo=stuinfo;
  this.fromstu=fromstu;}
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [

              Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 5,left: 5),
                    child: //widget.fromstu
                    //? 
                    Container( color: Color(0xff0F2C59),width: 1,)      ,            
                  /*  : IconButton(
                    onPressed:() {
                       Navigator.of(context).pop();
                    }, 
                    icon: Icon(Icons.arrow_circle_left,color: Color.fromARGB(255, 255, 255, 255),size: 35,)) ,                   
                   */
                    width: 411,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Color(0xff0F2C59),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40)),
                    ),
                  ),
                  Container(
                ///margin:EdgeInsets.only(top: 5),

                    width: 360,
                    height: 230,
                    margin: EdgeInsets.only(left: 25, top: 80),
                    decoration: BoxDecoration(
                        boxShadow: [
                          /* BoxShadow(
                           color: const Color.fromARGB(255, 243, 207, 90),
                            blurRadius: 13.0)*/
                          BoxShadow(color: Color(0xff003566), blurRadius: 5.0)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 100, left: 150),
                    decoration: BoxDecoration(
                      /* border: Border.all(
                    width: 1,
                    color: Colors.grey.shade400,
                  ),*/
                      boxShadow: [
                        /* BoxShadow(
                           color: const Color.fromARGB(255, 243, 207, 90),
                            blurRadius: 13.0)*/
                        BoxShadow(color: Color(0xff003566), blurRadius: 5.0)
                      ],
                      borderRadius: BorderRadius.circular(100),
                      // margin: EdgeInsets.only(left: 50, bottom: 50),
                      image: DecorationImage(
                          image: NetworkImage("http://localhost:5000/" + widget.stuinfo['img']),
                          fit: BoxFit.cover),
                    ),
                    width: 100.0,
                    height: 100,
                  ),
                  Container(
                    width: 300,
                    height: 100,
                    //color: Colors.white,
                    margin: EdgeInsets.only(left: 59, top: 210),
                    child: Column(
                      children: [
                        Container(
                            child: Text(
                          widget.stuinfo['fname']+" "+widget.stuinfo['lname'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff003566),
                              fontSize: 20),
                        )),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              widget.stuinfo['Major'],
                              style: TextStyle(
                                  color: Color.fromARGB(144, 0, 53, 102),
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            )),
                      ],
                    ),
                  )
                ],
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => educational(widget.stuinfo)));
                            // print("yes");
                          },
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  /* BoxShadow(
                             color: const Color.fromARGB(255, 243, 207, 90),
                              blurRadius: 13.0)*/
                                  BoxShadow(
                                      color: Color(0xff003566),
                                      blurRadius: 2.0,
                                      spreadRadius: 0.5)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 38, top: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          color: Color.fromARGB(36, 0, 53, 102),
                                        ),
                                        child: Icon(
                                          Icons.menu_book_outlined,
                                          color: Color(0xff003566),
                                          size: 35,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: Text(
                                          "Education",
                                          style: TextStyle(
                                              color: Color(0xff003566),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => traingingg(widget.stuinfo)));
                            print("yes");
                          },
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  /* BoxShadow(
                             color: const Color.fromARGB(255, 243, 207, 90),
                              blurRadius: 13.0)*/
                                  BoxShadow(
                                      color: Color(0xff003566),
                                      blurRadius: 2.0,
                                      spreadRadius: 0.5)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 38, top: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          color: Color.fromARGB(36, 0, 53, 102),
                                        ),
                                        child: Icon(
                                          Icons.workspace_premium,
                                          color: Color(0xff003566),
                                          size: 35,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: Text(
                                          "Training",
                                          style: TextStyle(
                                              color: Color(0xff003566),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => projects(widget.stuinfo,widget.fromstu)));
                          },
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  /* BoxShadow(
                             color: const Color.fromARGB(255, 243, 207, 90),
                              blurRadius: 13.0)*/
                                  BoxShadow(
                                      color: Color(0xff003566),
                                      blurRadius: 2.0,
                                      spreadRadius: 0.5)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 38, top: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          color: Color.fromARGB(36, 0, 53, 102),
                                        ),
                                        child: Icon(
                                          Icons.computer_rounded,
                                          color: Color(0xff003566),
                                          size: 35,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: Text(
                                          "Projects",
                                          style: TextStyle(
                                              color: Color(0xff003566),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => contacts3(widget.stuinfo)));
                          },
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  /* BoxShadow(
                             color: const Color.fromARGB(255, 243, 207, 90),
                              blurRadius: 13.0)*/
                                  BoxShadow(
                                      color: Color(0xff003566),
                                      blurRadius: 2.0,
                                      spreadRadius: 0.5)
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 38, top: 20),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          color: Color.fromARGB(36, 0, 53, 102),
                                        ),
                                        child: Icon(
                                          Icons.phone,
                                          color: Color(0xff003566),
                                          size: 35,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 15),
                                        child: Text(
                                          "Contact",
                                          style: TextStyle(
                                              color: Color(0xff003566),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        )));
  }
}
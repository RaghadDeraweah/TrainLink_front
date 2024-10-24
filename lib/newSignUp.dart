//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:untitled4/signupCOM.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:untitled4/signupSTU.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:untitled4/createGroup/intro_page1.dart';
import 'package:untitled4/createGroup/intro_page2.dart';
import 'package:untitled4/createGroup/intro_page3.dart';
import 'package:untitled4/createGroup/intro_page4.dart';
import 'package:untitled4/groupHomePage.dart';
import 'package:untitled4/Tabs/group.dart';

String? name = "Flutter Fall23";
String? members;

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  // ignore: library_private_types_in_public_api
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  PageController _controller = PageController();
  bool onLastPage = false;
  bool presseds=false;
  bool pressedc=false;
  bool Company=false;
  bool stu=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Stack(
      children: [
        Container(
              child:Image.asset("images/newlog.jpg",
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
             ), 
             //child: Text("login"),
        ),
        Positioned(
          bottom: 70, 
          child: Container( 
            margin :EdgeInsets.fromLTRB(5, 0, 5, 5),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color:Color.fromARGB(255, 253, 243, 243),
              borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40),bottomLeft: Radius.circular(40),bottomRight:Radius.circular(40)),
              ),
            padding: EdgeInsets.fromLTRB(10,40,20,10),
            width:402,
            height: 500,
            child: Column(
              children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                    "Who are you?",
                  style:TextStyle(
                    color: const Color.fromARGB(193, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                    

                  ),),
                    Container(height: 10,),
                  Text(
                    "Choose one that describes you",
                  style:TextStyle(
                    color: Color.fromARGB(141, 77, 76, 76),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,

                  ),
                  ),
                  ],)

                ),
                  Container(height: 40,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  ButtonTheme(  
                   // splashColor: Color.fromARGB(111, 10, 1, 71),   
                    
                    
                    /*presseds
                    ? Color.fromARGB(111, 10, 1, 71)
                    : Colors.white,*/
                     minWidth: 175,
                    height: 200,
                    shape: RoundedRectangleBorder( side: BorderSide(color:Color.fromARGB(255, 10, 1, 71) ), borderRadius: BorderRadius.circular(20.0)),
                    child :MaterialButton (
                      color: presseds
                    ? Color.fromARGB(110, 197, 188, 253)
                    : Color.fromARGB(255, 253, 243, 243),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person,size: 40,color: Color.fromARGB(111, 10, 1, 71),),
                                  Container(height: 20,),
                                  Text("Student",style: TextStyle(color: Color.fromARGB(255, 10, 1, 71),fontSize: 20),)
                                ],
                              ),
                        onPressed:() async{
                          setState(() {
                            stu=true;
                            presseds=!presseds;
                          });
                      },
                  ),
                  ),
                  ButtonTheme(
                    minWidth: 175,
                    height: 200,
                    shape: RoundedRectangleBorder( side: BorderSide(color:Color.fromARGB(255, 10, 1, 71) ), borderRadius: BorderRadius.circular(20.0)),
                    child :MaterialButton (
                      color: pressedc
                    ? Color.fromARGB(110, 197, 188, 253)
                    : Color.fromARGB(255, 253, 243, 243),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.work , size: 40,color: Color.fromARGB(111, 10, 1, 71) ,),
                                  Container(height: 20,),
                                  Text("Company",style: TextStyle(color: Color.fromARGB(255, 10, 1, 71),fontSize: 20),)
                                ],
                              ),
                        onPressed:() {
                          setState(() {
                          Company=true;
                          pressedc=!pressedc;                            
                          });
                      },
                      /*onPressed: () {
                        print("pressed");
                  },*/),
                  ),
               // ),
                    ],
                  ),
                  Container(height: 30,),
                  Container(
                  width: 433,
                  height: 50,
                  margin:EdgeInsets.fromLTRB(10, 20, 1, 0),
                  child: ButtonTheme(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
                    child :MaterialButton (
                      child: Text("Continue",style: TextStyle(fontSize: 20,),),
                      textColor: Colors.white,
                      color: Color.fromARGB(255 ,248, 154, 0),
                        onPressed:() async{
                          if(stu){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => signupSTU()));
                          }else if(Company){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => signupCOM()));
                          }
                      },
                      /*onPressed: () {
                        print("pressed");
                  },*/),
                  ),
                ),
            ]), 

            ),
          ),

      ],
    )
    );
  }
}

/*class signup extends StatefulWidget{
  signup({super.key});
  State<signup> createState() => _signupState(); 
}*/
/*
class students extends StatelessWidget {
  bool isPresseds = false;
  // bool isPressedc = false;
  //signup1({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 460),
            child: Image.asset(
              "images/sssign.jpeg",
              //fit: BoxFit.cover,

              width: 500,
              height: 1080,
            ),
          ),
          Positioned(
              bottom: 300,
              //left: 35,
              // width: 340,
              height: 150,
              child: Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 23),
                      child: Text(
                        "Sign Up As A  Student",
                        style: GoogleFonts.salsa(
                          textStyle: TextStyle(
                            fontSize: 34.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff007BA7),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        // width: 240,
                        margin: EdgeInsets.only(top: 20, left: 20),
                        child: Text(
                          "Explore Training opportunities and\n     launch your success journey!",
                          style: GoogleFonts.salsa(
                            textStyle: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff72A0C1),
                            ),
                          ),
                        ))
                  ],
                ),
              )),

          /* Positioned( 
                bottom: 430,
                left: 35,
                width: 340,
                height: 50,             
                child: ButtonTheme(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Color.fromARGB(255, 14, 31, 182)),
                  ),
                  child :MaterialButton (
                    child: Text("SIGNUP",style: TextStyle(fontSize: 28,),),
                   
                      textColor: Colors.white,
                      //color: isPresseds ? Color.fromARGB(255, 148, 132, 255): Color.fromARGB(255, 14, 31, 182) ,
                      onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => signupSTU()));
                      print("pressed");
                      },
                      /*onHighlightChanged: (isButtonPressed) {
                      setState(() {
                       isPresseds = isButtonPressed;
                      }); 
                      },    */                 
                      ), 
                  ),
                ),

*/
          Positioned(
            bottom: 190,
            left: 35,
            width: 340,
            height: 50,
            child: ButtonTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: Color.fromARGB(255, 10, 1, 71)),
              ),
              child: MaterialButton(
                child: Text("SIGNUP",
                    style: GoogleFonts.salsa(
                      textStyle: TextStyle(
                        fontSize: 28,
                      ),
                    )),

                textColor: Colors.white,
                color: Color(0xff007BA7),
                // color: isPressedc ? Color.fromARGB(255, 148, 132, 255): Color.fromARGB(255, 14, 31, 182) ,
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => signupSTU()));
                  print("pressed");
                },
                /* onHighlightChanged: (isButtonPressed) {
                      setState(() {
                       isPressedc = isButtonPressed;
                      }); 
                      },  */
              ),
            ),
          ),
        ],
      ),
      //  ),
    );
  }
}

class companies extends StatelessWidget {
  bool isPresseds = false;
  // bool isPressedc = false;
  //signup1({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 460),
            child: Image.asset(
              "images/cooom.jpeg",
              //fit: BoxFit.cover,

              width: 500,
              height: 1080,
            ),
          ),
          Positioned(
              bottom: 300,
              //left: 35,
              // width: 340,
              height: 150,
              child: Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 23),
                      child: Text(
                        "Sign Up As A  Company",
                        style: GoogleFonts.salsa(
                          textStyle: TextStyle(
                            fontSize: 34.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff007BA7),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        // width: 240,
                        margin: EdgeInsets.only(top: 20, left: 20),
                        child: Text(
                          "         Join to discover skilled \nstudents and streamline training!",
                          style: GoogleFonts.salsa(
                            textStyle: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff72A0C1),
                            ),
                          ),
                        ))
                  ],
                ),
              )),

          /*Positioned( 
                bottom: 430,
                left: 35,
                width: 340,
                height: 50,             
                child: ButtonTheme(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Color.fromARGB(255, 14, 31, 182)),
                  ),
                  child :MaterialButton (
                    child: Text("SIGNUP",style: TextStyle(fontSize: 28,),),
                   
                      textColor: Colors.white,
                      //color: isPresseds ? Color.fromARGB(255, 148, 132, 255): Color.fromARGB(255, 14, 31, 182) ,
                      onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => signupCOM()));
                      print("pressed");
                      },
                      /*onHighlightChanged: (isButtonPressed) {
                      setState(() {
                       isPresseds = isButtonPressed;
                      }); 
                      },    */                 
                      ), 
                  ),
                ),*/

          Positioned(
            bottom: 190,
            left: 35,
            width: 340,
            height: 50,
            child: ButtonTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: Color.fromARGB(255, 10, 1, 71)),
              ),
              child: MaterialButton(
                child: Text(
                  "SIGNUP",
                  style: GoogleFonts.salsa(
                      textStyle: TextStyle(
                    fontSize: 28,
                  )),
                ),

                textColor: Colors.white,
                color: Color(0xff007BA7), //Color.fromARGB(255, 14, 31, 182) ,
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => signupCOM()));
                  print("pressed");
                },
                /* onHighlightChanged: (isButtonPressed) {
                      setState(() {
                       isPressedc = isButtonPressed;
                      }); 
                      },  */
              ),
            ),
          ),
        ],
      ),
      //  ),
    );
  }
}*/
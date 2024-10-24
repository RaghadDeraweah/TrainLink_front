//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:untitled4/login.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:untitled4/newSignup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
//import 'package:untitled4/signup1.dart';
//String RegNum, String fname, String lname, String BD , String city, String gender, String SEmail,String SPhone, String Password,String Major,String GPa,List Interestss

class welcome extends StatefulWidget {
  welcome({super.key});
  State<welcome> createState() => _MyAppState();
}

class _MyAppState extends State<welcome> {
  /* int i=0;
  bool status=true;
  String? groupValue;
  int? groupValue1;
  String hobby="";
  bool? basketball=false;
   bool? fotball=false;
   GlobalKey<FormState> formState= GlobalKey();
   String? emadd;*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        //margin: EdgeInsets.only(top: 130),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            /*   Container(
              //  child:Image.asset("images/WelcomePP.png",
              //  fit: BoxFit.cover,
                width: 500,
                ),*/
            //  ),
            Center(
                child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: 400,
                  height: 420,
                  child: Image.asset("images/girlSit.jpeg"),
                ),
                /*  Container(
                  //margin: EdgeInsets.only(top: 30),
                  child: Text(
                    'TrainLink',
                    style: GoogleFonts.salsa(
                      textStyle: TextStyle(
                          fontSize: 44.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff003262)),
                    ),
                  ),
                ),*/
                Container(
                  // margin: EdgeInsets.only(top: 5),
                  child: Text(
                    "An-Najah University App ",
                    style: GoogleFonts.salsa(
                      textStyle: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          // color: Color(0xff003262),
                          color: Color(0xff007BA7)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "To make the training journey easier!",
                    style: GoogleFonts.salsa(
                      textStyle: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff007BA7),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 60),
                  child: Text(
                    "LET's GET STARTED!",
                    style: GoogleFonts.salsa(
                      textStyle: TextStyle(
                        fontSize: 34.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff007BA7),
                      ),
                    ),
                  ),
                ),
              ],
            )),
            Positioned(
              bottom: 160,
              left: 35,
              width: 340,
              height: 50,
              child: ButtonTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: MaterialButton(
                  child: Text(
                    "LOGIN",
                    style: GoogleFonts.salsa(
                        textStyle: TextStyle(
                      fontSize: 28,
                    )),
                  ),
                  textColor: const Color.fromRGBO(255, 255, 255, 1),
                  color: Color(0xff007BA7),
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => Login()));
                    print("pressed");
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => FilePickerExample()));
                    print("pressed");
                  },
                ),
              ),
            ),

            Positioned(
              bottom: 90,
              left: 35,
              width: 340,
              height: 50,
              child: ButtonTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: MaterialButton(
                  child: Text(
                    "SIGNUP",
                    style: GoogleFonts.salsa(
                        textStyle: TextStyle(
                      fontSize: 28,
                    )),
                  ),
                  textColor: Colors.white,
                  color: Color(0xff007BA7),
                  onPressed: () {
                    //registerUser();

                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => signup()));
                    print("pressed");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
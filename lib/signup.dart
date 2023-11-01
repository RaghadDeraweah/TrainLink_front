//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:untitled4/signupCOM.dart';
import 'package:untitled4/signupSTU.dart';
class signup extends StatefulWidget{
  signup({super.key});
  State<signup> createState() => _signupState(); 
}

class _signupState extends State<signup>{
  bool isPresseds = false;
  bool isPressedc = false;
  //signup1({super.key});
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      resizeToAvoidBottomInset: false,
        body:  Stack(
            children: [
              Container(
                child:Image.asset("images/stuORcom.png",
                fit: BoxFit.cover,
                width: 500,
                height: 1080,
                ), 
              ),
              
              Positioned( 
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
                      color: isPresseds ? Color.fromARGB(255, 148, 132, 255): Color.fromARGB(255, 14, 31, 182) ,
                      onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => signupSTU()));
                      print("pressed");
                      },
                      onHighlightChanged: (isButtonPressed) {
                      setState(() {
                       isPresseds = isButtonPressed;
                      }); 
                      },                     
                      ), 
                  ),
                ),


                Positioned(
                bottom: 80,
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
                      color: isPressedc ? Color.fromARGB(255, 148, 132, 255): Color.fromARGB(255, 14, 31, 182) ,
                      onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => signupCOM()));
                      print("pressed");
                      },
                      onHighlightChanged: (isButtonPressed) {
                      setState(() {
                       isPressedc = isButtonPressed;
                      }); 
                      },                     
                      ), 
                ),
                ),
              
            ],
          ),
                //  ),
      );
  }

}

//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:untitled4/signupCOM.dart';
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          onPageChanged: (Index) {
            setState(() {
              onLastPage = (Index == 1);
            });
          },
          controller: _controller,
          children: [students(), companies()],
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                  onTap: () {
                    _controller.previousPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  child: Text(
                    "back",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
              SmoothPageIndicator(controller: _controller, count: 2,),
              onLastPage
                  ? GestureDetector(
                      onTap: () {
                      /*  Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => groupHomePage()));*/
                        // print("yes");
                      },
                      child: Text(
                        "done",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ))
                  : GestureDetector(
                      onTap: () {
                        _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                      child: Text(
                        "next",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
            ],
          ),
          alignment: Alignment(0, 0.75),
        )
      ],
    );
  }
}


/*class signup extends StatefulWidget{
  signup({super.key});
  State<signup> createState() => _signupState(); 
}*/

class students extends StatelessWidget{
  bool isPresseds = false;
 // bool isPressedc = false;
  //signup1({super.key});
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      resizeToAvoidBottomInset: false,
        body:  Stack(
            children: [
              Container(
                child:Image.asset("images/students.png",
                fit: BoxFit.cover,
                width: 500,
                height: 1080,
                ), 
              ),
              
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
                bottom: 150,
                left: 35,
                width: 340,
                height: 50,  
                child: ButtonTheme(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Color.fromARGB(255, 10, 1, 71)),
                  ),
                  child :MaterialButton (
                    child: Text("SIGNUP",style: TextStyle(fontSize: 28,),),
                   
                      textColor: Colors.white,
                      color :  Color.fromARGB(255, 10, 1, 71),
                     // color: isPressedc ? Color.fromARGB(255, 148, 132, 255): Color.fromARGB(255, 14, 31, 182) ,
                      onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => signupSTU()));
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
class companies extends StatelessWidget{
  bool isPresseds = false;
 // bool isPressedc = false;
  //signup1({super.key});
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      resizeToAvoidBottomInset: false,
        body:  Stack(
            children: [
              Container(
                child:Image.asset("images/comp.png",
                fit: BoxFit.cover,
                width: 500,
                height: 1080,
                ), 
              ),
              
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
                bottom: 150,
                left: 35,
                width: 340,
                height: 50,  
                child: ButtonTheme(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Color.fromARGB(255, 10, 1, 71)),
                  ),
                  child :MaterialButton (
                    child: Text("SIGNUP",style: TextStyle(fontSize: 28,),),
                   
                      textColor: Colors.white,
                      color :  Color.fromARGB(255, 10, 1, 71), //Color.fromARGB(255, 14, 31, 182) ,
                      onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => signupCOM()));
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

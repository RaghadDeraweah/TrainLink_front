import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/HomePage.dart';
import 'package:untitled4/changePWD/ForgotPassworD.dart';
import 'package:untitled4/student/HomeStu.dart';

class Login extends StatefulWidget{
  Login({super.key});
  State<Login> createState() => _MyAppState(); 
}
 class _MyAppState extends State<Login>  {
  String? id;
  String email="";
  String? pwd;
  bool offsecure=true;
  RegExp regex = RegExp(r'^s\d{8}@stu\.najah\.edu$');
  RegExp gmail = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
  RegExp yahoo = RegExp(r'^[a-zA-Z0-9._%+-]+@yahoo\.com$');
  RegExp outlook = RegExp(r'^[a-zA-Z0-9._%+-]+@outlook\.com$');


  TextEditingController _Email = TextEditingController();
  TextEditingController _Password = TextEditingController();
  GlobalKey<FormState> loginform= GlobalKey();
  final networkHandler = NetworkHandlerS();
  final networkHandlerC = NetworkHandlerC();
  void _togglePasswordVisibility() {
    setState(() {
      offsecure = !offsecure;
    });
  }
  
  @override
  Widget build(BuildContext context) {
        return Scaffold(
      resizeToAvoidBottomInset: false,
      body:Stack(
        children: [
          Container(
              child:Image.asset("images/newlog.jpg",
              fit: BoxFit.cover,
              width: 500,
              height: 1080,
             ), 
             //child: Text("login"),
              ),
                  ],
      )
           
     
    );
  }
 }
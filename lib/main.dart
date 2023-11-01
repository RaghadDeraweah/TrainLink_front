//import 'dart:js_util';

import 'package:flutter/material.dart';

import 'package:untitled4/welcome.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget{
  MyApp({super.key});
  State<MyApp> createState() => _MyAppState(); 
}
 class _MyAppState extends State<MyApp>  {
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: welcome() ,
    );
  }

}

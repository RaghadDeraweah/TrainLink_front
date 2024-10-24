//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:untitled4/notifications/notification.dart';
import 'package:untitled4/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled4/start.dart';
Future <void> _firebaseMessagingBackgroundHander(RemoteMessage message) async {
  print("Handling a background message ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHander);
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
      debugShowCheckedModeBanner: false,
        home:teck() ,
    );
  }

}

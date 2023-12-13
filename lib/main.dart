//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:untitled4/welcome.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   //WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    String? token = await FirebaseMessaging.instance.getToken();


/*  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // Handle notification when app is in the foreground
    print("Received message in foreground: $message");
    // TODO: Add code to display a notification or update UI in the foreground
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Handle notification when app is in the background and opened by the user
    print("Opened app from notification: $message");
    // TODO: Add code to navigate to a specific screen or update UI when opened from notification
  });*/
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
  }
});
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Got a message whilst in the foreground!');
  if (message.notification != null) {
    print('Notification Title: ${message.notification?.title}');
    print('Notification Body: ${message.notification?.body}');
  }
});
  // Print the token to the console
  print("FCM Token: $token");
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

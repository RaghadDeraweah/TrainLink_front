
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/Tabs/group.dart';
import 'package:untitled4/Tabs/home.dart';
import 'package:untitled4/Tabs/menu.dart';
import 'package:untitled4/Tabs/notifications.dart';
import 'package:untitled4/Tabs/reports.dart';
import 'package:untitled4/SearchStudent.dart';
import 'package:untitled4/home.dart';
import 'package:untitled4/login.dart';
import 'package:untitled4/masseges.dart';
import 'package:untitled4/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:untitled4/notifications/new_screen.dart';

class MyHomePage extends StatefulWidget {
  int selectedPage;
  MyHomePage(this.selectedPage);
  @override
  _MyHomePageState createState() => _MyHomePageState(selectedPage);
}

class _MyHomePageState extends State<MyHomePage> {
  bool doadd=false;
  String? mtoken = " ";
  late FlutterLocalNotificationsPlugin  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final networkHandler = NetworkHandlerC();
  Map<String,dynamic> companyinfo={};
  int selectedPage;
  late String IDCompany;
  bool isDataReady=false;
  String messageId="";
  String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  Map<String,dynamic> temp={};
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
  length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  Future AddMessage(String userid, String nid,Map<String, dynamic> notif) async {
    print("inside add new noti");
    return FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(userid)
        .collection("notifications")
        .doc(nid)
        .set(notif);
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("my token is $mtoken");
      });
       saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(IDCompany)
        .set({'token': token});
  }

  initInfo(){
    var androidInitialize = const AndroidInitializationSettings('@mipmap/trainlink');
    //var iOSInitialize = const IOSInitializationSettings();
    //var iOSInitialize = const DarwinInitializationSettings();
    var initialzationsSettings = InitializationSettings(android:androidInitialize);

     flutterLocalNotificationsPlugin.initialize(initialzationsSettings,onDidReceiveNotificationResponse: (details) {
       try{
         if (details.payload != null){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return NewPage(info: details.payload.toString());
          }));
         }else{

         }
       }catch(e){

       }
       return;
     },
      );
     FirebaseMessaging.onMessage.listen((RemoteMessage message)async {
       print("................onMessage...............");
       print("onMessage : ${message.notification?.title}/${message.notification?.body}}");
         setState(() {
        temp={
        'title':message.notification?.title,
        'body':message.notification?.body,
        'time':FieldValue.serverTimestamp(),
        'ID':message.data['ID'] ?? "",
        'img':message.data['img'] ?? "",
        'name':message.data['name'] ?? "",
        'type':message.data['type'] ?? "",
        'eid':message.data['eid'] ?? "",
       };

       messageId = getRandomString(10) ;
       print(temp);
       print(messageId);
        doadd=true;
      });
      if(doadd){
        //AddMessage(IDCompany, messageId, temp);
        setState(() {
          doadd=false;
        });
      }

       BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
         message.notification!.body.toString(),htmlFormatBigText: true,
       );
       AndroidNotificationDetails androidPlatformChannelSpecifies = AndroidNotificationDetails('dbfood', 'dbfood',importance: Importance.high,styleInformation: bigTextStyleInformation,priority: Priority.high,playSound: true ,icon: '@mipmap/trainlink',);
       NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifies);
       await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
           message.notification?.body,
           platformChannelSpecifics,payload: message.data['body']
           );

  
     });

  }
  



  _MyHomePageState(this.selectedPage);
  @override
  void initState() {
  super.initState();
      fetchData().then((_) {
      setState(() {
        requestPermission();
        getToken();
        initInfo();
        isDataReady=true;
         print("from Home"+IDCompany);
      });
      },);
}
Future<void> fetchData() async {
  try {
    IDCompany = await networkHandler.getidddd();
    print(IDCompany);
    companyinfo = await networkHandler.fetchCompanyData(IDCompany!);
    companyinfo.values.forEach((value) {
      print(value);
    });

    isDataReady=true;
  } catch (error) {
    print(error);
  }
}
void logoutcompany() async {
    networkHandler.logout();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false);
    print("Log Out");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: selectedPage,
      length: 5,
      child: isDataReady
      ? Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          leading:  Container(
                width: 5,
                height: 5,
                child: Image(image: AssetImage("images/logo.png"),fit: BoxFit.cover,width:5,height: 5,)
                ),
          title: Text(
            "TrainLink",
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Home(this.companyinfo))); //masseges() ChScreen(userId:IDCompany,chatId: "Xngm883YAN4oEg7e0wwe")
              },
              icon: Icon(Icons.message),
              color: Colors.black,
            ),
            IconButton(
              onPressed: () {
                logoutcompany(); //masseges() ChScreen(userId:IDCompany,chatId: "Xngm883YAN4oEg7e0wwe")
              },
              icon: Icon(Icons.exit_to_app_rounded),
              color: Colors.black,
            ),
          ],
          //Tab Bar
          bottom: const TabBar(
            //isScrollable: true,
            unselectedLabelColor: Color(0xff003566),
            indicatorColor: Color(0xffffc300),
            labelColor: Color(0xffffc300),
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  size: 28,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.groups,
                  size: 28,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.notifications_none,
                  size: 28,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.task_outlined,
                  size: 28,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.format_align_justify,
                  size: 28,
                ),
              ),
            ],
          ),
        ),

        //Tab Bar View
        body: TabBarView(
          children: <Widget>[
            HomeScreen(token: mtoken!,),
            GroupScreen(IDCompany,companyinfo['Name'],companyinfo['img']),
            Notification22(IDCompany),
            Reports22( CID: IDCompany,),
            Forms(CID: IDCompany,),
          ],
        ),

      )
      :Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }
}

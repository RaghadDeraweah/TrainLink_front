import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/login.dart';
import 'package:untitled4/student/Tabs/chats.dart';
import 'package:untitled4/student/Tabs/edu.dart';
import 'package:untitled4/student/Tabs/group.dart';
import 'package:untitled4/student/Tabs/home.dart';
import 'package:untitled4/student/Tabs/menu.dart';
import 'package:untitled4/student/Tabs/notifications.dart';
//import 'package:untitled4/student/Tabs/notifications.dart';
import 'package:untitled4/student/Tabs/reports.dart';
import 'package:untitled4/student/companypage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:untitled4/notifications/new_screen.dart';
import 'package:untitled4/student/openNewPost.dart';



class MyHomeStu extends StatefulWidget {
  int selectedPage;
  MyHomeStu(this.selectedPage);
  @override
  _MyHomeStuState createState() => _MyHomeStuState(selectedPage);
}

class _MyHomeStuState extends State<MyHomeStu> {
    bool doadd=false;
    String? mtoken = " ";
    String? posttype = " ";
    String posid = " ";
  late FlutterLocalNotificationsPlugin  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final networkHandler = NetworkHandlerS();
  final networkHandlerC = NetworkHandlerC();
  Map<String,dynamic> studentinfo={};
  Map<String,dynamic> groupinfo={};
  List<String> companiesNames=[];
  List<Map<String,dynamic>> companies=[];
  int selectedPage;
  late String IDS;
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

  _MyHomeStuState(this.selectedPage);

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
        .doc(IDS)
        .set({'token': token});
  }

  initInfo(){
    var androidInitialize = const AndroidInitializationSettings('@mipmap/trainlink');
    var initialzationsSettings = InitializationSettings(android:androidInitialize);

     flutterLocalNotificationsPlugin.initialize(initialzationsSettings,onDidReceiveNotificationResponse: (details) {
       try{
         if (details.payload != null && posttype=="newpost"){
          print("inside posid=$posid");
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){           
            return openpost(postid: posid);
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
          posttype=message.data['type'];
          print("posttype = $posttype");
          posid=message.data['eid'] ;
          print("posid = $posid");
          });
          //if(message.data['type'])
    /*    temp={
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
        //AddMessage(IDS, messageId, temp);
        setState(() {
          doadd=false;
        });
      }*/

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

    @override
  void initState() {
  super.initState();
      fetchData().then((_) {
      setState(() {
        requestPermission();
        getToken();
        initInfo();
        isDataReady=true;
         print("from Home "+IDS);
      });
      },);
}
  void logoutstu() async {
    networkHandler.logout();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false);
    print("Log Out");
  }
Future<void> fetchData() async {
  try {
    print("*******************");
    companies=await networkHandlerC.fetchCompanies();
    print("*******************$companies");
    print(companies);
    for(var map in companies){
      map.forEach((key, value) {
        if(key=="Name"){
          setState(() {
            companiesNames.add(value);
          });

        }
      });
    }

    IDS = await networkHandler.getid();
    print(IDS);
    studentinfo = await networkHandler.fetchStudentData(IDS!);
    print(studentinfo);
    studentinfo.values.forEach((value) {
      print(value);
    });
    if(studentinfo['available']==false){
      print("not available");
      groupinfo = await networkHandlerC.getGroupById(studentinfo['groupid']);
      groupinfo.values.forEach((element) {print(element);});
      //print("Group"+groupinfo);
    }



    isDataReady=true;
  } catch (error) {
    print(error);
  }
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
              onPressed: () async{
              await showSearch(
                context: context,
                delegate: CustomSearchDelegate(companiesNames,studentinfo,companies),
              );
              },
              icon: Icon(Icons.search),
              color: Colors.black,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Home(studentinfo)));
              },
              icon: Icon(Icons.message),
              color: Colors.black,
            ),
            IconButton(
              onPressed: () {
                logoutstu(); //masseges() ChScreen(userId:IDCompany,chatId: "Xngm883YAN4oEg7e0wwe")
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
                  Icons.person_2_rounded,
                  size: 28,
                ),
              ),
            ],
          ),
        ),

        //Tab Bar View
        body: TabBarView(
          children: <Widget>[
            HomeScreen(),
            studentinfo['available']
            ?   Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(30),
                                margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
                                child: const Text(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff003566),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    "Join us and become a part of our journey!"),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                width: 200,
                                height: 200,
                                child: Image.asset(
                                  "images/groups.png",
                                  fit: BoxFit.cover,
                                  width: 500,
                                ),
                              )
                            ],
                          ),
                        )
           : MyGroupHomePage(studentinfo['groupid'],studentinfo['RegNum'],studentinfo['fname']+" "+studentinfo['lname'],studentinfo['img'],groupinfo['groupname']),
            Notification22(studentinfo['RegNum']),
                
            studentinfo['available'] || (studentinfo['universityTraining']  && !studentinfo['available'])
            ?  Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
                                padding: EdgeInsets.all(30),
                                child: const Text(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff003566),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    "Join us! \n To get started  go to the home tab and \n begin your development journey with us!"),
                              ),
                              Container(
                                width: 270,
                                height: 270,
                                child: Image.asset(
                                  "images/reportsout.png",
                                  fit: BoxFit.cover,
                                  width: 500,
                                ),
                              )
                            ],
                          ),
                        )
            : Reports22(this.studentinfo),
            Menu(true,this.studentinfo,),
            //edu()
          ],
        ),
      )
      :Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }
}
class CustomSearchDelegate extends SearchDelegate<String> {
  // Dummy list
  late List<String> names;
  late Map<String ,dynamic> student;
  late List<Map<String ,dynamic>> companies;
  CustomSearchDelegate(List<String> names,Map<String ,dynamic> student,List<Map<String ,dynamic>> companies){
    this.companies=companies;
    this.names=names;
    this.student=student;
  }
  // These methods are mandatory you cannot skip them.

  @override
  List<Widget> buildActions(BuildContext context) {
     return [
    IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        query = '';
        // When pressed here the query will be cleared from the search bar.
      },
    ),
  ];
  }

  @override
  Widget buildLeading(BuildContext context) {
        return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
        // Exit from the search screen.
    );
  }

  @override
  Widget buildResults(BuildContext context) {
      final List<String> searchResults = names;
      //.where((item) => item.toLowerCase().contains(query.toLowerCase()))
      //.toList();
  return ListView.builder(
    itemCount: searchResults.length,
    itemBuilder: (context, index) {
      return Container(
        height: 50,
        width: 411,
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 204, 204, 204),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 20),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  image: DecorationImage(
                    image: NetworkImage("http://localhost:5000/" + companies[index]['img']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                searchResults[index],
                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0),fontSize: 18),
              ),
            ],
          ),
          onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchCompany(companies[index]['ID'],student)));
            // Handle the selected search result.
            //close(context, searchResults[index]);
          },
        ),
      );
    },
  );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
     final List<String> suggestionList = query.isEmpty
      ? []
      : names
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    List<Map<String,dynamic>>  temp=[];
    for(int i=0;i<suggestionList.length;i++){
      for(int j=0;j<companies.length;j++){
        if(suggestionList[i]==companies[j]['Name']){
          Map<String,dynamic> tempp={
            'RegNum' :companies[j]['ID'],
            'name':suggestionList[i],
            'img':companies[j]['img'],

          };
          temp.add(tempp);
          print(temp);

        }
      }
    }
  return ListView.builder(
    itemCount: temp.length,
    itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(10),
        height: 60,
        width: 411,
        padding: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          color: Color.fromARGB(174, 0, 53, 102),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Row(
            children: [
              Container(

                margin: EdgeInsets.only(right: 20,bottom: 10,top: 5),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  image: DecorationImage(
                    image: NetworkImage("http://localhost:5000/" + temp[index]['img']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                //alignment: Alignment.centerLeft,
              child:Text(
                temp[index]['name'],
                style: TextStyle(color: Colors.white,fontSize: 18),
              ),),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchCompany(temp[index]['RegNum'],this.student)));
            // Handle the selected search result.
           // close(context, suggestionList[index]);
          },
        ),
      );

    },
  );
  }
}
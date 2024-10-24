//import 'dart:html';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/GroupTaps/posts.dart';
import 'package:untitled4/GroupTaps/showmembers.dart';
import 'package:untitled4/GroupTaps/tasks.dart';
import 'package:untitled4/Tabs/group.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
/*class MyGroupHomePage extends StatelessWidget {
  final VoidCallback onDataRefresh;
  late String Taskid;
  late String idgroup;
  late String CID;
  late String cname;
  late String cimg;
  late String groupname;
   int selectedPage=0;
  MyGroupHomePage({required this.idgroup,required this.CID,required this.cname,required this.cimg,required this.groupname,required this.onDataRefresh});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: const Color(0xffff003566),
            icon: const Icon(Icons.arrow_back),
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          primary: false,
          backgroundColor: Colors.white,
         /* title: const Text(
            "Task Details",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),*/
        ),
        body: MyGroupHomePagesS(this.idgroup,this.CID,this.cname,this.cimg,this.groupname),
      ),
    );
  }
}*/

class MyGroupHomePage extends StatefulWidget {
/*   late String idgroup;
  late String CID;
  late String cname;
  late String cimg;
  late String groupname;
   int selectedPage=0;*/
     final VoidCallback onDataRefresh;
  late String Taskid;
  late String idgroup;
  late String CID;
  late String cname;
  late String cimg;
  late String groupname;
   int selectedPage=0;
    MyGroupHomePage({required this.idgroup,required this.CID,required this.cname,required this.cimg,required this.groupname,required this.onDataRefresh});
 /* MyGroupHomePagesS(String _id,String CID ,String cname, String cimg,String groupname){
    selectedPage=this.selectedPage;
    super.key;
    this.idgroup=_id;
    this.CID=CID;
    this.cname=cname;
    this.cimg=cimg;
    this.groupname=groupname;
  }*/

  @override
  _MyHomePageState createState() => _MyHomePageState(selectedPage);
}

class _MyHomePageState extends State<MyGroupHomePage> {
    bool greenNow=false;
  bool yellowNow=false;
      Map<String, dynamic>  groupinfo={};
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
  
  _MyHomePageState(this.selectedPage);
  @override
void initState() {
  super.initState();
      fetchData().then((_) {
      setState(() {
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
    groupinfo = await networkHandler.getGroupById(widget.idgroup);
    groupinfo.values.forEach((value) {
      print(value);
    });
    isDataReady=true;
  } catch (error) {
    print(error);
  }
}
void sendPushMessage(String token, String body , String title ,String type )async{
    try{
      print("////////////////////////////////////////////////////////////////Sending");
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers:<String,String>{
          'Content-Type':'application/json',
          'Authorization':'key=AAAAmDSv3W4:APA91bELF6hUFbbWYjwqVxszPYU7273f886c9VezyyMoi2xHzzT398GwtbxQ7ecmomD9s40KleqUU0yl5NZNiuF7FRBu77cbbtWgG8pY8QqZFyTxcCPXKXNJU1a0wfmQRPB208jhNOn-'
        },
        body: jsonEncode(
          <String,dynamic>{
            'priority':'high',
            'data':{
              'click_action':'FLUTTER_NOTIFICATION_CLICK',
              'status':'done',
              'body':body,
              'title':title,
              'ID':IDCompany,
              'img':companyinfo['img'],
              'name':companyinfo['Name'],
              'type':type,
            },
            "notification":<String,dynamic>{
              "title":title,
              "body":body,
              "android_channel_id":"dbfood"
            },
            "to":token,
          }
        )
      );
    }catch(e){
      if(kDebugMode){
        print("Error sending push notification: $e");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
          leading: IconButton(
            color: const Color(0xffff003566),
            icon: const Icon(Icons.arrow_back),
            iconSize: 30,
            onPressed: () {
              widget.onDataRefresh();
              Navigator.of(context).pop();
            },
          ),
          primary: false,
          backgroundColor: Colors.white,

        ),
    body: DefaultTabController(
      initialIndex: selectedPage,
      length: 2,
      child: isDataReady
      ? NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
     // shrinkWrap: true,
     return <Widget>[
      //slivers: [
        SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: 315.0, 
                leading: IconButton(icon:Icon(Icons.add),color: Colors.white, onPressed: () {  },),
          //Tab Bar
          
               // expandedHeight: 470.0, 
            flexibleSpace: FlexibleSpaceBar(
              
                 background:Column(children: [ 
               // Stack(children: [

                Container(
                
                 width: 411,
                 height: 150,
                  decoration: BoxDecoration(
                  image: DecorationImage(
                      image:NetworkImage("http://localhost:5000/"+ groupinfo['groupImg']),
                      fit: BoxFit.cover)),
            ),
           
                Container(
                margin: EdgeInsets.only(top: 10),
                child: MaterialButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                      child: Container(
                        width: 235,
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          groupinfo['groupname'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),),
                      Expanded(
                       // width: 120,
                       flex: 2,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment:CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        Tooltip(
                        message: "Exam Phase",
                        child: IconButton(onPressed:() {
                          
                        },
                        tooltip:"Exam Phase" , 
                        icon: groupinfo['phase']=="Assessment"
                        ? Icon(Icons.circle,color: Colors.deepOrangeAccent,)
                        : Icon(Icons.circle_outlined,color: Colors.deepOrangeAccent,),
                        ),),
                        Tooltip(
                        message: "Interview Phase",                          
                          child:IconButton(onPressed:() async {

                            if(groupinfo['phase'] =="Assessment"){
                              for(int m=0;m<groupinfo['membersStudentId'].length;m++){
                                    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("UserTokens").doc(groupinfo['membersStudentId'][m]).get();
                                   if (snap.exists) {
  // Check if the 'token' field exists in the document
                                      if (snap.data() != null && snap['token']!= null) {
                                        String token = snap['token'];
                                        print(token);
                                        sendPushMessage(token, "you have qualified for the interview phase in ${widget.cname} training", "TrainLink", 'group');
                                        Map<String,dynamic> newtemp={
                                              'title':'TrainLink',
                                              'body':"you have qualified for the interview phase in ${widget.cname} training",
                                              'time':FieldValue.serverTimestamp(),
                                              'ID':groupinfo['cid'] ?? "",
                                              'img':companyinfo['img'] ?? "",
                                              'name':companyinfo['Name']?? "",
                                              'type':'group' ,
                                              'eid':groupinfo['_id'] ?? "",
                                            };
                                      messageId = getRandomString(10) ;
                                      AddMessage(groupinfo['membersStudentId'][m], messageId, newtemp);                                        
                                      } else {
                                        print("The 'token' field does not exist in the document.");
                                      }
                                    } else {
                                      print("Document does not exist with the specified ID.");
                                    }
                                   /*if(snap !=null){
                                    String token = snap['token'];
                                    print(token);
                                    sendPushMessage(token, "you have qualified for the interview phase in ${widget.cname} training", "TrainLink" ,'group');
                              }*/}
                            setState(()  {
                            isDataReady=false;
                            networkHandler.updateGroupphase(groupinfo['_id'],"selection");
                                 
                            yellowNow=true;                         
                            });
                            if(yellowNow){
                            fetchData().then((_) {
                            setState(() {
                              isDataReady=true;
                              yellowNow=false;
                            });
                            },);
                            }
                            }
                          }, 
                        icon: groupinfo['phase']=="selection" || yellowNow
                        ? Icon(Icons.circle,color: Colors.amber)
                        : Icon(Icons.circle_outlined,color: Colors.amber,),
                          ),),
                        Tooltip(
                        message: "Training Phase",                          
                          child: IconButton(
                            onPressed:() async {

                              if(groupinfo['phase'] =="selection"){
                              for(int m=0;m<groupinfo['membersStudentId'].length;m++){
                              DocumentSnapshot snap = await FirebaseFirestore.instance.collection("UserTokens").doc(groupinfo['membersStudentId'][m]).get();
                               if (snap.exists) {
  // Check if the 'token' field exists in the document
                              if (snap.data() != null && snap['token']!= null) {
                                String token = snap['token'];
                                print(token);
                                sendPushMessage(token, "you have passed the final phase in ${widget.cname} training, so wait for new news", "TrainLink" ,'group');
                                Map<String,dynamic> newtemp={
                                              'title':'TrainLink',
                                              'body':"you have passed the final phase in ${widget.cname} training, so wait for new news",
                                              'time':FieldValue.serverTimestamp(),
                                              'ID':groupinfo['cid'] ?? "",
                                              'img':companyinfo['img'] ?? "",
                                              'name':companyinfo['Name']?? "",
                                              'type':'group' ,
                                              'eid':groupinfo['_id'] ?? "",
                                            };
                                      messageId = getRandomString(10) ;
                                      AddMessage(groupinfo['membersStudentId'][m], messageId, newtemp);
                              } else {
                                print("The 'token' field does not exist in the document.");
                              }
                            } else {
                              print("Document does not exist with the specified ID.");
                            }

                              
                            } 
                            setState(()  {
                             isDataReady=false;
                            networkHandler.updateGroupphase(groupinfo['_id'],"starting");
                            networkHandler.updateStartDate(groupinfo['_id']); 
                            greenNow=true;                             
                            });
                            if(greenNow){
                            fetchData().then((_) {
                            setState(() {
                              isDataReady=true;
                              greenNow=false;
                            });
                            },);
                            }
                            }
                            },
                        icon: groupinfo['phase']=="starting" || greenNow
                        ? Icon(Icons.circle,color: Colors.green)
                        : Icon(Icons.circle_outlined,color: Colors.green,),
                             ) ,
                        )
                        
                      ],),),
                   /* Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 17,
                      color: Colors.grey,
                    )*/
                  ],
                ),
              ),
            ),
                Container(
              margin: EdgeInsets.only(
                left: 20,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.people_alt,color: Color.fromARGB(255, 46, 46, 46),),
                    onPressed: () {
                      //showMem
                          setState(() {
                            isDataReady=false;
                          });
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => showMem(groupinfo: groupinfo, onDataRefresh: (){
                            fetchData().then((_) {
                            setState(() {
                              isDataReady=true;
                            });
                            },);                              
                            },)));
                            //MaterialPageRoute(builder: (context) => showMem( groupinfo['_id'],widget.CID,widget.cname,widget.cimg,groupinfo['membersStudentId'],groupinfo['membersStudent'])));
                    },
                    ),
                  Text(
                    groupinfo['membersStudent'].length.toString(),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    " members",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w900),
                  )
                ],
              ),
            ),
             /*   Container(
              width: 380,
              margin: EdgeInsets.only(right: 210, top: 10),
             // child: MaterialButton(
               // color: Colors.blue,
                //textColor: Colors.white,
             /*   shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),*/
                //onPressed: () {},
                child:// Row(
                  //children: [
                    //Icon(Icons.group_add_sharp),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        groupinfo['des'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    //Icon(Icons.arrow_drop_down_sharp)
                  //],
                //),
              //),
            ),
             */
             /*TabBar(
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
                  Icons.task_outlined,
                  size: 28,
                ),
              ),

            ],
          ),*/
                /*Divider(
              thickness: 5,
            ),*/

              /*  Container(
                  width: 390.0,
                  height: 50.0,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  // color: Color(0xff003566),
                  child: Row(
                    children: <Widget>[
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.post_add,
                                color: Color(0xff003566),
                                size: 40.0,
                              ),
                              ),

                         /* Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 2.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      width: 1.0, color: Colors.grey.shade400),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(60.0))),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => GroupPost(widget.cname,widget.CID,widget.cimg,widget.idgroup,groupinfo['groupname']),
                                ));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 13.0),
                                child: Text(
                                  "Let's announce a training!                                ",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.blueGrey),
                                ),
                              ),
                            ),
                          ),*/

                    ],
                  ),
                ),*/
                /*Divider(
                  thickness: 5,
                ),*/
                 ],
                 ),  
                ),
         /* actions: <Widget>[
            
           Column(children: [ 
               // Stack(children: [
                Container(
                 width: 411,
                 height: 220,
                  decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurStyle: BlurStyle.outer,
                        blurRadius: 3,
                        color: Colors.blueGrey)
                  ],
                  image: DecorationImage(
                      image:NetworkImage("http://localhost:5000/"+ groupinfo['groupImg']),
                      fit: BoxFit.cover)),
            ),
                Container(
                margin: EdgeInsets.only(top: 10),
                child: MaterialButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          groupinfo['groupname'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                   /* Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 17,
                      color: Colors.grey,
                    )*/
                  ],
                ),
              ),
            ),
                Container(
              margin: EdgeInsets.only(
                left: 20,
              ),
              child: Row(
                children: [
                  Text(
                    groupinfo['membersStudent'].length.toString(),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    " members",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w900),
                  )
                ],
              ),
            ),
                Container(
              width: 380,
              margin: EdgeInsets.only(right: 210, top: 10),
             // child: MaterialButton(
               // color: Colors.blue,
                //textColor: Colors.white,
             /*   shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),*/
                //onPressed: () {},
                child:// Row(
                  //children: [
                    //Icon(Icons.group_add_sharp),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        groupinfo['des'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    //Icon(Icons.arrow_drop_down_sharp)
                  //],
                //),
              //),
            ),
                Divider(
              thickness: 5,
            ),

                Container(
                  width: 390.0,
                  height: 50.0,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  // color: Color(0xff003566),
                  child: Row(
                    children: <Widget>[
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.post_add,
                                color: Color(0xff003566),
                                size: 40.0,
                              ),
                              ),

                          /*Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 2.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      width: 1.0, color: Colors.grey.shade400),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(60.0))),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => GroupPost(widget.cname,widget.CID,widget.cimg,widget.idgroup,groupinfo['groupname']),
                                ));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 13.0),
                                child: Text(
                                  "Let's announce a training!                                ",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.blueGrey),
                                ),
                              ),
                            ),
                          ),*/

                    ],
                  ),
                ),
                Divider(
                  thickness: 5,
                ),
                 ],
                 ),  
          ],
          */
          bottom : const TabBar(
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
                  Icons.task_outlined,
                  size: 28,
                ),
              ),

            ],
          ),
       
        ),
      
        //Tab Bar View
       /* SliverList(delegate: _SliverAppBarDelegate( TabBarView(
          children: <Widget>[
            groupHomePage(widget.idgroup,widget.CID,widget.cname,widget.cimg),
            TaskssList(widget.idgroup,widget.CID,widget.cname,widget.cimg),
          ],
        ),),),*/

      ];
      
  },
  body:TabBarView(
          children: <Widget>[
            groupHomePage(widget.idgroup,widget.CID,widget.cname,widget.cimg),
            TaskssList(widget.idgroup,widget.CID,widget.cname,widget.cimg,widget.groupname,groupinfo['membersStudentId']),
          ],
        ),
  )
      :Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    )
    );
  }
}

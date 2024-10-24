//import 'dart:html';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/student/GroupTabs/posts.dart';
import 'package:untitled4/student/GroupTabs/tasks.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyGroupHomePage extends StatelessWidget {
late String Taskid;
   late String idgroup;
  late String SID;
  late String cname;
  late String cimg;
  late String groupname;
   int selectedPage=0;
  MyGroupHomePage(String _id,String SID ,String cname, String cimg,String groupname){
    selectedPage=this.selectedPage;
    super.key;
    this.idgroup=_id;
    this.SID=SID;
    this.cname=cname;
    this.cimg=cimg;
    this.groupname=groupname;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MyGroupHomePagesS(this.idgroup,this.SID,this.cname,this.cimg,this.groupname),
      ),
    );
  }
}

class MyGroupHomePagesS extends StatefulWidget {
   late String idgroup;
  late String CID;
  late String cname;
  late String cimg;
  late String groupname;
   int selectedPage=0;
  MyGroupHomePagesS(String _id,String CID ,String cname, String cimg,String groupname){
    selectedPage=this.selectedPage;
    super.key;
    this.idgroup=_id;
    this.CID=CID;
    this.cname=cname;
    this.cimg=cimg;
    this.groupname=groupname;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState(selectedPage);
}

class _MyHomePageState extends State<MyGroupHomePagesS> {
  bool leave =false;
      Map<String, dynamic>  groupinfo={};
  final networkHandler = NetworkHandlerC();
  final networkHandlers= NetworkHandlerS();
  Map<String,dynamic> companyinfo={};
    final TextEditingController confirmid =TextEditingController();
  final TextEditingController reason =TextEditingController();
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
              'ID':widget.CID,
              'img':widget.cname,
              'name':widget.cimg,
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

  int selectedPage;
  //late String IDCompany;
  bool isDataReady=false;
  
  _MyHomePageState(this.selectedPage);
  @override
  void initState() {
  super.initState();
      fetchData().then((_) {
      setState(() {
        isDataReady=true;
         print("from Home"+widget.CID);
      });
      },);
}
Future<void> fetchData() async {
  try {

    groupinfo = await networkHandler.getGroupById(widget.idgroup);
    groupinfo.values.forEach((value) {
      print(value);
    });
    isDataReady=true;
  } catch (error) {
    print(error);
  }
}
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: selectedPage,
      length: 2,
      child: leave
      ?Container(
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
                    "images/nogroups.jpeg",
                    fit: BoxFit.cover,
                    width: 500,
                  ),
                )
              ],
            ),
          )
      : isDataReady
      ? NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
     // shrinkWrap: true,
     return <Widget>[
      //slivers: [
        SliverAppBar(
          leading:Tooltip(
                          message: "Leave Group",
                          child : Container(
                            margin: EdgeInsets.all(5),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius:BorderRadius.all(Radius.circular(60))),
                          child: IconButton(
                          onPressed: () {
                            if(groupinfo['phase']=="Assessment" || groupinfo['phase']=="selection" ){
                                showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Leave Group Confirmation',
                                            style: GoogleFonts.salsa(
                                              textStyle: TextStyle(
                                                fontSize: 21,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff003262),
                                              ),
                                            ),
                                          ),
                                          content: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets.only(
                                                          left: 10, top: 10
                                                        ),
                                                        height: 70,
                                                        width: 70,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(40.0),
                                                            border: Border.all(
                                                                //    color: Color(0xff003566),
                                                                style: BorderStyle.solid,
                                                                color: Colors.grey.shade400),
                                                            image:  DecorationImage(
                                                                image: NetworkImage("http://localhost:5000/" + widget.cimg),
                                                                fit: BoxFit.cover)),
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          widget.cname,
                                                          style: TextStyle(
                                                            fontSize: 25,
                                                            color: Color(0xff003566),
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                        padding: EdgeInsets.only(left: 10),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(height: 20,),
                                                  SizedBox(height: 10,),
                                                  Text(
                                                      'Please enter the your ID:',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color.fromARGB(255, 1, 30, 92),
                                                      ),
                                                    ),
                                                  Container(

                                                      child: TextFormField(
                                                        controller: confirmid,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                        decoration: InputDecoration(
                                                          // border: InputBorder.none,
                                                          //focusedBorder: InputBorder.none,
                                                          // Optionally, you can customize the appearance of the text field
                                                          contentPadding: EdgeInsets.symmetric(
                                                              horizontal: 16.0),
                                                          hintText: "Confirm your ID"
                                                        ),
                                                        enabled:
                                                            true, 
                                                        onChanged: (value) {
                                                          confirmid.text=value;
                                                        },
                                                        validator: (value) {
                                                          if(value != widget.CID){
                                                            return "Incorrect ID";
                                                          }
                                                        },
                                                      ),

                                                  ),
 /*                                                 SizedBox(height: 10,),
                                                  Text(
                                                      'Please enter the your password',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color.fromARGB(255, 1, 30, 92),
                                                      ),
                                                    ),
                                                  Container(

                                                      child: TextFormField(
                                                        controller: confirmid,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                        decoration: InputDecoration(
                                                          // border: InputBorder.none,
                                                          //focusedBorder: InputBorder.none,
                                                          // Optionally, you can customize the appearance of the text field
                                                          contentPadding: EdgeInsets.symmetric(
                                                              horizontal: 16.0),
                                                          hintText: "Confirm your Password"
                                                        ),
                                                        enabled:
                                                            true, 
                                                        onChanged: (value) {
                                                          confirmid.text=value;
                                                        },
                                                      ),

                                                  ),
*/
                                                  SizedBox(height: 30,),

                                              ],
                                            ),
                                           actions: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all<Color>(
                                                  Color(0xff003566)), // Change color here
                                            ),
                                            onPressed: () async {
                                               DocumentSnapshot snap = await FirebaseFirestore.instance.collection("UserTokens").doc(groupinfo['cid']).get();
                                            if (snap.exists) {
  // Check if the 'token' field exists in the document
                                           if (snap.data() != null && snap['token']!= null) {
                                            String token = snap['token'];
                                            print(token);
                                            //if(widget.groupinfo['phase']=="Assessment"){
                                              sendPushMessage(token, "${widget.cname} leave ${groupinfo['groupname']}", "TrainLink" ,'group');
                                                Map<String,dynamic> newtemp={
                                                      'title':'TrainLink',
                                                      'body':"${widget.cname} leave ${groupinfo['groupname']}",
                                                      'time':FieldValue.serverTimestamp(),
                                                      'ID':widget.CID ,
                                                      'img':widget.cimg ?? "",
                                                      'name':widget.cname?? "",
                                                      'type':'group' ,
                                                      'eid':groupinfo['_id'] ?? "",
                                                    };
                                              messageId = getRandomString(10) ;
                                              AddMessage(groupinfo['cid'], messageId, newtemp);
                                              //}
                                              } else {
                                                print("The 'token' field does not exist in the document.");
                                              }
                                            } else {
                                              print("Document does not exist with the specified ID.");
                                            }
                                              setState(()  {
                                               groupinfo['membersStudentId'].remove(widget.CID);
                                                for(int j=0;j<groupinfo['membersStudent'].length;j++){
                                                  if(groupinfo['membersStudent'][j]['RegNum']==widget.CID){
                                                    groupinfo['membersStudent'].remove(groupinfo['membersStudent'][j]);

                                                    }
                                                }
                                                networkHandler.updatemembersStudentGroup(groupinfo['_id'],groupinfo['membersStudentId']);
                                                networkHandler.updatemembersStudentGroupmaps(groupinfo['_id'], groupinfo['membersStudent']);
                                                networkHandlers.updategroupidstud(widget.CID, "", true);
                                                networkHandlers.updatepostidstud(widget.CID, "", false);
                                               // widget.onDataRefresh();
                                                });
                                                setState(() {
                                                  leave=true;
                                                });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Leave',
                                              style: TextStyle(color: Colors.amber),
                                            ),
                                          ),
                                    ],
                                        );
                                      },
                                    );
                          /*showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return  MyDialog(widget.cname,widget.cimg); // Your custom dialog content goes here
                          },
                        );*/
                            }
                          },
                            icon: (groupinfo['phase']=="Assessment" || groupinfo['phase']=="selection" )
                                ? Icon(
                                    Icons.logout_rounded,
                                    size: 20,
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                  )
                                : Icon(
                                    size: 30,
                                    Icons.logout_rounded,
                                    color: Color.fromARGB(255, 104, 104, 104),
                                  ),
                          ),),
                        ),
                backgroundColor: Colors.white,
                expandedHeight: 300.0, 
         
          //Tab Bar
          
               // expandedHeight: 470.0, 
            flexibleSpace: FlexibleSpaceBar(
                 background:Column(children: [ 
               // Stack(children: [

                Container(
                 width: 411,
                 height: 150,
                  decoration: BoxDecoration(
                  /*: [
                  /*  BoxShadow(
                        blurStyle: BlurStyle.outer,
                        blurRadius: 3,
                        color: Colors.blueGrey)*/
                  ],*/
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
                          child:IconButton(onPressed:() {
                          }, 
                        icon: groupinfo['phase']=="selection"
                        ? Icon(Icons.circle,color: Colors.amber)
                        : Icon(Icons.circle_outlined,color: Colors.amber,),
                          ),),
                        Tooltip(
                        message: "Training Phase",                          
                          child: IconButton(
                            onPressed:() {
                            },
                        icon: groupinfo['phase']=="starting"
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
                        //   Navigator.push( context,  MaterialPageRoute(builder: (context) => showMem( groupinfo['_id'],widget.CID,widget.cname,widget.cimg,groupinfo['membersStudentId'])));
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

                 ],
                 ),  
                ),

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
      

      ];
      
  },
  body:TabBarView(
          children: <Widget>[
            groupHomePage(widget.idgroup),
            ttList(widget.idgroup,widget.CID,widget.cname,widget.cimg),
           // groupHomePage(widget.idgroup,widget.CID,widget.cname,widget.cimg),
            //TaskssList(widget.idgroup,widget.CID,widget.cname,widget.cimg,widget.groupname),
          ],
        ),
  )
      :Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }
}
class MyDialog extends StatelessWidget {
  //bool submit=false;
  late String CImg;
  late String name;
  MyDialog(this.name,this.CImg);
  final TextEditingController confirmid =TextEditingController();
  final TextEditingController reason =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 380,
        height: 390,
        // decoration: BoxDecoration( borderRadius: BorderRadius.circular(20),color: const Color.fromARGB(255, 255, 255, 255)),
        //padding: EdgeInsets.all(16.0),
        child:AlertDialog(
           backgroundColor: Colors.white,
         title: Text(

              'Leave Group',
              //textAlign:,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 1, 30, 92),
              ),
            ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10, top: 10
                    ),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(40.0),
                        border: Border.all(
                            //    color: Color(0xff003566),
                            style: BorderStyle.solid,
                            color: Colors.grey.shade400),
                        image:  DecorationImage(
                            image: NetworkImage("http://localhost:5000/" + CImg),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 25,
                        color: Color(0xff003566),
                          fontWeight: FontWeight.bold),
                    ),
                    padding: EdgeInsets.only(left: 10),
                  ),
                ],
              ),
              Container(height: 20,),
              /*Container(

              child: TextFormField(  
                                                
                    maxLines: 5,
                    minLines: 5,
                    controller: reason,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      // focusedBorder: In,
                      // Optionally, you can customize the appearance of the text field
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0),
                      hintText: "Please Write why you freeze relationship with NNU"
                    ),
                    enabled: true, // Set to false to disable the TextField
                    onChanged: (value) {
                      reason.text=value;
                    },
                  ),),*/

              SizedBox(height: 10,),
              Text(
                  'Please enter the your ID:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 30, 92),
                  ),
                ),
              Container(

                  child: TextFormField(
                    controller: confirmid,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      //focusedBorder: InputBorder.none,
                      // Optionally, you can customize the appearance of the text field
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0),
                      hintText: "Confirm your ID"
                    ),
                    enabled:
                        true, 
                    onChanged: (value) {
                      confirmid.text=value;
                    },
                  ),

              ),
               SizedBox(height: 10,),
              Text(
                  'Please enter the your password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 30, 92),
                  ),
                ),
              Container(

                  child: TextFormField(
                    controller: confirmid,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      //focusedBorder: InputBorder.none,
                      // Optionally, you can customize the appearance of the text field
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0),
                      hintText: "Confirm your Password"
                    ),
                    enabled:
                        true, 
                    onChanged: (value) {
                      confirmid.text=value;
                    },
                  ),

              ),

              SizedBox(height: 30,),

          ],
        ),
        actions: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xff003566)), // Change color here
                ),
                onPressed: () {
                  // Close the dialog when the button is clicked
                  
                  
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Leave',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
        ],
        ),
      //),
    );
  }
}
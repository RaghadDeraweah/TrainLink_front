//
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
//import 'package:open_file/open_file.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'dart:convert' ;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
String? name = "Flutter Fall23";
String? members;


class showStu extends StatefulWidget {
  final VoidCallback onDataRefresh;
  late String postid;
  late String CID;
  late String cname;
  late String cimg;
  late List<dynamic> studentsid;

  showStu({required this.postid,required this.CID,required this.cname,required this.cimg,required this.studentsid,required this.onDataRefresh});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<showStu> {
  bool isDataReady=false;
  List<Map<String,dynamic>> stuinfo=[];
  final networkHandlerC = NetworkHandlerC();
      final networkHandler = NetworkHandlerS();
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



Future<Map<String, dynamic>> fetchStudent(String regNum) async {
  //final response = await http.get(Uri.parse("http://localhost:5000/student/$regNum"));
   Map<String, dynamic> jsonData={};


      final response = await http.get(Uri.parse("http://localhost:5000/student/$regNum"));

    if (response.statusCode == 200) {
      // Parse the JSON response
      jsonData = jsonDecode(response.body);
      String fname = jsonData['fname'];
      String lname = jsonData['lname'];
      String cv = jsonData['cv'];
      // Add other properties as needed

      // Now you can use the retrieved data in your Flutter app
      print('Student Name: $fname $lname');
      print('Student cv: $cv');
      return jsonData;
      // Access the student data from the JSON

    } else if (response.statusCode == 404) {
      print('Student not found');
      return jsonData;
    } else {
      print('Failed to load student. Status Code: ${response.statusCode}');
      return jsonData;
    }

}

Future<void> fetchData() async {
  try {
    for (String sid in widget.studentsid) {
    print(sid);
    var sinfo = await fetchStudent(sid);
    Map<String, dynamic> temp = {
      "id_status": false,
      "RegNum": sinfo['RegNum'],
      "sname": sinfo['fname'] + " " + sinfo['lname'],
      "img": sinfo['img'],
      "cv":sinfo['cv'],

    };
    stuinfo.add(temp);
  }

    isDataReady=true;
  } catch (error) {
    print(error);
  }
}
  void initState() {
  super.initState();
  fetchData().then((_) {
    setState(() {
      isDataReady = true; // Set the flag to true when data is fetched
    });
    });
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
              'img':widget.cimg,
              'name':widget.cname,
              'type':type,
              'eid':widget.postid
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
          elevation: 0,
          leading: IconButton(
            color: const Color(0xffff003566),
            icon: const Icon(Icons.arrow_back),
            iconSize: 30,
            onPressed: () {
              widget.onDataRefresh();
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Requests",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
      body: isDataReady
      ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 255, 255, 255),
                  child: ListView.builder(
                      itemCount: widget.studentsid.length,
                      itemBuilder: (context, index) => ListTile(
                            title: Container(
                              height: 70,
                              width: 411,
                            padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 64, 32, 139),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child : Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(

                                    margin: EdgeInsets.only(right: 20),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        image: DecorationImage(
                                            image:NetworkImage("http://localhost:5000/"+stuinfo[index]['img']),
                                            fit: BoxFit.cover))),
                                            ),
                                Expanded(
                                flex: 2,
                                child: 
                                Container(
                                child:Text(
                                  stuinfo[index]['sname'],
                                  style: TextStyle(color: Colors.white),
                                ),),
                                ),
                             
                                Expanded( 
                                  flex: 2,
                                child:Row(
                                  children: [
                                  
                                  IconButton(onPressed:() async{
                                    print(stuinfo[index]['cv']);
                                    networkHandler.downloadFile("http://localhost:5000/"+stuinfo[index]['cv'], '${stuinfo[index]['RegNum']}.pdf');
                                  }, icon: Icon(
                                Icons.download_for_offline_rounded,
                                color: Color.fromARGB(255, 129, 150, 134),
                                size: 30.0,
                              )),
                                  IconButton(onPressed:() async {
                                    setState(() {
                                    widget.studentsid.remove(stuinfo[index]['RegNum']);
                                    networkHandlerC.updateapllidStuId(widget.postid,widget.studentsid);
                                    networkHandler.updatepostidstud(stuinfo[index]['RegNum'],"",false);
                                    });
                                    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("UserTokens").doc(stuinfo[index]['RegNum']).get();
                                     if (snap.exists) {
                                      if (snap.data() != null && snap['token']!= null) {
                                        String token = snap['token'];
                                    print(token);
                                    sendPushMessage(token, "Your request for ${widget.cname} training refused", "TrainLink" ,'post');
                                    Map<String,dynamic> newtemp={
                                              'title':'TrainLink',
                                              'body':"Your request for ${widget.cname} training refused",
                                              'time':FieldValue.serverTimestamp(),
                                              'ID':widget.CID ?? "",
                                              'img':widget.cimg?? "",
                                              'name':widget.cname?? "",
                                              'type':'post' ,
                                              'eid':widget.postid ?? "",
                                            };
                                      messageId = getRandomString(10) ;
                                      AddMessage(stuinfo[index]['RegNum'], messageId, newtemp);                                        
                                      } else {
                                        print("The 'token' field does not exist in the document.");
                                      }
                                    } else {
                                      print("Document does not exist with the specified ID.");
                                    }
                                    /*String token = snap['token'];
                                    print(token);
                                    sendPushMessage(token, "Your request for ${widget.cname} training refused", "TrainLink" ,'post');
                                    Map<String,dynamic> newtemp={
                                              'title':'TrainLink',
                                              'body':"Your request for ${widget.cname} training refused",
                                              'time':FieldValue.serverTimestamp(),
                                              'ID':widget.CID ?? "",
                                              'img':widget.cimg?? "",
                                              'name':widget.cname?? "",
                                              'type':'post' ,
                                              'eid':widget.postid ?? "",
                                            };
                                      messageId = getRandomString(10) ;
                                      AddMessage(stuinfo[index]['RegNum'], messageId, newtemp);*/  
                                  }, icon: Icon(
                                Icons.remove_circle,
                                color: Color.fromARGB(255, 214, 91, 91),
                                size: 30.0,
                              ))
                                ],
                                ),
                                ),

                            ],),
                          ),
                       ),
                          
                ))
                :Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }
  
}
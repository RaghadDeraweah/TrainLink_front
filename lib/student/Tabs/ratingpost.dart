// ignore: file_names
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/student/companypage.dart';
import 'dart:convert' ;
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

bool s1 = false, s2 = false, s3 = false, s4 = false, s5 = false;

class RatingPost extends StatefulWidget {
   final VoidCallback onDataRefresh;
  late Map<String,dynamic> stu;
  late List<String> frameworks;
  late List<String> groupsid;
    late String ID;
 /* var name;
  var photo;*/
  
  RatingPost(this.stu,this.ID,this.frameworks,this.groupsid, this.onDataRefresh);

  @override
  // ignore: library_private_types_in_public_api
  _RatingPostState createState() => _RatingPostState(this.stu,this.ID,this.frameworks,this.groupsid);
}

class _RatingPostState extends State<RatingPost> {
  late Map<String,dynamic> stu;
  late String ID;
  Map<String,dynamic> companyinfo={};
  late List<String> groupsid;
  final networkHandlerC = NetworkHandlerC();
  final networkHandler = NetworkHandlerS();
  TextEditingController des=TextEditingController();
  late int rate;
  String dropdownValue = "Framework";
  String gid = "";
  late List<String> frameworks;
 /* String namee;
  String photoo;*/
  _RatingPostState(this.stu,this.ID,this.frameworks,this.groupsid);
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    frameworks.add("Framework");
  }
  void sendPushMessage(String token, String body , String title ,String type ,String postid )async{
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
              'ID':widget.stu['RegNum'],
              'img':widget.stu['img'],
              'name':widget.stu['fname']+" "+widget.stu['lname'],
              'type':type,
              'eid':postid
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
              widget.onDataRefresh();
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Ratings and reviews",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: Container(
          height: 780,
          width: 411.0,
          //color: Colors.amber,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(children: [
                  Container(
                    width: 411,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              border: Border.all(
                                  //    color: Color(0xff003566),
                                  style: BorderStyle.solid,
                                  color: Colors.grey.shade400),
                              image: DecorationImage(
                                  image: NetworkImage("http://localhost:5000/"+stu['img']),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            stu['fname']+" "+stu['lname'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    //   color: Colors.blue,
                  ),
                  Container(
                    width: 411,
                    height: 40,
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Ratings and reviews is available for you.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Container(
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              s1 = true;
                              s2 = false;
                              s3 = false;
                              s4 = false;
                              s5 = false;
                              rate=1;
                            });
                          },
                          icon: (s1)
                              ? Icon(
                                  Icons.star,
                                  //color: const Color.fromARGB(255, 12, 24, 87),
                                  color: Color(0xffffc300),
                                )
                              : Icon(Icons.star_border),
                          iconSize: 35,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              s1 = true;
                              s2 = true;
                              s3 = false;
                              s4 = false;
                              s5 = false;
                              rate=2;
                            });
                          },
                          icon: (s2)
                              ? Icon(
                                  Icons.star,
                                  color: Color(0xffffc300),
                                )
                              : Icon(Icons.star_border),
                          iconSize: 35,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              s1 = true;
                              s2 = true;
                              s3 = true;
                              s4 = false;
                              s5 = false;
                              rate=3;
                            });
                          },
                          icon: (s3)
                              ? Icon(
                                  Icons.star,
                                  color: Color(0xffffc300),
                                )
                              : Icon(Icons.star_border),
                          iconSize: 35,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              s1 = true;
                              s2 = true;
                              s3 = true;
                              s4 = true;
                              s5 = false;
                              rate=4;
                            });
                          },
                          icon: (s4)
                              ? Icon(
                                  Icons.star,
                                  color: Color(0xffffc300),
                                )
                              : Icon(Icons.star_border),
                          iconSize: 35,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              s1 = true;
                              s2 = true;
                              s3 = true;
                              s4 = true;
                              s5 = true;
                              rate=5;
                            });
                          },
                          icon: (s5)
                              ? Icon(
                                  Icons.star,
                                  color: Color(0xffffc300),
                                )
                              : Icon(Icons.star_border),
                          iconSize: 35,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 411,
                    height: 700,

                    //  color: Colors.green,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                controller: des,
                                maxLength: 500,
                                keyboardType: TextInputType.text,
                                maxLines: 5,
                                minLines: 1,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(width: 1.7)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 1.7,
                                            color: Color(0xffffc300))),
                                    hintText:
                                        "Describe your experience (optional) "),
                                onChanged: (value) {
                                  des.text=value;
                                },                              
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all( width: 1.7,
                                           // color: Color.fromARGB(255, 29, 29, 29)
                                           ),
                                 borderRadius: BorderRadius.circular(10),
                              ),
                              width: 395,
                              padding: EdgeInsets.only(top:2,bottom: 2,left: 5),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                autofocus: true,
                                dropdownColor: Colors.amber,
                            menuMaxHeight: 200,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16),
                            alignment: Alignment.center,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                                for(int x=0;x<frameworks.length;x++){
                                  if(frameworks[x]==newValue){
                                    gid=groupsid[x];
                                  }
                                }
                              

                              });
                            },
                            items: frameworks.map((String name){
                          return DropdownMenuItem(
                          child: Text(name),
                          value: name,
 
                          );

                         }).toList(),
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_drop_down_rounded),
                          ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 130,
                                  height: 50,
                                  margin: EdgeInsets.only(
                                      right: 20, bottom: 100, top: 20),
                                  // color: const Color.fromARGB(255, 210, 165, 218),
                                  child: MaterialButton(
                                    child: Text("POST"),
                                    color: Color(0xffffc300),
                                    textColor: Colors.black,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    onPressed: () async{
                                      for(int i=0;i<widget.stu['finishedGroups'].length;i++){
                                        if(dropdownValue==widget.stu['finishedGroups'][i]['framework']){
                                          widget.stu['finishedGroups'][i]['isRated']=true;
                                        }
                                      }
                                      Map<String,dynamic> ratingvar={
                                        'groupid':gid,
                                        'RegNum':widget.stu['RegNum'],
                                        'name':stu['fname']+" "+stu['lname'],
                                        'img':widget.stu['img'],
                                        'des':des.text,
                                        'framework':dropdownValue,
                                        'rate':rate
                                      };
                                      companyinfo = await networkHandlerC.fetchCompanyData(widget.ID);
                                      companyinfo['rating'].add(ratingvar);
                                      networkHandler.updatefinishedcourses(widget.stu['RegNum'], widget.stu['finishedGroups']);
                                      networkHandlerC.updaterating(ID,  companyinfo['rating']);
                                      DocumentSnapshot snap = await FirebaseFirestore.instance.collection("UserTokens").doc(companyinfo['ID']).get();
                                      //String token = snap['token'];
                                      //print(token);
                                      //sendPushMessage(token, "TrainLink" , "New feedback about your $dropdownValue training from ${widget.stu['fname']+" "+widget.stu['lname']} ",'rate',"");
                                       ////////
                                     
                                     if (snap.exists) {
                                      if (snap.data() != null && snap['token']!= null) {
                                        String token = snap['token'];
                                    print(token);
                                    sendPushMessage(token, "TrainLink" , "New feedback about your $dropdownValue training from ${widget.stu['fname']+" "+widget.stu['lname']} ",'rate',"");
                                    Map<String,dynamic> newtemp={
                                              'title':'TrainLink',
                                              'body':"New feedback about your $dropdownValue training from ${widget.stu['fname']+" "+widget.stu['lname']} ",
                                              'time':FieldValue.serverTimestamp(),
                                              'ID':widget.stu['RegNum'] ?? "",
                                              'img':widget.stu['RegNum']?? "",
                                              'name':widget.stu['fname']+" "+widget.stu['lname']?? "",
                                              'type':'rate' ,
                                              'eid': "",
                                            };
                                      messageId = getRandomString(10) ;
                                      AddMessage(companyinfo['ID'], messageId, newtemp);                                        
                                      } else {
                                        print("The 'token' field does not exist in the document.");
                                      }
                                    } else {
                                      print("Document does not exist with the specified ID.");
                                    }
                                       ///                                               
                                      widget.onDataRefresh();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

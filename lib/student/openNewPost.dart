import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:untitled4/BStudent.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled4/BCompany.dart';
import 'dart:convert' ;
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
class openpost extends StatefulWidget {
  late String postid="";
  
  openpost({required this.postid});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<openpost> {
  bool isDataReady=false;
  final networkHandler = NetworkHandlerS();
  final networkHandlerC = NetworkHandlerC();
  Map<String, dynamic>  studentinfo={};
  Map<String,dynamic> postinfo={};
  List<dynamic> ss=[];
  String Date="";
  String lDate="";
  bool isCliked=false;
  int finishedhours=0;
  String? IDS;
    @override
  void initState() {
      super.initState();
      fetchData().then((_) {
        setState(() {
          isDataReady = true; // Set the flag to true when data is fetched
        });
        });
    }

  Future<void> fetchData() async {
  try {

    IDS = await networkHandler.getid();
    print(IDS);

    studentinfo = await networkHandler.fetchStudentData(IDS!);
    print(studentinfo);

    Map<String,dynamic> tem= await networkHandler.fetchUniStudentData(IDS!);
    finishedhours= int.parse(tem['finishedhours'] );

    postinfo= await networkHandlerC.fetchPostData(widget.postid);
    print(postinfo);
    List<String> sd=postinfo['postDate'].split("T");
    List<String> ld=postinfo['lockDate'].split("T");
    Date=sd[0];
    lDate=ld[0];
    isDataReady=true;
  } catch (error) {
    print(error);
  }
}

  void _showDialog(BuildContext context,String contenttxt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Return the AlertDialog widget
        return AlertDialog(
          icon: Icon(Icons.warning,color: const Color.fromARGB(255, 244, 225, 54),size: 40,),
          //title: Text('Dialog Title'),
          content: Text(contenttxt,style: TextStyle(fontSize: 25),),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
              Navigator.of(context).pop();
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
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
              'ID':IDS,
              'img':studentinfo['img'],
              'name':studentinfo['fname']+" "+studentinfo['lname'],
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
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            color: const Color(0xffff003566),
            icon: const Icon(Icons.arrow_back),
            iconSize: 30,
            onPressed: () {
              //widget.onDataRefresh();
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "new post",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
      body: isDataReady
      ? Card(
         child: Row(
          mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+postinfo['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  postinfo['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  Date+"    "+postinfo['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : postinfo['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(postinfo['_id']);
                               
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(postinfo['_id']);                              
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : postinfo['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                postinfo['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ postinfo['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    postinfo['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }else if(studentinfo['request'] && studentinfo['postid']== postinfo['_id']){
                                                  postinfo['appliedStuId'].remove(studentinfo['RegNum']);
                                                  networkHandlerC.updateapllidStuId(postinfo['_id'],postinfo['appliedStuId']);
                                                  networkHandler.updatepostidstud(studentinfo['RegNum'],"",false);
                                                  setState(() {
                                                  isCliked=true;
                                                });
                                                }else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay for training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && postinfo['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }     
                                                else if(studentinfo['available']==true && postinfo['isUni']==true && studentinfo['universityTraining']==false && finishedhours<120){
                                                  _showDialog(context,'You have not complete the number of hours required to register for university training');
                                                }                                             
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                //isCliked=true;
                                                isDataReady=false;
                                                ss=postinfo['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( postinfo['_id'], ss);
                                                networkHandler.updatepostidstud(studentinfo['RegNum'],postinfo['_id'],true);
                                                DocumentSnapshot snap = await FirebaseFirestore.instance.collection("UserTokens").doc(postinfo['cid']).get();
                                                if (snap.exists) {
                // Check if the 'token' field exists in the document
                                                    if (snap.data() != null && snap['token']!= null) {
                                                      String token = snap['token'];
                                                      print(token);
                                                      sendPushMessage(token,"New request on your training from ${studentinfo['fname']+" "+studentinfo['lname']} ","TrainLink" , 'post',postinfo['_id']);
                                                      Map<String,dynamic> newtemp={
                                                            'title':'TrainLink',
                                                            'body':"New request on your training from ${studentinfo['fname']+" "+studentinfo['lname']} ",
                                                            'time':FieldValue.serverTimestamp(),
                                                            'ID':IDS ?? "",
                                                            'img':studentinfo['img'] ?? "",
                                                            'name':studentinfo['fname']+" "+studentinfo['lname']?? "",
                                                            'type':'group' ,
                                                            'eid': postinfo['_id']?? "",
                                                          };
                                                    messageId = getRandomString(10) ;
                                                    AddMessage(postinfo['cid'], messageId, newtemp);                                        
                                                    } else {
                                                      print("The 'token' field does not exist in the document.");
                                                    }
                                                  } else {
                                                    print("Document does not exist with the specified ID.");
                                                  }
                                                setState(() {
                                                  isCliked=true;
                                                });
                                                }
                                                if(isCliked){
                                                fetchData().then((_) {
                                                        setState(() {
                                                        isDataReady = true;// Set the flag to true when data is fetched
                                                        });
                                                        });                                                  
                                                }

                                              },
                                              iconSize: 25,
                                              icon: studentinfo['request'] || (!studentinfo['request'] && !studentinfo['available'])
                                              ? studentinfo['postid']== postinfo['_id']
                                              ? Icon(Icons.close)
                                              : Icon(Icons.check)
                                              : Icon(Icons.check),
                                              color: studentinfo['request'] || (!studentinfo['request'] && !studentinfo['available'])
                                              ? studentinfo['postid']== postinfo['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                studentinfo['request'] || (!studentinfo['request'] && !studentinfo['available'])
                                                ? studentinfo['postid']== postinfo['_id']
                                                ? "Cancel"
                                                : "Request"
                                                :"Request",
                                                style: TextStyle(
                                              color: studentinfo['request'] || (!studentinfo['request'] && !studentinfo['available'])
                                              ? studentinfo['postid']== postinfo['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postinfo['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postinfo['isUni']
                                                ? postinfo['semester']
                                                :  postinfo['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                lDate,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
      :Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }


}
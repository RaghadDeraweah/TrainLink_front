import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:untitled4/BCompany.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert' ;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
/*class NewTask extends StatelessWidget {
 late String cn ;
  late String img;
  late String id;
  late String groupid="";
late String groupname="";
     NewTask(String Name,String ID,String img,String groupid,String groupname){
    super.key;
    this.cn= Name;
    this.id= ID;
    this.img= img;
    this.groupid=groupid;
    this.groupname=groupname;
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
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "New Task",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: createNewtask(this.cn,this.id,this.img,this.groupid,this.groupname),
      ),
    );
  }
}*/


class NewTask extends StatefulWidget {
final VoidCallback onDataRefresh;
late List<dynamic> studentsid;
 late String cn ;
  late String img;
  late String id;
  late String groupid="";
late String groupname="";
   NewTask({required this.cn,required this.id,required this.img,required this.groupid,required this.groupname, required this.studentsid,required this.onDataRefresh});


  @override
  // ignore: library_private_types_in_public_api
  _MyTaskState createState() => _MyTaskState();
}
class _MyTaskState extends State<NewTask> {

  TextEditingController TaskName = TextEditingController();
    TextEditingController TaskDes = TextEditingController();
  TextEditingController seats = TextEditingController();
  final networkHandler = NetworkHandlerC();

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
              'ID':widget.id,
              'img':widget.img,
              'name':widget.cn,
              'type':type,
              'eid':widget.groupid
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



  DateTime _dateTime = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay(hour: 8, minute: 20);
  void _showTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        _timeOfDay = value!;
      });
    });
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime(2025))
        .then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }
  File? taskpdf;
  String? filePath;
  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        taskpdf = File(result.files.single.path!);
      });
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
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "New Task",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
    body:SingleChildScrollView(
        child: 
            Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
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
                               image:  DecorationImage(
                           // String url="http://localhost:5000/"+img,
                             image: NetworkImage("http://localhost:5000/"+widget.img),
                                        fit: BoxFit.cover)),
                              
                             //image: NetworkImage("http://localhost:5000/"+cimg),
//fit: BoxFit.cover)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child:  Text(
                        widget.cn,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                //   color: Colors.blue,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 900,
                //  color: Colors.green,

                child:  Column(
                      children: [
                        Container(
                        height: 80,
                        child :TextField(
                          controller: TaskName,
                          keyboardType: TextInputType.text,
                          maxLines: 2,
                          decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 31, 12, 160)),
                          //borderRadius: BorderRadius.circular(15), 
                          ),                    
                          fillColor: Colors.white,
                          hintText:" Write Task Title ",
                          focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 31, 12, 160),    ),
                            //borderRadius: BorderRadius.circular(15), 
                            ),
                      ),
                          onChanged: (val){
                            setState(() {
                           TaskName.text =val;
                          });
                          },
                        ),
                        ),
                        Container(height: 10,)  ,
                        /*Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),*/
                        TextField(
                          controller: TaskDes,
                          keyboardType: TextInputType.text,
                          maxLines: 6,
                          /*decoration: InputDecoration(
                          hintText: " Write Task Description "),*/
                          decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 31, 12, 160)),
                          //borderRadius: BorderRadius.circular(15), 
                          ),                    
                          fillColor: Colors.white,
                          hintText:" Write Task Description",
                          focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                            width: 1,
                            color: const Color.fromARGB(255, 12, 50, 82),    ),
                            //borderRadius: BorderRadius.circular(15), 
                            ),
                      ),
                          onChanged: (val){
                            setState(() {
                           TaskDes.text =val;
                          });
                          },
                        ),
                        Container(height: 10,)  ,
                        /*Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),*/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(width: 20,),
                           /* Expanded(
                              child: TextFormField(
                                controller: seats,
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    hintText: "# of Seats",
                                    border: InputBorder.none),
                              onChanged: (value) {
                                setState(() {
                                  seats.text=value;
                                });
                              },
                              ),
                            ),*/
                            Expanded(
                             // width: 100,
                              //height: 50,
                              // color: Color(0xFFFFEB3B),
                              flex: 2,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _showTimePicker();
                                    },
                                    icon: Icon(
                                      Icons.alarm,
                                      color: const Color.fromARGB(255, 12, 50, 82),
                                    ),
                                  ),
                                  Text(
                                    _timeOfDay.format(context).toString(),
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 12, 50, 82),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              //width: 150,
                              //height: 50,
                              //   color: Color(0xFFFFEB3B),
                              flex: 2,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _showDatePicker();
                                    },
                                    icon: Icon(Icons.calendar_month_rounded,color: const Color.fromARGB(255, 12, 50, 82),),
                                  ),
                                  Text(
                                    _dateTime.day.toString() +
                                        "/" +
                                        _dateTime.month.toString() +
                                        "/" +
                                        _dateTime.year.toString(),
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 12, 50, 82),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Container(height: 10,)  ,
                        /*Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),*/
                        Container(
                        alignment: Alignment.bottomCenter,
                        child :ButtonTheme(                      
                        height: 60,
                        minWidth: 390,
                        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: const Color.fromARGB(255, 12, 50, 82)),),
                        child: MaterialButton(
                          elevation: 2,
                        onPressed: () => pickPDF(),
                        child: Text('Pick PDF',style: TextStyle(fontSize: 18),),
                        textColor: const Color.fromARGB(255, 12, 50, 82),
                        color:Color.fromARGB(255, 248, 248, 248),
                      ),),),
                      Container(height: 10,)    ,
                      taskpdf != null
                      ?  Text("File Uploaded !",style: TextStyle(color:Color.fromARGB(255, 12, 12, 12),fontSize: 16,fontWeight: FontWeight.bold),)
                      : Text("Please Upload Task pdf"),
                        Container(height: 30,)    ,
                      Container(
                        height: 50,
                        width: 130,
                         child: MaterialButton(
                                child: Text("POST",style: TextStyle(fontSize: 20),),
                                color: const Color.fromARGB(255, 12, 50, 82),
                                textColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                                onPressed: ()async{
                                  print(widget.id);
                                  print(widget.cn);
                                  print(widget.img);
                                  print(TaskName.text);
                                  print(TaskDes.text);
                                  print(_dateTime.toString());
                                  print(taskpdf!.path);

                                  //List appliedStuId =[];
                                 String result = await networkHandler.addgrouptask(widget.groupid,widget.id, widget.cn,widget.img, TaskName.text , _dateTime.toString(),TaskDes.text);
                                 for(int m=0;m<widget.studentsid.length;m++){
                                  DocumentSnapshot snap = await FirebaseFirestore.instance.collection("UserTokens").doc(widget.studentsid[m]).get();
                                  if (snap.exists) {
      // Check if the 'token' field exists in the document
                                  if (snap.data() != null && snap['token']!= null) {
                                    String token = snap['token'];
                                    print(token);
                                    sendPushMessage(token, "New Task Added please notice Deadline", "TrainLink" ,'group');
                                    Map<String,dynamic> newtemp={
                                                  'title':'TrainLink',
                                                  'body':"New Task Added please notice Deadline",
                                                  'time':FieldValue.serverTimestamp(),
                                                  'ID':widget.id?? "",
                                                  'img':widget.img ?? "",
                                                  'name':widget.cn?? "",
                                                  'type':'group' ,
                                                  'eid':widget.groupid ?? "",
                                                };
                                          messageId = getRandomString(10) ;
                                          AddMessage(widget.studentsid[m], messageId, newtemp);
                                  } else {
                                    print("The 'token' field does not exist in the document.");
                                  }
                                } else {
                                  print("Document does not exist with the specified ID.");
                                }

                              
                            }
                                  if(result.length>5) {
                                     networkHandler.uploadtask(taskpdf!.path,result);
                                     widget.onDataRefresh();
                                     Navigator.of(context).pop(true);
                                     setState(() {
                                                                   
                                      TaskName = TextEditingController(text: "");
                                      TaskDes = TextEditingController(text: "");
                                      taskpdf = null;
                                     });

                                     //Navigator.of(context).pop();
                                  }
                                  //Navigator.push(context,MaterialPageRoute(builder: (context) {return MyHomePage(cn,id,img);}));
                                },
                          ),
                ),    
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                          /*  Container(
                              width: 190,
                              height: 190,
                              padding: EdgeInsets.only(top: 20),
                              margin: EdgeInsets.only(left: 0),
                                child: Column(
                                  children: [
                                   Container(
                                        width: 130,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          boxShadow: [
                                            BoxShadow(
                                                spreadRadius: 0.5,
                                                offset: Offset.fromDirection(
                                                    BorderSide
                                                        .strokeAlignCenter),
                                                color: Colors.blue)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blue,
                                        ),
                                        //padding: EdgeInsets.all(10),
                                        child: IconButton(
                                          onPressed: () {
                                            pickPDF();
                                          },
                                          icon: Icon(
                                            Icons.file_copy_outlined,
                                            color: Colors.white,
                                          ),
                                        )
                                        ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    /*taskpdf != null
                                        ? Container(
                                            child: Text("File Uploaded !"),
                                            width: 80,
                                            height: 80,
                                          )
                                        : Text("Please Upload Task pdf"),*/
                                  ],
                                ),
                              
                              //  color: Colors.green,
                            ),*/
                            Container(
                              width: 130,
                              height: 50,
                              margin: EdgeInsets.only(right: 30, bottom: 100),
                              // color: const Color.fromARGB(255, 210, 165, 218),
                              child: MaterialButton(
                                child: Text("POST"),
                                color: Colors.blue,
                                textColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                onPressed: () async{
                                  print(widget.id);
                                  print(widget.cn);
                                  print(widget.img);
                                  print(TaskName.text);

                                  //List appliedStuId =[];
                               /*   String result = await networkHandler.addgrouppost(widget.groupid,widget.id, widget.cn,widget.img, TaskName.text);
                                  if(result.length>5) {
                                    networkHandler.patchImagegrouppost(taskpdf!.path.toString(), result);
                                  }*/
                                  //Navigator.push(context,MaterialPageRoute(builder: (context) {return MyHomePage(cn,id,img);}));
                                },
                              ),
                            ),
                         
                          ],
                        ),*/
                      ],
                    ),
                  
                
              ),
            ]),
          
        
     // ),
    )
    );
  }

}

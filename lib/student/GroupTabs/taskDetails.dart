import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:untitled4/BCompany.dart';
import 'package:file_picker/file_picker.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/student/GroupTabs/tasks.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

/*class TasDetails extends StatelessWidget {
late String Taskid;
late String SID;
late String SName;
late String SImg;
late String groupid="";
late String loackdate;
late String StatusOfSub;
late List<dynamic> stu;
//late List<dynamic> SubmitedStuId=[];
     TasDetails(String Taskid,String groupid,String loackdate, String SID,String SName, String SImg, String StatusOfSub,List<dynamic> stu){
    super.key;
    this.Taskid= Taskid;
    this.groupid=groupid;
    this.loackdate=  loackdate;
    this.SID=SID;
    this.SName=SName;
    this.SImg=SImg;
    this.StatusOfSub=StatusOfSub;
    this.stu=stu;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
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
            "Task Details",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: taskdetailsveiw(this.Taskid,this.groupid,this.loackdate,this.SID,this.SName,this.SImg,this.StatusOfSub,this.stu),
      ),
    );
  }
}*/
class TasDetails extends StatefulWidget {
late String Taskid;
late String groupid="";
late String loackdate;
late String SID;
late String SName;
late String SImg;
late String StatusOfSub;
late List<dynamic> stu=[];
   TasDetails(String Taskid,String groupid,String loackdate,String SID,String SName,String SImg,String StatusOfSub,List<dynamic> stu){
    super.key;
    this.Taskid= Taskid;
    this.groupid=groupid;
    this.loackdate=loackdate;
    this.SID=SID;
    this.SName=SName;
    this.SImg=SImg;
    this.StatusOfSub=StatusOfSub;
    this.stu=stu;
  }

  @override
  // ignore: library_private_types_in_public_api
  _MyTaskState createState() => _MyTaskState();
}
class _MyTaskState extends State<TasDetails> {
  bool isDataReady=false;
  TextEditingController _urlController = TextEditingController();
                    
  TextEditingController _notes = TextEditingController();
  final networkHandlerC = NetworkHandlerC();
 final networkHandler = NetworkHandlerS();
 Map<String, dynamic> stuInfo ={};
  Map<String,dynamic> task={};
  Map<String,dynamic> submissionDetails={};
  List<Map<String,dynamic>> submissions=[];
  List<Map<String,dynamic>> finalsub=[];
  void initState() {
  super.initState();
  fetchData().then((_) {
    setState(() {
      isDataReady = true; 
      // Set the flag to true when data is fetched
      if(widget.StatusOfSub=="Done"){
      _urlController.text=submissionDetails['taskLink'];}
    });
    });
}
Future<Map<String, dynamic>> fetchStudent(String regNum) async {
  //final response = await http.get(Uri.parse("http://localhost:5000/student/$regNum"));
   Map<String, dynamic> jsonData={};
  print("inside Student info");
  print(regNum);

      final response = await http.get(Uri.parse("http://localhost:5000/student/$regNum"));

    if (response.statusCode == 200) {
      // Parse the JSON response
      jsonData = convert.jsonDecode(response.body);
      String fname = jsonData['fname'];
      String lname = jsonData['lname'];
      // Add other properties as needed

      // Now you can use the retrieved data in your Flutter app
      print('Student Name: $fname $lname');
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

    print("///////////////////////////////////////////////////////////////////");
    task = await networkHandlerC.fetchTaskData(widget.groupid,widget.Taskid);
    task.values.forEach((value) {
      print(value);
    });
   // if(widget.StatusOfSub=="Done"){
    submissions =  await networkHandlerC.gettasksubmission(widget.groupid,widget.Taskid);
    print(submissions);
    for(var map in submissions){
      map.forEach((key, value) {
        if(key=="StuId" && value==widget.SID){
          setState(() {
           submissionDetails=map;           
          });
        }
      });
    }
    //}
    
    var sinfo = await fetchStudent(widget.SID);
    Map<String, dynamic> temp = {
      "RegNum": sinfo['RegNum'],
      "sname": sinfo['fname'] + " " + sinfo['lname'],
      "img": sinfo['img'],
   //   "taskLink": submissions[i]['taskLink'],

    };
    stuInfo=temp;
    isDataReady=true;
  } catch (error) {
    print(error);
  }
}
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(

      body: isDataReady
      ? CustomScrollView(
        shrinkWrap: true,
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: MediaQuery.of(context).size.height,
                // Set the height you want for the flexible space
                flexibleSpace: FlexibleSpaceBar(
                  background:Column(children: [
                  taskVeiw(task['_id'],widget.StatusOfSub,task['TaskName'],widget.loackdate,task['submitedStuId'].length.toString(),task['TaskDes'],task['taskpdf'],context),
                  Container(height: 15,),
                  Container(
                        margin:EdgeInsets.fromLTRB(2, 7, 2, 5),
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                     width: MediaQuery.of(context).size.width,
                     decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: ui.Color.fromARGB(255, 27, 85, 124)),
                      borderRadius: BorderRadius.circular(10),
                      
                     ),
                    child: widget.StatusOfSub=="Done" 
                   ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Container(child: Text("Your Submission ",style: TextStyle(fontSize: 16,color:ui.Color.fromARGB(255, 27, 85, 124),fontWeight: FontWeight.bold ),),),
                      
                    Row(children: [
                    Container(
                    margin:EdgeInsets.only(top: 10,left: 10, right: 20,bottom: 20),
                    padding: EdgeInsets.all(10),
                  // margin: EdgeInsets.only(right: 20),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(color: ui.Color.fromARGB(255, 27, 85, 124)),
                        image: DecorationImage(
                            image:NetworkImage("http://localhost:5000/"+widget.SImg),
                            fit: BoxFit.cover
                            )
                      )
                    ),
                  Container(width: 2,),
                  Container(
                  alignment: Alignment.topRight,
                    child: Text(widget.SName,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  ),
                    ],),
                  Container(width: 10,),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(10),                   
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ui.Color.fromARGB(255, 27, 85, 124) ),
                    ),
                    child: Text(submissionDetails['taskLink'],style: TextStyle(color: const ui.Color.fromARGB(255, 58, 58, 58),fontSize: 16),),
                  ),
                  Container(height: 10,),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ui.Color.fromARGB(255, 27, 85, 124) ),
                    ),
                    child: Text("Note",style: TextStyle(color: const ui.Color.fromARGB(255, 58, 58, 58),fontSize: 16),),
                  ),
                Container(height: 20,)
                  ],)
                  : Column(children: [
                    Row(children: [
                    Container(
                    margin:EdgeInsets.only(top: 10,left: 10, right: 20,bottom: 20),
                    padding: EdgeInsets.all(10),
                  // margin: EdgeInsets.only(right: 20),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(color: ui.Color.fromARGB(255, 27, 85, 124)),
                        image: DecorationImage(
                            image:NetworkImage("http://localhost:5000/"+widget.SImg),
                            fit: BoxFit.cover
                            )
                      )
                    ),
                  Container(width: 10,),
                  Container(
                  alignment: Alignment.topRight,
                    child: Text(widget.SName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  ),
                    ],),
                  Container(width: 10,),
                  TextFormField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    labelText: 'Enter URL',
                   // hintText: "Enter Your GitHub Repositry Link",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                  onSaved: (val){
                    setState(() {
                     _urlController.text =val!; 
                    });
                      },
                ),
                  Container(height: 10,),
                  TextFormField(
                  controller: _notes,
                  decoration: InputDecoration(
                    //labelText: 'Enter URL',
                    hintText: "Note",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.url,
                  onSaved: (val){
                    setState(() {
                     _notes.text =val!; 
                    });
                      },
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.all(5),
                  child: ButtonTheme(
                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(3)),
                    
                    child: MaterialButton(onPressed: () async {
                     String res =await networkHandlerC.addaskSub(widget.groupid, widget.Taskid,widget.SID ,_urlController.text , _notes.text);
                    setState(() {
                      widget.stu.add(widget.SID);
                    });
                    if(res.length >5){
                      networkHandlerC.updatesubmitedStuId(widget.Taskid,widget.stu);
                       Navigator.of(context).pop();
                      // Navigator.popUntil(context, ttList(widget.groupid,widget.SID,widget.SName,widget.SImg) as RoutePredicate);
                     // Navigator.of(context).pushReplacement(
                      //MaterialPageRoute(builder: (context) => ttList(widget.groupid,widget.SID,widget.SName,widget.SImg)));
                    }
                  },
                  color: ui.Color.fromARGB(255, 27, 85, 124),
                  child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 18),),
                  )),
                ),
                Container(height: 20,),
                  ],)
                  ),
                ],),
                
                ),
                ),
                ],
                )
      : Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
                );
  }
Widget taskVeiw(String ID,String type,String taskname,String lockdate,String subnum,String Des,String taskpdf,context){
  return Card(
    margin:EdgeInsets.fromLTRB(2, 7, 2, 5),
    color: ui.Color.fromARGB(255, 173, 189, 219),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
  ),
  elevation: 5,
  child : Container(
   // margin: EdgeInsets.all(5),
    padding: EdgeInsets.fromLTRB(8, 0, 8, 5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
      Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:  ui.Color.fromARGB(255, 102, 149, 219),
            ),
            margin: EdgeInsets.only(top: 2,left: 15),
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            
            child: Text(
              type,
              style: TextStyle(
                color: ui.Color.fromARGB(237, 30, 64, 95),
                backgroundColor:  ui.Color.fromARGB(255, 102, 149, 219), 
                fontSize: 12,
                ),

              ),
            ),
          Container(width: 250,),
          Container(
            margin: EdgeInsets.only(top: 8),
            //margin: EdgeInsets.only(top: 3),
          child: IconButton(onPressed:() {
            
          }, 
          alignment: Alignment.topRight,

          icon: Icon(Icons.view_list_rounded)
          ),),
        ],
      ),
       //Container(height: 5,),
      Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      alignment: Alignment.topLeft,
      child: Text(
        taskname,
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: ui.Color.fromARGB(237, 0, 0, 0),
          backgroundColor: ui.Color.fromARGB(255, 173, 189, 219), //rgb(255,246,237)
          ),

        ),
      ),
       Container(height: 10,),
       Container(
         padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
       child: Row(
        
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child:
          
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "Submissions Count",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  
                ),
                
              ),
               Container(height: 10,),
               Row(

                children: [
                  Icon(Icons.people),
                  Text(
                "  "+subnum,
                style: TextStyle(
                  fontSize: 18,
                  color: const ui.Color.fromARGB(255, 0, 0, 0),
                  
                ),
               ),
                ],),

            ],
          ),
          ),
          Expanded(
            flex: 1,
            child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                "Deadline",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  
                ),
                
              ),
              Container(height: 5,),
               Row(
                children: [
                  Icon(Icons.date_range),
                  Text(
                " "+lockdate,
                style: TextStyle(
                  fontSize: 18,
                  color: const ui.Color.fromARGB(255, 0, 0, 0),
                  
                ),
               ),
                ],

              ),

            ],
          ),
          ),
        ],
      ),
      ),
     Container(height: 10,),
      Divider(thickness: 0.3,color: ui.Color.fromARGB(157, 121, 100, 72) ),
      Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      alignment: Alignment.topLeft,
      child: Text(
        "Description",
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: ui.Color.fromARGB(237, 0, 0, 0),
          backgroundColor: ui.Color.fromARGB(255, 173, 189, 219), //rgb(255,246,237)
          ),

        ),),
      Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      alignment: Alignment.topLeft,
      child: Text(
        Des,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w300,
          color: ui.Color.fromARGB(237, 0, 0, 0),
          backgroundColor: ui.Color.fromARGB(255, 173, 189, 219), //rgb(255,246,237)
          ),

        ),
      ),    
      Divider(thickness: 0.3,color: ui.Color.fromARGB(157, 121, 100, 72) ),
      Row(children: [
     Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      alignment: Alignment.topLeft,
      child: Text(
        "Task PDF",
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: ui.Color.fromARGB(237, 0, 0, 0),
          backgroundColor: ui.Color.fromARGB(255, 173, 189, 219), //rgb(255,246,237)
          ),

        ),),
      Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
       alignment: Alignment.topLeft,
        child: IconButton(onPressed:() async{
        print(taskpdf);
        networkHandler.downloadFile("http://localhost:5000/"+taskpdf, '${ID}.pdf');
        }, icon: Icon(
        Icons.download_for_offline_rounded,
        color: Color.fromARGB(255, 129, 150, 134),
        size: 30.0,
        )),
      ),],),
    ]
    ),

         ), );
                 

}
}

Widget submissionslist (String img, String fname,  String taskLink){
  return Container(
                              height: 50,
                              width: 350,
                            padding: EdgeInsets.only(left: 10),
                            margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: ui.Color.fromARGB(255, 228, 226, 221),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child : Row(
                             // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(

                                    margin: EdgeInsets.only(right: 20),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                     // color: Colors.amber,
                                        borderRadius: BorderRadius.circular(60),
                                        image: DecorationImage(
                                            image:NetworkImage("http://localhost:5000/"+img),
                                            fit: BoxFit.cover))),
                                Container(
                                  width: 230,
                                  alignment: AlignmentDirectional.centerStart,
                                child:Text(
                                  fname,
                                  style: TextStyle(color: const ui.Color.fromARGB(255, 0, 0, 0),fontSize: 15,fontWeight: FontWeight.bold),
                                ),),
                                /*mater
                                Link(
                                  uri : Uri.parse()
                                ),*/
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(const ui.Color.fromARGB(255, 131, 90, 202)), // Replace with your desired color
                               // fixedSize: MaterialStateProperty.all<Size>(Size(100, 1)),
                                shape: MaterialStateProperty.all<OutlinedBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25.0), // Set your desired border radius
                                        ),
                                      ),
                              ),
                             // style: ButtonStyle(backgroundColor: col),
                          onPressed: () async {
                            String url = taskLink; // Replace with your URL
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Text('Open Link'),
                        ),

                            ],),
                          );
}
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:untitled4/BCompany.dart';
import 'package:file_picker/file_picker.dart';
import 'package:untitled4/BStudent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class TasDetails extends StatelessWidget {
late String Taskid;
late String groupid="";
late String loackdate;
late List<dynamic> SubmitedStuId=[];
     TasDetails(String Taskid,String groupid,String loackdate,List<dynamic> SubmitedStuId){
    super.key;
    this.Taskid= Taskid;
    this.groupid=groupid;
    this.loackdate=  loackdate;
    this.SubmitedStuId=SubmitedStuId;
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
            "Task Details",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: taskdetailsveiw(this.Taskid,this.groupid,this.loackdate,this.SubmitedStuId),
      ),
    );
  }
}
class taskdetailsveiw extends StatefulWidget {
late String Taskid;
late String groupid="";
late String loackdate;
late List<dynamic> SubmitedStuId=[];
   taskdetailsveiw(String Taskid,String groupid,String loackdate,List<dynamic> SubmitedStuId){
    super.key;
    this.Taskid= Taskid;
    this.groupid=groupid;
    this.loackdate=loackdate;
    this.SubmitedStuId=SubmitedStuId;
  }

  @override
  // ignore: library_private_types_in_public_api
  _MyTaskState createState() => _MyTaskState();
}
class _MyTaskState extends State<taskdetailsveiw> {
  bool isDataReady=false;
  final networkHandlerC = NetworkHandlerC();
 final networkHandler = NetworkHandlerS();
 List<Map<String, dynamic>> stuInfo =[];
  Map<String,dynamic> task={};
  List<Map<String,dynamic>> submissions=[];
  List<Map<String,dynamic>> finalsub=[];
  void initState() {
  super.initState();
  fetchData().then((_) {
    setState(() {
      isDataReady = true; // Set the flag to true when data is fetched
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
    
    submissions =  await networkHandlerC.gettasksubmission(widget.groupid,widget.Taskid);
    print(submissions);
    
    for (String sid in widget.SubmitedStuId) {
      int i=0;
    print(sid);
    var sinfo = await fetchStudent(sid);
    Map<String, dynamic> temp = {
      "RegNum": sinfo['RegNum'],
      "sname": sinfo['fname'] + " " + sinfo['lname'],
      "img": sinfo['img'],
      "taskLink": submissions[i]['taskLink'],

    };
    stuInfo.add(temp);
    i++;
    print(stuInfo);
  }
    /*for (var map in submissions) {
      map.forEach((key, value) async{
        if(key=="StuId"){
          print("inside StuId ");
          
        stu = await fetchStudent(value);
        print(stu);
       finalsub.add(stu);
       }
        print('$key: $value');
      });
    }*/


   // dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(companyinfo["BD"]);
   // print(finalsub);
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
                expandedHeight: 370.0, // Set the height you want for the flexible space
                flexibleSpace: FlexibleSpaceBar(
                  background:Column(children: [
                  taskVeiw(task['TaskStatus'],task['TaskName'],widget.loackdate,task['submitedStuId'].length.toString(),task['TaskDes'],context),
                  Container(height: 15,),
                  Container(
                      padding: EdgeInsets.only(left: 10),
                     margin: EdgeInsets.all(5),
                    child: Row(children: [
                    Text(
                      "Submitted ",
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    Container(
                     // width: 20,
                      //height: 20,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      alignment: AlignmentDirectional.center,
                     decoration: BoxDecoration(
                      color: const ui.Color.fromARGB(255, 131, 90, 202),
                    borderRadius: BorderRadius.circular(30),
                      ),
                      
                      child: Text(
                        
                        task['submitedStuId'].length.toString(),
                        style: TextStyle(fontSize: 13,color: ui.Color.fromARGB(255, 255, 255, 255)),
                        //textAlign: TextAlign.,

                      ),
                    )
                    ],)
                  ),
                ],),
                
                ),
                ),
                SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index)  {

                  return submissionslist(stuInfo[index]['img'],stuInfo[index]['sname'],stuInfo[index]['taskLink']) ;     
                  } ,
                  childCount: submissions.length,
                ),
              ),
                ],
                )
      : Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
                );
  }

}
Widget taskVeiw(String type,String taskname,String lockdate,String subnum,String Des,context){
  return Card(
    margin:EdgeInsets.fromLTRB(2, 7, 2, 5),
    color: ui.Color.fromARGB(255, 246, 237, 209),
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
              color:  ui.Color.fromARGB(255, 243, 226, 151),
            ),
            margin: EdgeInsets.only(top: 2,left: 15),
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            
            child: Text(
              type,
              style: TextStyle(
                color: ui.Color.fromARGB(239, 165, 127, 46),
                backgroundColor: ui.Color.fromARGB(255, 243, 226, 151), 
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
          backgroundColor: ui.Color.fromARGB(255, 246, 237, 209), //rgb(255,246,237)
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
          backgroundColor: ui.Color.fromARGB(255, 246, 237, 209), //rgb(255,246,237)
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
          backgroundColor: ui.Color.fromARGB(255, 246, 237, 209), //rgb(255,246,237)
          ),

        ),
      ),    
    ]
    ),

         ), );
                 

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


                            /*  Row(children: [
                                
                                IconButton(onPressed:() async{
                                  networkHandler.downloadFile("http://localhost:5000/"+stuinfo[index]['cv'], '${stuinfo[index]['RegNum']}.pdf');
                                }, icon: Icon(
                              Icons.download_for_offline_rounded,
                              color: Color.fromARGB(255, 129, 150, 134),
                              size: 30.0,
                            )),
                                IconButton(onPressed:() {
                                  setState(() {
                                  widget.studentsid.remove(stuinfo[index]['RegNum']);
                                  networkHandlerC.updateapllidStuId(widget.postid,widget.studentsid);
                                  });

                                }, icon: Icon(
                              Icons.remove_circle,
                              color: Color.fromARGB(255, 214, 91, 91),
                              size: 30.0,
                            ))
                              ],)*/
                           //   ],
                           // ),
                            ],),
                          );
}
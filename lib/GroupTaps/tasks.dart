import 'dart:ui' as ui;

import 'package:flutter/material.dart';
//import 'package:open_file/open_file.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:untitled4/GroupTaps/createnewTask.dart';
import 'package:untitled4/GroupTaps/taskdetailsVeiw.dart';

class TaskssList extends StatefulWidget {
  late String groupid;
  late String CID;
  late String cname;
  late String cimg;
  late String groupname;
  TaskssList(String _id,String CID ,String cname, String cimg,String groupname){
    super.key;
    this.groupid=_id;
    this.CID=CID;
    this.cname=cname;
    this.cimg=cimg;
    this.groupname=groupname;
  }


  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<TaskssList> {
  bool isDataReady=false;
  List<Map<String,dynamic>> tasksinfo=[];
  final networkHandlerC = NetworkHandlerC();
  final networkHandler = NetworkHandlerS();

Future<void> fetchData() async {
  try {

     tasksinfo = await networkHandlerC.getGrouptasks(widget.groupid);
     for (var map in tasksinfo) {
      map.forEach((key, value) {
        print('$key: $value');
      });
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: ui.Color.fromARGB(255, 255, 209, 7),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NewTask(widget.cname,widget.CID,widget.cimg,widget.groupid,widget.groupname)));
            // print("yes");
          },
          child: Icon(
            Icons.add,
            color: ui.Color.fromARGB(255, 102, 95, 0),
          ),
        ),
      body:  Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 255, 255, 255),
                  child: ListView.builder(
                      itemCount: tasksinfo.length,
                      itemBuilder: (context, index) =>
                           // value: widget.studentsid[index]['id_status'],
                            //key: ValueKey("1"),
                       taskVeiw(widget.groupid,tasksinfo[index]['_id'],tasksinfo[index]['TaskStatus'],tasksinfo[index]['TaskName'],tasksinfo[index]['lockDate'],tasksinfo[index]['submitedStuId'],tasksinfo[index]['submitedStuId'].length.toString(),context),
                       
                       
                          
                ),)
              /*  :Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),*/
    );
  }
  
}
Widget taskVeiw(String groupid,String taskid,String type,String taskname,String lockdate,List<dynamic> StuId,String subnum,context){
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
             Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TasDetails(taskid, groupid,lockdate,StuId)));
            //TasDetails
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
      ),),
    ]),

         ), );
                 

}
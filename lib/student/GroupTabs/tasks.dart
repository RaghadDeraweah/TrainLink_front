import 'dart:ui' as ui;

import 'package:flutter/material.dart';
//import 'package:open_file/open_file.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/student/GroupTabs/taskDetails.dart';



class ttList extends StatefulWidget {
  late String groupid;
  late String SID;
  late String SName;
  late String SImg;
  ttList(String _id,String SID ,String SName,String SImg){
    super.key;
    this.groupid=_id;
    this.SID=SID;
    this.SName=SName;
    this.SImg=SImg;

  }


  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<ttList> {
  bool isDataReady1=false;
  List<Map<String,dynamic>> tasksinfo=[];
  List<Map<String,dynamic>> tasksSub=[];
  final networkHandlerC = NetworkHandlerC();
  final networkHandler = NetworkHandlerS();
  bool found=true;
  @override
 void initState() {
  super.initState();
  fetchData().then((_) {
   setState(() {
      isDataReady1 = true; // Set the flag to true when data is fetched
    });
    });
}
Future<void> fetchData() async {
  try {

     tasksinfo = await networkHandlerC.getGrouptasks(widget.groupid);
     for (var map in tasksinfo) {
      map.forEach((key, value) {
        print('$key: $value');
      });
    }
    //tasksSub= await networkHandlerC.gettasksubmissionsStu(widget.groupid,widget.SID);

  } catch (error) {
    print(error);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       /* floatingActionButton: FloatingActionButton(
          backgroundColor: ui.Color.fromARGB(255, 255, 209, 7),
          onPressed: () {
          //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewTask(widget.cname,widget.CID,widget.cimg,widget.groupid,widget.groupname)));
            // print("yes");
          },
          child: Icon(
            Icons.add,
            color: ui.Color.fromARGB(255, 102, 95, 0),
          ),
        ),*/
      body: isDataReady1 
      ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 255, 255, 255),

                child: ListView.builder(
                      itemCount: tasksinfo.length,
                      itemBuilder: (context, index) {
                      for (String sid in tasksinfo[index]['submitedStuId']){
                        if(sid==widget.SID){
                         return taskVeiw(widget.groupid,tasksinfo[index]['_id'],"Done",tasksinfo[index]['TaskName'],tasksinfo[index]['lockDate'],tasksinfo[index]['submitedStuId'],tasksinfo[index]['submitedStuId'].length.toString(),tasksinfo[index]['submitedStuId'],context);
                        }                        
                      }
                      return taskVeiw(widget.groupid,tasksinfo[index]['_id'],"To Do",tasksinfo[index]['TaskName'],tasksinfo[index]['lockDate'],tasksinfo[index]['submitedStuId'],tasksinfo[index]['submitedStuId'].length.toString(),tasksinfo[index]['submitedStuId'],context);
 
                      }                                 
                ),
                )
      :Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }
Widget taskVeiw(String groupid,String taskid,String type,String taskname,String lockdate,List<dynamic> StuId,String subnum,submitedstudents,context){
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
            
            child: 
            Text(
              type,
              style: TextStyle(
                color: ui.Color.fromARGB(237, 22, 49, 75),
                backgroundColor: ui.Color.fromARGB(255, 102, 149, 219), 
                fontSize: 12,
                fontWeight: FontWeight.bold,
                ),

              ),
            ),
          Container(width: 250,),
          Container(
            margin: EdgeInsets.only(top: 8),
            //margin: EdgeInsets.only(top: 3),
          child: IconButton(onPressed:() {
             Navigator.of(context).push(
               MaterialPageRoute(builder: (context) => TasDetails(taskid, groupid,lockdate,widget.SID,widget.SName,widget.SImg,type,submitedstudents)));
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
      child: 
      Text(
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
                  color: const ui.Color.fromARGB(255, 136, 135, 135),
                  
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
                  color: const ui.Color.fromARGB(255, 136, 135, 135),
                  
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
}

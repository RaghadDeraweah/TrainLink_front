//
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:open_file/open_file.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String? name = "Flutter Fall23";
String? members;

class showMem extends StatefulWidget {
  final VoidCallback onDataRefresh;
  late Map<String,dynamic> groupinfo={};
  showMem({required this.groupinfo,required this.onDataRefresh});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<showMem> {
  bool isDataReady=false;

  Map<String,dynamic> companyData={};
  List<Map<String,dynamic>> stuinfo=[];
  List<Map<String,dynamic>> students=[];
  List<Map<String,dynamic>> unistudents=[];
  Map<String,dynamic> post={};
  List<String> stuNames=[];
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
    companyData = await networkHandlerC.fetchCompanyData(widget.groupinfo['cid']);
    print(companyData);
    students= await networkHandler.fetchStudents();
    print(students);
    unistudents= await networkHandler.fetchUniStudents();
    print(unistudents);
    post= await networkHandlerC.fetchPostData(widget.groupinfo['postid']);
    print(post);
    MapEntry<String, bool> uni = MapEntry('isUni',post['isUni']);
    widget.groupinfo.addEntries([uni]);
    print(widget.groupinfo);
    print(students);
    for(int m=0; m< students.length;m++){
      print("inside stu");
      for(int n=0; n<unistudents.length;n++){
        print("inside uni");
        if(students[m]['RegNum']==unistudents[n]['RegNum']){
          print("hhiiiiiiiiiiiiiiiiiiii");
          MapEntry<String, int> h = MapEntry('finishedhours',int.parse(unistudents[n]['finishedhours']));
          students[m].addEntries([h]);
          stuNames.add(students[m]['fname']+" "+students[m]['lname']);
        }
      }
    }
    /*for(var map in students){
      map.forEach((key, value) {
              
        if(key=="fname"){
          setState(() {
            stuNames.add(value+" "+map['lname']);
          });

        }
      });
    } */   
    for (String sid in widget.groupinfo['membersStudentId']) {
    print(sid);
    var sinfo = await fetchStudent(sid);
    Map<String, dynamic> temp = {
      "id_status": false,
      "RegNum": sinfo['RegNum'],
      "sname": sinfo['fname'] + " " + sinfo['lname'],
      "img": sinfo['img'],

    };
    stuinfo.add(temp);
    stuNames.remove(sinfo['fname']+" "+sinfo['lname']);
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
              'ID':widget.groupinfo['cid'],
              'img':companyData['img'],
              'name':companyData['Name'],
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
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xffff003566),
              onPressed: () async{
              setState(() {
                isDataReady=false;
              });
              await showSearch(
                context: context,
                delegate: CustomSearchDelegate(names :stuNames,company :companyData,students :students,groupinfo: widget.groupinfo,
                onDataRefresh1: ()async{
                setState(() {
                  stuNames=[];
                  stuinfo=[];

                });
                fetchData().then((_) {
                  setState(() {
                    isDataReady = true; // Set the flag to true when data is fetched
                  });
                  });
                }),
              );
              },
          child: Icon(
            Icons.person_add,
            color: ui.Color.fromARGB(255, 255, 255, 255),
          ),
        ),
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
            "Members",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff003566)),
          ),
        ),
      body: isDataReady
      ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 255, 255, 255),
               // margin: EdgeInsets.symmetric(horizontal: 30),
              //  padding: EdgeInsets.only(top:5,left: 5,right: 5,bottom: 5),
               // color: Colors.amber,
               // child: Expanded(
                  child: ListView.builder(
                      itemCount: widget.groupinfo['membersStudentId'].length,
                      itemBuilder: (context, index) => ListTile(
                           // value: widget.studentsid[index]['id_status'],
                            //key: ValueKey("1"),
                            title: Container(
                              height: 50,
                              width: 411,
                            padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color: ui.Color.fromARGB(255, 197, 195, 202),
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
                                            image:NetworkImage("http://localhost:5000/"+stuinfo[index]['img']),
                                            fit: BoxFit.cover))),
                                Container(
                                  width: 250,
                                child:Text(
                                  stuinfo[index]['sname'],
                                  style: TextStyle(color: const ui.Color.fromARGB(255, 0, 0, 0),fontSize: 15,fontWeight: FontWeight.bold),
                                ),),
                             

                              Row(children: [
                                
                              /*  IconButton(onPressed:() async{
                                  networkHandler.downloadFile("http://localhost:5000/"+stuinfo[index]['cv'], '${stuinfo[index]['RegNum']}.pdf');
                                }, icon: Icon(
                              Icons.download_for_offline_rounded,
                              color: Color.fromARGB(255, 129, 150, 134),
                              size: 30.0,
                            )),*/
                                IconButton(onPressed:() async{
                                  setState(() {
                                    isDataReady=false;
                                  });
                                     DocumentSnapshot snap = await FirebaseFirestore.instance.collection("UserTokens").doc(stuinfo[index]['RegNum']).get();
                                   if (snap.exists) {
  // Check if the 'token' field exists in the document
                                      if (snap.data() != null && snap['token']!= null) {
                                        String token = snap['token'];
                                        print(token);
                                         if(widget.groupinfo['phase']=="Assessment"){
                                      sendPushMessage(token, "Unfortunately, you did not qualify for the interview phase. We wish you the best of luck in further training", "TrainLink" ,'group');
                                        Map<String,dynamic> newtemp={
                                              'title':'TrainLink',
                                              'body':"Unfortunately, you did not qualify for the interview phase. We wish you the best of luck in further training",
                                              'time':FieldValue.serverTimestamp(),
                                              'ID':widget.groupinfo['cid'] ?? "",
                                              'img':companyData['img'] ?? "",
                                              'name':companyData['Name']?? "",
                                              'type':'group' ,
                                              'eid':widget.groupinfo['_id'] ?? "",
                                            };
                                      messageId = getRandomString(10) ;
                                      AddMessage(stuinfo[index]['RegNum'], messageId, newtemp);
                                      }else if(widget.groupinfo['phase']=="selection"){
                                      sendPushMessage(token, "Unfortunately, you did not qualify for the final phase. We wish you the best of luck in further training", "TrainLink" ,'group');
                                        Map<String,dynamic> newtemp={
                                              'title':'TrainLink',
                                              'body':"Unfortunately, you did not qualify for the final phase. We wish you the best of luck in further training",
                                              'time':FieldValue.serverTimestamp(),
                                              'ID':widget.groupinfo['cid'] ?? "",
                                              'img':companyData['img'] ?? "",
                                              'name':companyData['Name']?? "",
                                              'type':'group' ,
                                              'eid':widget.groupinfo['_id'] ?? "",
                                            };
                                      messageId = getRandomString(10) ;
                                      AddMessage(stuinfo[index]['RegNum'], messageId, newtemp);                                      
                                      }
                                      } else {
                                        print("The 'token' field does not exist in the document.");
                                      }
                                    } else {
                                      print("Document does not exist with the specified ID.");
                                    }
                                  setState(()  {
                                  widget.groupinfo['membersStudentId'].remove(stuinfo[index]['RegNum']);
                                  for(int j=0;j<widget.groupinfo['membersStudent'].length;j++){
                                    if(widget.groupinfo['membersStudent'][j]['RegNum']==stuinfo[index]['RegNum']){
                                      widget.groupinfo['membersStudent'].remove(widget.groupinfo['membersStudent'][j]);

                                      }
                                  }
                                  networkHandlerC.updatemembersStudentGroup(widget.groupinfo['_id'],widget.groupinfo['membersStudentId']);
                                  networkHandlerC.updatemembersStudentGroupmaps(widget.groupinfo['_id'], widget.groupinfo['membersStudent']);
                                  networkHandler.updategroupidstud(stuinfo[index]['RegNum'], "", true);
                                  networkHandler.updatepostidstud(stuinfo[index]['RegNum'], "", false);
                                    setState(() {
                                    stuNames=[];
                                    stuinfo=[];
                                    });
                                    fetchData().then((_) {
                                  setState(() {
                                    isDataReady = true; // Set the flag to true when data is fetched
                                  });
                                  });
                                  widget.onDataRefresh();
                                  });
                                  

                                }, icon: Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                              size: 30.0,
                            ))
                              ],)
                           //   ],
                           // ),
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
class CustomSearchDelegate extends SearchDelegate<String> {
    final VoidCallback onDataRefresh1;
  final networkHandlerC = NetworkHandlerC();
  final networkHandler = NetworkHandlerS();  
  late List<String> names;
  late Map<String ,dynamic> company;
  late Map<String ,dynamic> groupinfo;
  late List<Map<String ,dynamic>> students;
  CustomSearchDelegate({required this.names,required this.company,required this.students,required this.groupinfo, required this.onDataRefresh1});

  // These methods are mandatory you cannot skip them.

  @override
  List<Widget> buildActions(BuildContext context) {
     return [
    IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        query = '';
        // When pressed here the query will be cleared from the search bar.
      },
    ),
  ];
  }

  @override
  Widget buildLeading(BuildContext context) {
        return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: (){
        onDataRefresh1();
        Navigator.of(context).pop();
      } 
        // Exit from the search screen.
    );
  }

  @override
  Widget buildResults(BuildContext context) {
      final List<String> searchResults = names;
      //.where((item) => item.toLowerCase().contains(query.toLowerCase()))
      //.toList();
  return ListView.builder(
    itemCount: searchResults.length,
    itemBuilder: (context, index) {
      return Container(
        height: 50,
        width: 411,
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 204, 204, 204),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 20),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  image: DecorationImage(
                    image: NetworkImage("http://localhost:5000/" + students[index]['img']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                searchResults[index],
                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0),fontSize: 18),
              ),
            ],
          ),
          onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchCompany(companies[index]['ID'],student)));
            // Handle the selected search result.
            //close(context, searchResults[index]);
          },
        ),
      );
    },
  );
  }
  void _showDialog(BuildContext context,String contenttxt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Return the AlertDialog widget
        return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.fromLTRB(80, 360, 80, 270),
          width: 200,
          height: 210,
         decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             Icon(Icons.info,color: const Color.fromARGB(255, 244, 225, 54),size: 40,),
          //title: Text('Dialog Title'),
          //Center(
            //heightFactor: 200,
            //child:
            Text(contenttxt,style: TextStyle(fontSize: 22,)),//),
          
            TextButton(
              onPressed: () {
                // Close the dialog
                //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
              Navigator.of(context).pop();
              },
              child: Text('Ok'),
            ),
          
          ],
          ),

        );
      },
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
     final List<String> suggestionList = query.isEmpty
      ? []
      : names
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    List<Map<String,dynamic>>  temp=[];
 
    for(int i=0;i<suggestionList.length;i++){
      for(int j=0;j<students.length;j++) {
      //Map<String,dynamic> ss= await networkHandler.fetchUniStudentData(students[j]['RegNum']);
        if(suggestionList[i]==students[j]['fname']+" "+students[j]['lname']){

          Map<String,dynamic> tempp={
            'RegNum' :students[j]['RegNum'],
            'name':suggestionList[i],
            'img':students[j]['img'],
            'statusR':students[j]['request'],
            'statusA':students[j]['available'],
            'universityTraining' :students[j]['universityTraining'],
            'finishedhours':students[j]['finishedhours']
          };
          
          temp.add(tempp);
          print(temp);

        }
      }
    }
  return ListView.builder(
    itemCount: temp.length,
    itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(10),
        height: 60,
        width: 411,
        padding: EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
          color: ui.Color.fromARGB(155, 0, 53, 102),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Row(
            children: [
              
              Container(

                margin: EdgeInsets.only(right: 20,bottom: 10,top: 5),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  image: DecorationImage(
                    image:  NetworkImage("http://localhost:5000/" + temp[index]['img']),
//: AssetImage("images/blankimg.PNG") as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
              child:Container(
                
                margin: EdgeInsets.only(bottom: 10),
                //alignment: Alignment.centerLeft,
              child:Text(
                temp[index]['name'],
                style: TextStyle(color: Colors.white,fontSize: 18),
              ),
              ),
              ),
              Expanded(
              flex: 2,
              child:Container(
                alignment: Alignment.center,
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                 color:   temp[index]['statusA']==false || temp[index]['statusR']
                ? const ui.Color.fromARGB(255, 255, 182, 87)
                : groupinfo['isUni']
                  ? temp[index]['universityTraining']
                    ? const ui.Color.fromARGB(255, 255, 182, 87)
                    : temp[index]['finishedhours']>=120
                      ? Colors.lightGreenAccent
                      :const ui.Color.fromARGB(255, 255, 182, 87)
                  : Colors.lightGreenAccent,

                  borderRadius: BorderRadius.circular(10),
                 // border: Border.all()
                ),
                margin: EdgeInsets.only(bottom: 10,left: 40),

                //alignment: Alignment.centerLeft,
              child:Text(
                !temp[index]['statusA'] || temp[index]['statusR']
                ? "Not Available"
                : groupinfo['isUni']
                  ? temp[index]['universityTraining']
                    ? "Not Available"
                    : temp[index]['finishedhours']>=120
                      ? "Available"
                      :"Not Available"
                  : "Available",
                
                

                style: TextStyle(
                  color:  temp[index]['statusA']==false || temp[index]['statusR']
                ? ui.Color.fromARGB(255, 218, 125, 5)
                : groupinfo['isUni']
                  ? temp[index]['universityTraining']
                    ? ui.Color.fromARGB(255, 218, 125, 5)
                    : temp[index]['finishedhours']>=120
                      ? ui.Color.fromARGB(255, 95, 139, 44)
                      :ui.Color.fromARGB(255, 218, 125, 5)
                  : ui.Color.fromARGB(255, 95, 139, 44),                 


                  fontSize: 12),
              ),
              ),),              
            ],
          ),
          onTap: () {
            Map<String,dynamic> stu={
            "id_status": true,
            "RegNum": temp[index]['RegNum'],
            "sname": temp[index]['name'],
            "img": temp[index]['img'],
            };
           if(!temp[index]['statusA'] || temp[index]['statusR'])
                { _showDialog(context,"This student not available ");}
          else if(groupinfo['isUni']){
                  if(temp[index]['universityTraining'])
                    {_showDialog(context,"This student not available ");}
                  else if( temp[index]['finishedhours']>=120)
                      { 
                        groupinfo['membersStudentId'].add(temp[index]['RegNum']);
                        groupinfo['membersStudent'].add(stu);
                        networkHandlerC.updatemembersStudentGroup(groupinfo['_id'], groupinfo['membersStudentId']);
                        networkHandlerC.updatemembersStudentGroupmaps(groupinfo['_id'], groupinfo['membersStudent']);
                        networkHandler.updategroupidstud(temp[index]['RegNum'], groupinfo['_id'], false);
                        _showDialog(context,"This student Added ");
                        onDataRefresh1();

                      }
                  else{_showDialog(context,"This student not available ");}
            }
          else{ 
            groupinfo['membersStudentId'].add(temp[index]['RegNum']);
            groupinfo['membersStudent'].add(stu);
            networkHandlerC.updatemembersStudentGroup(groupinfo['_id'], groupinfo['membersStudentId']);
            networkHandlerC.updatemembersStudentGroupmaps(groupinfo['_id'], groupinfo['membersStudent']);
            networkHandler.updategroupidstud(temp[index]['RegNum'], groupinfo['_id'], false);
            onDataRefresh1();
            _showDialog(context,"This student Added ");
          }
                
           /* if(temp[index]['statusA']==false || temp[index]['statusR']){
               _showDialog(context,"This student not available ");
            }
            else{
            groupinfo['membersStudentId'].add(temp[index]['RegNum']);
            groupinfo['membersStudent'].add(stu);
            networkHandlerC.updatemembersStudentGroup(groupinfo['_id'], groupinfo['membersStudentId']);
            networkHandlerC.updatemembersStudentGroupmaps(groupinfo['_id'], groupinfo['membersStudent']);
            networkHandler.updategroupidstud(temp[index]['RegNum'], groupinfo['_id'], false);
            }*/


            // Handle the selected search result.
           // close(context, suggestionList[index]);
          },
        ),
      );

    },
  );
  }
}
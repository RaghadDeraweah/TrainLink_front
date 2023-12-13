//
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
//import 'package:open_file/open_file.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

String? name = "Flutter Fall23";
String? members;

class showMem extends StatelessWidget {
  late Map<String,dynamic> groupinfo={};
 /* late String groupid;
  late String CID;
  late String cname;
  late String cimg;
  
  late List<String> studentsid;
  late List<Map<String,dynamic>> studentsm;*/
  //howStu(post, companyinfo, companyinfo2, companyinfo3);
 // showMem(String _id,String CID ,String cname, String cimg,List<String> studentsid,List<Map<String,dynamic>> studentsm){
   showMem(Map<String,dynamic> groupinfo){

    super.key;
    this.groupinfo=groupinfo;
  /*  this.groupid=_id;
    this.CID=CID;
    this.cname=cname;
    this.cimg=cimg;
    this.studentsid=studentsid;
    this.studentsm=studentsm;*/
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            color: const Color(0xffff003566),
            icon: const Icon(Icons.arrow_back),
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
              // Navigator.push(context, MaterialPageRoute(builder: (context) { MyHomePageG();}));
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage(0) ));
            },
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Members",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
       // body: StudentsList( this.groupid,this.CID,this.cname,this.cimg,this.studentsid,this.studentsm),
       body: StudentsList( this.groupinfo),
      ),
    );
  }
}

class StudentsList extends StatefulWidget {
    late Map<String,dynamic> groupinfo={};
 /* late String groupid;
  late String CID;
  late String cname;
  late String cimg;
  late List<String> studentsid;
  late List<Map<String,dynamic>> studentsm;*/
  //StudentsList(String _id,String CID ,String cname, String cimg,List<String> studentsid,List<Map<String,dynamic>> studentsm){
  StudentsList(Map<String,dynamic> groupinfo){  
    super.key;
    this.groupinfo=groupinfo;
  /*  this.groupid=_id;
    this.CID=CID;
    this.cname=cname;
    this.cimg=cimg;
    this.studentsid=studentsid;
    this.studentsm=studentsm;*/
  }


  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<StudentsList> {
  bool isDataReady=false;

  Map<String,dynamic> companyData={};
  List<Map<String,dynamic>> stuinfo=[];
  List<Map<String,dynamic>> students=[];
  List<String> stuNames=[];
  final networkHandlerC = NetworkHandlerC();
  final networkHandler = NetworkHandlerS();
Future<Map<String, dynamic>> fetchStudent(String regNum) async {
  //final response = await http.get(Uri.parse("http://localhost:5000/student/$regNum"));
   Map<String, dynamic> jsonData={};


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
/*  void initState() async{
  super.initState();
  for (String sid in widget.studentsid) {
    print(sid);
    var sinfo = await fetchStudent(sid);
    Map<String, dynamic> temp = {
      "id_status": false,
      "RegNum": sinfo['RegNum'],
      "sname": sinfo['fname'] + " " + sinfo['lname'],
      "img": sinfo['img'],
    };
    stuinfo.add(temp);
    if(stuinfo.length==widget.studentsid.length)
    setState(() {
      isDataReady=true;
    });
  }

}*/

Future<void> fetchData() async {
  try {
    companyData = await networkHandlerC.fetchCompanyData(widget.groupinfo['cid']);
    print(companyData);
    students= await networkHandler.fetchStudents();
    print(students);
    for(var map in students){
      map.forEach((key, value) {
        if(key=="fname"){
          setState(() {
            stuNames.add(value+" "+map['lname']);
          });

        }
      });
    }    
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
          backgroundColor: const Color(0xffff003566),
              onPressed: () async{
              await showSearch(
                context: context,
                delegate: CustomSearchDelegate(stuNames,companyData,students,widget.groupinfo),
              );
              },
          child: Icon(
            Icons.person_add,
            color: ui.Color.fromARGB(255, 255, 255, 255),
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
                                IconButton(onPressed:() {
                                  setState(() {
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
  // Dummy list
  final networkHandlerC = NetworkHandlerC();
  final networkHandler = NetworkHandlerS();
 // late String groupid;
  //late List<Map<String,dynamic>> stus;
  //late List<dynamic> stuids;  
  late List<String> names;
  late Map<String ,dynamic> company;
  late Map<String ,dynamic> groupinfo;
  late List<Map<String ,dynamic>> students;
  CustomSearchDelegate(List<String> names,Map<String ,dynamic> company,List<Map<String ,dynamic>> students,Map<String ,dynamic> groupinfo){
    this.students=students;
    this.names=names;
    this.company=company;
    this.groupinfo=groupinfo;
 /*   this.stus=stus;
    this.stuids=stuids;
    this.groupid=groupid;*/
  }
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
      onPressed: () => Navigator.of(context).pop(),
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
  @override
  Widget buildSuggestions(BuildContext context) {
     final List<String> suggestionList = query.isEmpty
      ? []
      : names
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    List<Map<String,dynamic>>  temp=[];
    for(int i=0;i<suggestionList.length;i++){
      for(int j=0;j<students.length;j++){
        if(suggestionList[i]==students[j]['fname']+" "+students[j]['lname']){
          Map<String,dynamic> tempp={
            'RegNum' :students[j]['RegNum'],
            'name':suggestionList[i],
            'img':students[j]['img'],
            'statusR':students[j]['request'],
            'statusA':students[j]['available'],

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
          color: Color.fromARGB(255, 68, 9, 204),
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
              Container(
                
                margin: EdgeInsets.only(bottom: 10),
                //alignment: Alignment.centerLeft,
              child:Text(
                temp[index]['name'],
                style: TextStyle(color: Colors.white,fontSize: 18),
              ),),
              
              Container(
                alignment: Alignment.center,
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                 color:  temp[index]['statusA']==false || temp[index]['statusR']
                 ? const ui.Color.fromARGB(255, 255, 182, 87)
                 : Colors.lightGreenAccent,
                  borderRadius: BorderRadius.circular(10),
                 // border: Border.all()
                ),
                margin: EdgeInsets.only(bottom: 10,left: 60),

                //alignment: Alignment.centerLeft,
              child:Text(
                temp[index]['statusA'] || temp[index]['statusR']
                ? "Not Available"
                : "Available",
                

                style: TextStyle(
                  color:  temp[index]['statusA']==false || temp[index]['statusR']
                  ? ui.Color.fromARGB(255, 218, 125, 5)
                 : ui.Color.fromARGB(255, 95, 139, 44),

                  fontSize: 12),
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

            if(temp[index]['statusA']==false || temp[index]['statusR']){
               _showDialog(context,"This student not available ");
            }
            else{
            groupinfo['membersStudentId'].add(temp[index]['RegNum']);
            groupinfo['membersStudent'].add(stu);
            networkHandlerC.updatemembersStudentGroup(groupinfo['_id'], groupinfo['membersStudentId']);
            networkHandlerC.updatemembersStudentGroupmaps(groupinfo['_id'], groupinfo['membersStudent']);
            networkHandler.updategroupidstud(temp[index]['RegNum'], groupinfo['_id'], false);
            }


            // Handle the selected search result.
           // close(context, suggestionList[index]);
          },
        ),
      );

    },
  );
  }
}
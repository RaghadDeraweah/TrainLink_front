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

class showStu extends StatelessWidget {
  late String postid;
  late String CID;
  late String cname;
  late String cimg;
  late List<dynamic> studentsid;

  //howStu(post, companyinfo, companyinfo2, companyinfo3);
  showStu(String _id,String CID ,String cname, String cimg,List<dynamic> studentsid){
    super.key;
    this.postid=_id;
    this.CID=CID;
    this.cname=cname;
    this.cimg=cimg;
    this.studentsid=studentsid;
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
            "Requests",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: StudentsList( this.postid,this.CID,this.cname,this.cimg,this.studentsid),
      ),
    );
  }
}

class StudentsList extends StatefulWidget {
  late String postid;
  late String CID;
  late String cname;
  late String cimg;
  late List<dynamic> studentsid;
  StudentsList(String _id,String CID ,String cname, String cimg,List<dynamic> studentsid){
    super.key;
    this.postid=_id;
    this.CID=CID;
    this.cname=cname;
    this.cimg=cimg;
    this.studentsid=studentsid;
  }


  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<StudentsList> {
  bool isDataReady=false;
  List<Map<String,dynamic>> stuinfo=[];
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      itemCount: widget.studentsid.length,
                      itemBuilder: (context, index) => ListTile(
                           // value: widget.studentsid[index]['id_status'],
                            //key: ValueKey("1"),
                            title: Container(
                              height: 70,
                              width: 411,
                            padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 64, 32, 139),
                                borderRadius: BorderRadius.circular(10),
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
                                  width: 210,
                                child:Text(
                                  stuinfo[index]['sname'],
                                  style: TextStyle(color: Colors.white),
                                ),),
                             

                              Row(children: [
                                
                                IconButton(onPressed:() async{
                                  print(stuinfo[index]['cv']);
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
                                  networkHandler.updatepostidstud(stuinfo[index]['RegNum'],"",false);
                                  });

                                }, icon: Icon(
                              Icons.remove_circle,
                              color: Color.fromARGB(255, 214, 91, 91),
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
  
}/*=> openFile(
                                  Url:"http://localhost:5000/"+stuinfo[index]['cv'],
                                  filename :'${stuinfo[index]['RegNum']}.pdf',
                                ),*/
import 'package:flutter/material.dart';
import 'package:untitled4/Settings/mainSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:get/get.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/Tabs/addcompanyform.dart';

class Forms extends StatefulWidget {
    final String CID;
    Forms({
    Key? key,
    required this.CID,
  }) : super(key: key);
  @override
  _Forms22State createState() => _Forms22State();
}

class _Forms22State extends State<Forms> {
  bool isDataReady=false;
  String groupid="";
  String postid="";
  String dropdownValue = "Group";
  String dropdownValueWeeks = "AllWeeks";
  String dropdownValueStudents = "AllStudent";
  final networkHandlerC = NetworkHandlerC();
  final networkHandler1 = NetworkHandlerS();
  Map<String, dynamic>  companyinfo={};
  List<Map<String,dynamic>> groups=[];
  Map<String,dynamic> currecntgroup={};
  List<Map<String,dynamic>> forms=[];
  List<Map<String, dynamic>> availablegroups = [];
  List<String> availablegroupssNames = [];
  List<Map<String, dynamic>> postss = [];
  List<Map<String, dynamic>> reportslist = [];
  List<Map<String,dynamic>> stuinfo=[];
  List<String> studentslist = [];
 Future<void> fetchForms(String _id,String groupnametemp) async {
     reportslist = await networkHandlerC.getForms(_id);
    setState(() {
      forms = reportslist;
      print(forms);
      Students(groupnametemp);
    });
 

  }
  void Students(String newValue,)async{
                              for (var map in groups) {
                              if(map['groupname']==dropdownValue){
                               print("Match");
                               // fetchReportsWeek(map['_id'],newValue!);   
                                for (String sid in map["membersStudentId"]) {
                                  if(forms.length==0){
                                            var sinfo = await networkHandler1.fetchStudent(sid);
                                            String temp =  sinfo['fname'] + " " + sinfo['lname'];
                                            Map<String, dynamic> temp1 = {
                                            // "id_status": false,
                                              "RegNum": sinfo['RegNum'],
                                              "sname": sinfo['fname'] + " " + sinfo['lname'],
                                              "img": sinfo['img'],
                                              "isEvaluate":false,
                                            };
                                            setState(() {
                                          stuinfo.add(temp1);
                                          print(stuinfo);
                                          studentslist.add(temp);
                                          print(studentslist);
                                        });
                                  }
                                  else{
                                  for(int j=0;j<forms.length;j++){
                                    if(sid==forms[j]['StuId']){
                                            var sinfo = await networkHandler1.fetchStudent(sid);
                                            String temp =  sinfo['fname'] + " " + sinfo['lname'];
                                            Map<String, dynamic> temp1 = {
                                            // "id_status": false,
                                              "RegNum": sinfo['RegNum'],
                                              "sname": sinfo['fname'] + " " + sinfo['lname'],
                                              "img": sinfo['img'],
                                              "isEvaluate":true,
                                            };
                                            setState(() {
                                          stuinfo.add(temp1);
                                          print("Students Info ${stuinfo}");
                                          studentslist.add(temp);
                                          print("Students Names ${studentslist}");
                                        });
                                    }
                                    else{
                                      bool exist=false;
                                      for(int k=0;k<stuinfo.length;k++){
                                        if(stuinfo[k]['RegNum']==sid){
                                          exist=true;
                                        }
                                      }
                                      if((j==forms.length-1) && exist==false){
                                            var sinfo = await networkHandler1.fetchStudent(sid);
                                            String temp =  sinfo['fname'] + " " + sinfo['lname'];
                                            Map<String, dynamic> temp1 = {
                                            // "id_status": false,
                                              "RegNum": sinfo['RegNum'],
                                              "sname": sinfo['fname'] + " " + sinfo['lname'],
                                              "img": sinfo['img'],
                                              "isEvaluate":false,
                                            };
                                            setState(() {
                                          stuinfo.add(temp1);
                                          print(stuinfo);
                                          studentslist.add(temp);
                                          print(studentslist);
                                        });}
                                    }
                                  }}

                               // var sinfo = await networkHandler1.fetchStudent(sid);
                               // String temp =  sinfo['fname'] + " " + sinfo['lname'];

                              }                            
                              }
                              }
  }
 Future<void> fetchReports(String _id) async {
     reportslist = await networkHandlerC.getReports(_id);
    setState(() {
      forms = reportslist;
      print(forms);
    });
  }
   Future<void> fetchReportsWeek(String _id,String Week) async {
     reportslist = await networkHandlerC.getReportsweek(_id,Week);
    setState(() {
      forms = reportslist;
      print(forms);
    });
  }
   Future<void> fetchReportforstud(String _id,String Week,String StuId) async {
     reportslist = await networkHandlerC.getReportsweekStudent(_id,Week,StuId);
    setState(() {
      forms = reportslist;
      print(forms);
    });
  }
   Future<void> fetchReportsforstud(String _id,String StuId) async {
     reportslist = await networkHandlerC.getReportsStudent(_id,StuId);
    setState(() {
      forms = reportslist;
      print(forms);
    });
  }
  Future<void> fetchData() async {
  try {

    companyinfo = await networkHandlerC.fetchCompanyData(widget.CID!);
    companyinfo.values.forEach((value) {
      print(value);
    });
    postss = await networkHandlerC.fetchPosts(widget.CID!);
    //print(postss);
    groups = await networkHandlerC.getGroups(widget.CID!);
    for (var map in groups) {
      print("inside groups");
      map.forEach(
        (key, value) {
        if(key=="islocked" && value==true){
        print("islocked passed");
        for(int i=0;i<postss.length;i++){
          print("inside loop");
          print("post "+postss[i]['_id']);
          print("group "+map['postid']);
             if( postss[i]['_id']==map['postid']){
             // if(postss[i]['isUni']==true){
             // print("post is uni");
             // print("post is Uni ="+postss[i]["isUni"]);
              availablegroups.add(map);
              availablegroupssNames.add(map["groupname"]);
              print(availablegroupssNames);
              //}
          }
          }
         /* for(var post in postss){
               post.forEach(
                (key, value) {
                   print("post ");
              if(key=='_id' && value==map['postid']){
                 print("post "+value);
              if(post['isUni']==true){
                 print("post is uni");
                    print("postid"+map["isUni"]);
              availablegroups.add(map);
              availablegroupssNames.add(map["groupname"].toLowerCase());
              print(availablegroupssNames);
              }}

            });
            
          }*/
        }
      });
    }

    /*for (String name in availablepostssNames){
      print(name);
    }*/

    isDataReady=true;
  } catch (error) {
    print(error);
  }
}
void initState() {
  super.initState();
  fetchData().then((_) {
    setState(() {
      availablegroupssNames.add("Group");
    //  fetchForms(wi)
      studentslist.add("AllStudent");
      isDataReady = true; // Set the flag to true when data is fetched
    });
    });
}
//getReportsStudent
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: isDataReady
           ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  Container(
                    width: 411,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Forms",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    //  color: Colors.amber,
                  ),
                  Divider(
                    color: Color(0xffffc300),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          "Group Training :",
                          style: TextStyle(
                              color: Color(0xffffc300),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        width: 180,
                      ),
                      ),
                      Expanded(
                          flex: 1,
                         // margin: EdgeInsets.only(top: 10),
                        child:DropdownButton<String>(
                          menuMaxHeight: 160,
                          
                          padding: EdgeInsets.only(left: 0),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16),
                          alignment: Alignment.center,
                          value: dropdownValue,
                          onChanged: (String? newValue) async{
                            setState(() {
                              dropdownValue = newValue!;
                              for (var map in groups) {
                              if(map['groupname']==newValue){
                               print("Match");
                               setState(() {
                                currecntgroup=map;
                                 groupid=map['_id'];
                                 postid=map['postid'];
                               });
                              fetchForms(map['_id'],map['groupname']);
                              }}
                              
                            });

                              //print(forms);

                               
                                
                              
                              
                            
                           // print(_allUsersID);
                          },
                          items: availablegroupssNames.map((String name){
                          return DropdownMenuItem(
                          value: name,
                          child: Text(name),
                          
 
                          );

                         }).toList(),
                  
                          
                          //value: dropdownValue,
                          icon: Icon(Icons.arrow_drop_down_rounded),
                        ),
                      ),
                    ],
                  ),
                   Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 255, 255, 255),
               // margin: EdgeInsets.symmetric(horizontal: 30),
              //  padding: EdgeInsets.only(top:5,left: 5,right: 5,bottom: 5),
               // color: Colors.amber,
               // child: Expanded(
                  child: ListView.builder(
                      itemCount: stuinfo.length,
                      itemBuilder: (context, index) => ListTile(
                           // value: widget.studentsid[index]['id_status'],
                            //key: ValueKey("1"),
                            title: Container(
                              height: 60,
                              width: 400,
                            padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 185, 178, 199),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child : Row(
                             // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(

                                    margin: EdgeInsets.only(right: 20),
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                     // color: Colors.amber,
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                            image:NetworkImage("http://localhost:5000/"+stuinfo[index]['img']),
                                            fit: BoxFit.cover))),
                                Container(
                                  width: 230,
                                child:Text(
                                  stuinfo[index]['sname'],
                                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0),fontSize: 18),
                                ),),
                             

                              Row(
                                children: [
                                
                             /*   IconButton(onPressed:() async{
                                  /*print(stuinfo[index]['cv']);
                                  networkHandler.downloadFile("http://localhost:5000/"+stuinfo[index]['cv'], '${stuinfo[index]['RegNum']}.pdf');
                                */}, icon: stuinfo[index]['isEvaluate']
                               ? Icon(
                                      Icons.done,
                                      color: Color.fromARGB(255, 4, 158, 40),
                                      size: 30.0,
                                 )
                               : Icon(
                                      Icons.close,
                                      color: Color.fromARGB(255, 105, 97, 97)
                                      size: 30.0,
                                 ),
                            ),*/
                                IconButton(onPressed:() {
                                  if(stuinfo[index]['isEvaluate']==false){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddCompanyform(currecntgroup,widget.CID,this.groupid,stuinfo[index]['RegNum'],stuinfo[index]['sname'],stuinfo[index]['img'],postid)));
                                  }
                                  //AddCompanyform
                                 /* setState(() {
                                  widget.studentsid.remove(stuinfo[index]['RegNum']);
                                  networkHandlerC.updateapllidStuId(widget.postid,widget.studentsid);
                                  });*/

                                }, icon: stuinfo[index]['isEvaluate']
                               ? Icon(
                                      Icons.done,
                                      color: Color.fromARGB(255, 4, 158, 40),
                                      size: 30.0,
                                 )
                              : Icon(
                              Icons.post_add,
                              color: Color.fromARGB(255, 46, 46, 173),
                              size: 30.0,
                            ),
                            )
                              
                              ],)
                           //   ],
                           // ),
                            ],),
                          ),
                       ),
                          
                ))
                ]))
          : Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
  ));
  }

void _showFeedbackOverlay(String reportid) {
    TextEditingController feedbackController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          
          title: Text('Provide Feedback'),
          content: TextField(
            controller: feedbackController,
            decoration: InputDecoration(labelText: 'Feedback'),
            onChanged: (value) {
              setState(() {
                feedbackController.text=value;
              });
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
               // networkHandlerC.updateCompanyFeedback(reportid,feedbackController.text);
               /* student.feedback = feedbackController.text;*/
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

}

/*class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Divider(),
              MaterialButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MainSettings();
                  }));
                },
                child: Container(
                  width: 411,
                  height: 100,
                  margin: EdgeInsets.only(bottom: 2),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        child: Icon(
                          Icons.settings,
                          size: 35,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Container(
                          width: 200,

                          //color: Colors.amber,
                          padding: EdgeInsets.only(top: 0, bottom: 10),
                          child: Text(
                            "Settings",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          // alignment: Alignment.topLeft,
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined)
                    ],
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {},
                child: Container(
                  width: 411,
                  height: 100,
                  margin: EdgeInsets.only(bottom: 2, left: 0),
                  padding: EdgeInsets.only(left: 26),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        child: Icon(
                          Icons.logout,
                          size: 35,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 35),
                        child: Container(
                          width: 200,

                          //color: Colors.amber,
                          padding: EdgeInsets.only(top: 0, bottom: 10),
                          child: Text(
                            "Log Out",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          // alignment: Alignment.topLeft,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}*/

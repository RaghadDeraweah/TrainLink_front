import 'package:flutter/material.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:get/get.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/Tabs/ViewReport.dart';

class Reports22 extends StatefulWidget {
    final String CID;
    Reports22({
    Key? key,
    required this.CID,
  }) : super(key: key);
  @override
  _Reports22State createState() => _Reports22State();
}

class _Reports22State extends State<Reports22> {
  bool isDataReady=false;
  String dropdownValue = "Group";
  String dropdownValueWeeks = "AllWeeks";
  String dropdownValueStudents = "AllStudent";
  final networkHandlerC = NetworkHandlerC();
  final networkHandler1 = NetworkHandlerS();
  Map<String, dynamic>  companyinfo={};
  List<Map<String,dynamic>> groups=[];
  List<Map<String,dynamic>> reports=[];
  List<Map<String, dynamic>> availablegroups = [];
  List<String> availablegroupssNames = [];
  List<Map<String, dynamic>> postss = [];
  List<Map<String, dynamic>> reportslist = [];
  List<String> studentslist = [];
 Future<void> fetchReports(String _id) async {
     reportslist = await networkHandlerC.getReports(_id);
    setState(() {
      reports = reportslist;
      print(reports);
    });
  }
   Future<void> fetchReportsWeek(String _id,String Week) async {
     reportslist = await networkHandlerC.getReportsweek(_id,Week);
    setState(() {
      reports = reportslist;
      print(reports);
    });
  }
   Future<void> fetchReportforstud(String _id,String Week,String StuId) async {
     reportslist = await networkHandlerC.getReportsweekStudent(_id,Week,StuId);
    setState(() {
      reports = reportslist;
      print(reports);
    });
  }
   Future<void> fetchReportsforstud(String _id,String StuId) async {
     reportslist = await networkHandlerC.getReportsStudent(_id,StuId);
    setState(() {
      reports = reportslist;
      print(reports);
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
        if(key=="islocked" && value==false){
        print("islocked passed");
        for(int i=0;i<postss.length;i++){
          print("inside loop");
          print("post "+postss[i]['_id']);
          print("group "+map['postid']);
             if( postss[i]['_id']==map['postid']){
              if(postss[i]['isUni']==true){
              print("post is uni");
             // print("post is Uni ="+postss[i]["isUni"]);
              availablegroups.add(map);
              availablegroupssNames.add(map["groupname"]);
              print(availablegroupssNames);
              }
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
                        "Reports",
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
                          "Available Courses :",
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
                            });
                            for (var map in groups) {
                              if(map['groupname']==newValue){
                               print("Match");
                                fetchReports(map['_id']);
                              for (var map in groups) {
                              if(map['groupname']==dropdownValue){
                               print("Match");
                                fetchReportsWeek(map['_id'],newValue!);   
                                for (String sid in map["membersStudentId"]) {
                                print(sid);
                                var sinfo = await networkHandler1.fetchStudent(sid);
                                String temp =  sinfo['fname'] + " " + sinfo['lname'];
   

                                setState(() {
                                  studentslist.add(temp);
                                  print(studentslist);
                                });
                              }                            
                              }
                              }
                               
                                
                              }
                              }
                            
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 200,
                        height: 50,
                        // color: Colors.blue,
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: 200,
                          padding: EdgeInsets.only(left: 0),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16),
                          alignment: Alignment.center,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValueWeeks = newValue!;
                              
                              
                            });
                              for (var map in groups) {
                              if(map['groupname']==dropdownValue){
                                //var temp =
                                for(int i=0; i<map['membersStudent'].length;i++){
                                  if(map['membersStudent'][i]['sname']==dropdownValueStudents){
                                    print("Found Student :"+map['membersStudent'][i]['RegNum']);
                                   if(dropdownValueWeeks=="AllWeeks" ){
                                      fetchReportsforstud(map['_id'],map['membersStudent'][i]['RegNum']);
                                    }
                                    else{
                                      fetchReportforstud(map['_id'],dropdownValueWeeks,map['membersStudent'][i]['RegNum']);
                                    }
                                  }else if(dropdownValueWeeks !="AllWeeks" && dropdownValueStudents == "AllStudent"){
                                   fetchReportsWeek(map['_id'],dropdownValueWeeks);
                                  }else if(dropdownValueWeeks=="AllWeeks" && dropdownValueStudents == "AllStudent"){
                                    fetchReports(map['_id']);
                                  }
                                }
                               //print("Match");
                                //fetchReportsWeek(map['_id'],newValue!);                                                             
                              }}

                          },
                          items: [
                            DropdownMenuItem(
                              child: Text(
                                "Week 1",
                              ),
                              value: "Week1",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 2",
                              ),
                              value: "Week2",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 3",
                              ),
                              value: "Week3",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 4",
                              ),
                              value: "Week4",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 5",
                              ),
                              value: "Week5",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 6",
                              ),
                              value: "Week6",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 7",
                              ),
                              value: "Week7",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 8",
                              ),
                              value: "Week8",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 9",
                              ),
                              value: "Week9",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 10",
                              ),
                              value: "Week10",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 11",
                              ),
                              value: "Week11",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 12",
                              ),
                              value: "Week12",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 13",
                              ),
                              value: "Week13",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 14",
                              ),
                              value: "Week14",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 15",
                              ),
                              value: "Week15",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 16",
                              ),
                              value: "Week16",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 17",
                              ),
                              value: "Week17",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 18",
                              ),
                              value: "Week18",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 19",
                              ),
                              value: "Week19",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 20",
                              ),
                              value: "Week20",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 21",
                              ),
                              value: "Week21",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "All Weeks",
                              ),
                              value: "AllWeeks",
                            )
                          ],
                          value: dropdownValueWeeks,
                          icon: Icon(Icons.arrow_drop_down_rounded),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 200,
                        height: 50,
                        //      color: Colors.blue,
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: 200,
                          padding: EdgeInsets.only(left: 0),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16),
                          alignment: Alignment.center,
                          value: dropdownValueStudents,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValueStudents = newValue!;
                            });

                              for (var map in groups) {
                              if(map['groupname']==dropdownValue){
                                //var temp =
                                for(int i=0; i<map['membersStudent'].length;i++){
                                  if(map['membersStudent'][i]['sname']==dropdownValueStudents){
                                    print("Found Student :"+map['membersStudent'][i]['RegNum']);
                                   if(dropdownValueWeeks=="AllWeeks" ){
                                      fetchReportsforstud(map['_id'],map['membersStudent'][i]['RegNum']);
                                    }
                                    else{
                                      fetchReportforstud(map['_id'],dropdownValueWeeks,map['membersStudent'][i]['RegNum']);
                                    }
                                  }else if(dropdownValueWeeks !="AllWeeks" && dropdownValueStudents == "AllStudent"){
                                   fetchReportsWeek(map['_id'],dropdownValueWeeks);
                                  }else if(dropdownValueWeeks=="AllWeeks" && dropdownValueStudents == "AllStudent"){
                                    fetchReports(map['_id']);
                                  }
                                }
                               //print("Match");
                                //fetchReportsWeek(map['_id'],newValue!);                                                             
                              }}
                          },
                          items:  studentslist.map((String name){
                          return DropdownMenuItem(
                          value: name,
                          child: Text(name),
                          
 
                          );

                         }).toList(),
                          
                          icon: Icon(Icons.arrow_drop_down_rounded),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      width: 411,
                      child: SingleChildScrollView(
                          child: 
                          tabelColumn(dropdownValueStudents, dropdownValueWeeks)
                              
                              )
                      )
                ]))
          : Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
  ));
  }
DataTable tabelColumn(dropdownValueStudents, dropdownValueWeeks) {
  if (dropdownValueStudents == "AllStudent" &&
      dropdownValueWeeks == "AllWeeks") {
    return DataTable(
      horizontalMargin: 10,
      columns: [
      DataColumn(label: Text('Name')),
     // DataColumn(label: Text('Reports')),
      DataColumn(label: Text('Approval?')),
     // DataColumn(label: Text('Feedback')),
    ], rows: reports.map((Map<String, dynamic> row) {
        return  TabelReports(dropdownValueStudents,dropdownValueWeeks,row['_id'],row['groupid'],row['StuId'],row['StuImg'], row['StuName'], row['reportpdf'], row['companyApproval']);    
      }).toList(),
    );
  } 
  else if (dropdownValueStudents == "AllStudent") {
    return DataTable(
        horizontalMargin: 10,
      columns: [
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Report')),
      DataColumn(label: Text('Approval?')),
  //    DataColumn(label: Text('Feedback')),
    ], rows: reports.map((Map<String, dynamic> row) {
        return  TabelReports(dropdownValueStudents,dropdownValueWeeks,row['_id'],row['groupid'],row['StuId'],row['StuImg'], row['StuName'], row['reportpdf'], row['companyApproval']);    
      }).toList(),
    );
  } else {
    return DataTable(
     horizontalMargin: 2,
      columns: [
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Report')),
      DataColumn(label: Text('Approval?')),
     // DataColumn(label: Text('Feedback')),
    ], rows: reports.map((Map<String, dynamic> row) {
        return  TabelReports(dropdownValueStudents,dropdownValueWeeks,row['_id'],row['groupid'],row['StuId'],row['StuImg'], row['StuName'], row['reportpdf'], row['companyApproval']);    
      }).toList(),
);
  }
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
               // 
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
DataRow TabelReports(dropdownValueStudents,dropdownValueWeeks, reportid,groupid,StuId,StuImg, name, report, seeCompany) {
  Color color;
  if (seeCompany) {
    color = Colors.green;
  } else {
    color = Colors.red;
  }
  if (dropdownValueStudents == "AllStudent" && dropdownValueWeeks == "AllWeeks") {
    return DataRow(cells: [
      DataCell(Text(name)),
    /*  DataCell(Row(
        children: [
          IconButton(
            onPressed: () {
              //networkHandlerC.downloadFile("http://localhost:5000/"+report, '${reportid}.pdf');
            },
            icon: Icon(
              Icons.download_sharp,
              color: Colors.grey,
            ),
          ),
        ],
      )),*/
      DataCell(Row(
        children: [

             Icon(
              Icons.remove_red_eye_outlined,
              color: color,
            ),

        ],
      )),
   /*   DataCell(Row(
        children: [
          IconButton(
            onPressed: () {
            //  _showFeedbackOverlay(reportid);
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
                
               /* student.feedback = feedbackController.text;*/
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
            },
            icon: Icon(
              Icons.feedback_outlined,
              color: Color.fromARGB(255, 40, 12, 126),
            ),
          ),
        ],
      )),*/
    ]);
  }
  if (dropdownValueStudents == "AllStudent") {
    return DataRow(cells: [
      DataCell(Text(name)),
      DataCell(Row(
        children: [
          IconButton(
            onPressed: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewReport(dropdownValueWeeks,groupid,reportid,StuId,name,StuImg)));
            },
            icon: Icon(
               Icons.view_agenda,
              color: Colors.grey,
            ),
          ),
        ],
      )),
      DataCell(Row(
        children: [

             Icon(
              Icons.remove_red_eye_outlined,
              color: color,
            ),

        ],
      )),
    /*  DataCell(Row(
        children: [
          IconButton(
            onPressed: () {
              _showFeedbackOverlay(reportid);
            },
            icon: Icon(
              Icons.feedback_outlined,
              color: Color.fromARGB(255, 40, 12, 126),
            ),
          ),
        ],
      )),*/
    ]);
  } else {
    return DataRow(cells: [
      DataCell(Text(name)),
      DataCell(Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewReport(dropdownValueWeeks,groupid,reportid,StuId,name,StuImg)));
              //ViewReport
             // networkHandlerC.downloadFile("http://localhost:5000/"+report, '${reportid}.pdf');
            },
            icon: Icon(
              Icons.view_agenda,
              color: Colors.grey,
            ),
          ),
        ],
      )),
      DataCell(Row(
        children: [

             Icon(
              Icons.remove_red_eye_outlined,
              color: color,
            ),

        ],
      )),
   /*   DataCell(Row(
        children: [
          IconButton(
            onPressed: () {
              _showFeedbackOverlay(reportid);
            },
            icon: Icon(
              Icons.feedback_outlined,
              color: Color.fromARGB(255, 40, 12, 126),
            ),
          ),
        ],
      )),*/
    ]);
  }
}
}







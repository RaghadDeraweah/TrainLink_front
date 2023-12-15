import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/createNewGroup.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class IntroPage4 extends StatefulWidget {
    final String CID;
    final Function(String) postid;
    final Function(List<Map<String,dynamic>>) getStudents;
    final Function(List<String>) getStudentsId;
    IntroPage4({
    Key? key,
    required this.CID,
    required this.postid,
    required this.getStudents,
    required this.getStudentsId,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _IntroPage4State createState() => _IntroPage4State();
}
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
class _IntroPage4State extends State<IntroPage4> {
  bool valuue = false;
  String dropdownValue = "Flutter";
  String selectedpostid="";
  final networkHandlerC = NetworkHandlerC();
  final networkHandler1 = NetworkHandlerS();
  String nameGroup = '';
  List<Map<String, dynamic>> postss = [];
  List<Map<String, dynamic>> availablepostss = [];
    List<String> availablepostssNames = [];
  DateTime? dateTime ;
  Map<String, dynamic>  companyinfo={};
  Map<String,dynamic> sinfo ={};
  bool isDataReady=false;

  List<Map<String, dynamic>> _allUsers = [];
    List<Map<String, dynamic>> _allUsersT= [];
  List<String> _allUsersIDT= [];
  List<String> _allUsersID= [];
  PageController _controller = PageController();
Future<void> fetchData() async {
  try {

    companyinfo = await networkHandlerC.fetchCompanyData(widget.CID!);
    companyinfo.values.forEach((value) {
      print(value);
    });

    postss = await networkHandlerC.fetchPosts(widget.CID!);
    for (var map in postss) {
      print("inside poooooooosts");
      //if()
      print(map['hasgroup']);
      map.forEach(
        (key, value) {
        if((key=="isFreezed" && value==true) && (map['hasgroup']==false)){
          availablepostss.add(map);
                    print("post id"+map["_id"]);
                    print("post id"+map["field"]);
          availablepostssNames.add(map["field"]);

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
      availablepostssNames.add("Group");
      isDataReady = true; // Set the flag to true when data is fetched
    });
    });
}
  @override
  Widget build(BuildContext context) {
    return Container(
        child: isDataReady
        ? Container(
      color: Colors.white,
      width: 400,
      height: 750,
      //child: SingleChildScrollView(
      //  scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: 330,
              height: 330,
              //color: Colors.yellow,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.scaleDown,
                      image: AssetImage("images/teamGroups (1).jpeg"))),
              margin: EdgeInsets.all(20),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      //   width: 200,
                      height: 30,
                      margin: EdgeInsets.only(left: 10, top: 10),
                      child: Text(
                        "Add members from available posts :",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      //  width: 200,
                      height: 50,
                      //color: Colors.yellow,
                    //  child:Expanded(
                      child: DropdownButton<String>(
                        //padding: EdgeInsets.only(left: 15),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16),
                        alignment: Alignment.center,
                        value: "Group",
                        onChanged: (String? newValue) async {
                            setState(() {
                              dropdownValue = newValue!;
                              nameGroup = dropdownValue;
                            });

                            for (var map in postss) {
                              if(map['field']==newValue){
                                setState(() {
                                  selectedpostid=map['_id'];
                                });
                              for (String sid in map["appliedStuId"]) {
                                print(sid);
                                var sinfo = await fetchStudent(sid);
                                Map<String, dynamic> temp = {
                                  "id_status": false,
                                  "RegNum": sinfo['RegNum'],
                                  "sname": sinfo['fname'] + " " + sinfo['lname'],
                                  "img": sinfo['img'],
                                };

                                setState(() {
                                  
                                  _allUsers.add(temp);
                                  _allUsersID.add(temp['RegNum']);
                                  widget.postid(map['_id']);
                                  widget.getStudents(_allUsers);
                                  widget.getStudentsId(_allUsersID);
                                });
                              }}
                            }
                            print(_allUsers);
                            print(_allUsersID);
  },
                        items: availablepostssNames.map((String name){
                          return DropdownMenuItem(
                          child: Text(name),
                          value: name,
 
                          );

                         }).toList(),
                        //value: dropdownValue,
                        icon: Icon(Icons.arrow_drop_down_rounded),
                      ),
                //),
                ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Select All"),
                    Checkbox(
                        value: valuue,
                        onChanged: (valSelectAll) {
                          setState(() {
                            valuue = true;
                            for (var i = 0; i < _allUsers.length; i++) {
                              for(int j=0;j<availablepostss.length;j++){
                                if(availablepostss[j]['_id']==selectedpostid){
                                  if(availablepostss[j]['isUni']){
                                    networkHandler1.updateunitrain(_allUsers[i]['RegNum'], true);
                                      print("update university train for stu="+_allUsers[i]['RegNum']);
                                  }
                                }
                              }
                              _allUsers[i]['id_status'] = true;
                              _allUsersT.add(_allUsers[i]);
                              _allUsersIDT.add(_allUsers[i]['RegNum']);

                            }
                           widget.getStudents(_allUsersT);  
                           widget.getStudentsId(_allUsersIDT); 

                          });
                        }),
                  ],
                )
              ],
            ),
            Container(
                height: 150,
                width: 411,
                margin: EdgeInsets.symmetric(horizontal: 30),
                padding: EdgeInsets.only(bottom: 10),
                color: Colors.amber,
               // child: Expanded(
                  child: ListView.builder(
                      itemCount: _allUsers.length,
                      itemBuilder: (context, index) => CheckboxListTile(
                            value: _allUsers[index]['id_status'],
                            onChanged: (val) {
                              setState(() {
                                _allUsers[index]['id_status'] = val!;
                                if(val){
                               for(int j=0;j<availablepostss.length;j++){
                                if(availablepostss[j]['_id']==selectedpostid){
                                  if(availablepostss[j]['isUni']){
                                    networkHandler1.updateunitrain(_allUsers[index]['RegNum'], true);
                                  }
                                }
                              }
                                  _allUsersT.add(_allUsers[index]);
                                  _allUsersIDT.add(_allUsers[index]['RegNum']);
                                  widget.getStudents(_allUsersT);
                                  widget.getStudentsId(_allUsersIDT);
                                }
                              });
                            },

                            //key: ValueKey("1"),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(right: 20),
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        image: DecorationImage(
                                            image:NetworkImage("http://localhost:5000/"+_allUsers[index]['img']),
                                            fit: BoxFit.cover))),
                                Text(
                                  _allUsers[index]['sname'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          )),
                ),
                //),
          ],
        ),
     // ),
    )
        :Center(
            child: CircularProgressIndicator(), // Loading indicator
          )
    );
  }
}

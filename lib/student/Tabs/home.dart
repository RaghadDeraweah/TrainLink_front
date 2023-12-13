import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:untitled4/BStudent.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled4/BCompany.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

Future<List<Map<String, dynamic>>> fetchPosts(String companyId) async {
    final response = await http.get(Uri.parse("http://localhost:5000/post/posts/$companyId"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = convert.jsonDecode(response.body);
      List<Map<String, dynamic>> posts = [];

      for (var item in jsonData) {
        posts.add(item);
      }

      return posts;
    } else {
      //print("faild : ${response.body}");
      throw Exception("faild : ${response.body}");
    }
}


class _HomeScreenState extends State<HomeScreen> {
  bool isCliked=false;
String? IDS;
bool isDataReady=false;
String? location = null;
String? framework = null;
bool stateOnline = false;
bool stateUniv = false;
bool alwaysfalse = true;
List<Map<String, dynamic>> postss = [];
List<Map<String, dynamic>> avaliblepostss = [];
DateTime? dateTime ;
Map<String, dynamic>  studentinfo={};
final storage = FlutterSecureStorage();
final networkHandlers = NetworkHandlerS();
final networkHandlerC = NetworkHandlerC();
List<Map<String, dynamic>> reversedItems=[];
List<dynamic> ss=[];

  @override
  void initState() {
      super.initState();
      fetchData().then((_) {
        setState(() {
        postss = List.from(reversedItems.reversed);
          isDataReady = true; // Set the flag to true when data is fetched
        });
        });
    }

  Future<void> fetchData() async {
  try {

    IDS = await networkHandlers.getid();
    print(IDS);

    studentinfo = await networkHandlers.fetchStudentData(IDS!);
    studentinfo.values.forEach((value) {
      print(value);
    });
  
    reversedItems = await await networkHandlers.fetchPosts();
    for (var map in reversedItems) {
      map.forEach((key, value) {
        if(key=="isFreezed" && value==false){
          avaliblepostss.add(map);
          print(map);
        }
        print('$key: $value');
      });
    }

    isDataReady=true;
  } catch (error) {
    print(error);
  }
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
  Widget build(BuildContext context) {
    
    return  MaterialApp(
       debugShowCheckedModeBanner: false,
      home: Scaffold(
      body: isDataReady
      ? CustomScrollView(
        shrinkWrap: true,
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                expandedHeight: 50.0, // Set the height you want for the flexible space
                flexibleSpace: FlexibleSpaceBar(
                 background:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: 
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(width: 15,),
                    Container(
                      // color: Colors.yellow,
                      margin: EdgeInsets.only(top: 10),
                      //  width: 160,
                      height: 50,
                      // color: Colors.blue,+
                      child: DropdownButton<String>(
                        menuMaxHeight: 200,
                        underline: Container(),
                        padding: EdgeInsets.only(left: 0),
                        hint: Text(
                          'Location',
                        ),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 13),
                        alignment: Alignment.center,
                        onChanged: (String? newValue) {
                          setState(() {
                            if (newValue == "Nothing") {
                              location = null;
                            } else {
                              location = newValue!;
                            }
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Nablus",
                              ),
                            ),
                            value: "Nablus",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Ramallah",
                              ),
                            ),
                            value: "Ramallah",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Jenin",
                              ),
                            ),
                            value: "Jenin",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Tulkarm",
                              ),
                            ),
                            value: "Tulkarm",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Hebron",
                              ),
                            ),
                            value: "Hebron",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Bethlehem",
                              ),
                            ),
                            value: "Bethlehem",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Jerusalem",
                              ),
                            ),
                            value: "Jerusalem",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Outside Palestine",
                              ),
                            ),
                            value: "Outside Palestine",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Nothing",
                              ),
                            ),
                            value: "Nothing",
                          )
                        ],
                        value: location,
                        icon: (location != null)
                            ? Icon(
                                Icons.location_on,
                                color: Colors.amber,
                              )
                            : Icon(Icons.location_on),
                      ),
                    ),
                    Container(width: 20,),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      //  width: 160,
                      height: 50,
                      // color: Colors.blue,+
                      child: DropdownButton<String>(
                        underline: Container(),
                        // padding: EdgeInsets.only(left: 0),
                        hint: Text(
                          'Framework',
                        ),

                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 13),
                        alignment: Alignment.center,
                        onChanged: (String? newValue) {
                          setState(() {
                            
                            if (newValue == "Nothing") {
                              framework = null;
                            } else {
                              framework = newValue!;
                            }
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Flutter",
                              ),
                            ),
                            value: "Flutter",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "React",
                              ),
                            ),
                            value: "React",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Angular",
                              ),
                            ),
                            value: "Angular",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "VueJs",
                              ),
                            ),
                            value: "VueJs",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Svelte",
                              ),
                            ),
                            value: "Svelte",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "jQuery",
                              ),
                            ),
                            value: "jQuery",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Backbone.js",
                              ),
                            ),
                            value: "Backbone.js",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              child: Text(
                                "JavaScript",
                              ),
                            ),
                            value: "JavaScript",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Django",
                              ),
                            ),
                            value: "Django",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "ExpressJS",
                              ),
                            ),
                            value: "ExpressJS",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Laravel",
                              ),
                            ),
                            value: "Laravel",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "ASP .NET Core",
                              ),
                            ),
                            value: "ASP .NET Core",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Spring Boot",
                              ),
                            ),
                            value: "Spring Boot",
                          ),
                          DropdownMenuItem(
                            child: Container(
                              width: 80,
                              child: Text(
                                "Nothing",
                              ),
                            ),
                            value: "Nothing",
                          ),
                        ],
                        value: framework,
                        icon: (framework != null)
                            ? Icon(
                                Icons.computer,
                                color: Colors.amber,
                              )
                            : Icon(Icons.computer),
                      ),
                    ),
                  ],
                ),
                ),
                Expanded(
                  flex: 1,
                  child: 
                Container(
                    padding: EdgeInsets.only(top: 7),
                    child: Row(
                      children: [
                        Tooltip(
                          message: "Is it online?",
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                stateOnline = !stateOnline;
                              });
                            },
                            icon: (stateOnline)
                                ? Icon(
                                    Icons.videocam,
                                    size: 30,
                                    color: Colors.amber,
                                  )
                                : Icon(
                                    size: 30,
                                    Icons.videocam_off_outlined,
                                    color: Color.fromARGB(255, 104, 104, 104),
                                  ),
                          ),
                        ),
                        Container(width: 10,),
                        Tooltip(
                          message: "Is it for University?",
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                stateUniv = !stateUniv;
                              });
                            },
                            icon: (stateUniv)
                                ? Icon(
                                    Icons.school,
                                    size: 30,
                                    color: Colors.amber,
                                  )
                                : Icon(
                                    size: 30,
                                    Icons.school_outlined,
                                    color: Color.fromARGB(255, 104, 104, 104),
                                  ),
                          ),
                        ),
                      ],
                    )

                    /* Row(
                    children: [
                      Text("Online"),
                      Checkbox(
                        value: isChecked,
                        activeColor: Colors.green,

                        //tristate: true,
                        onChanged: (newBool) {
                          setState(() {
                            isChecked = newBool;
                          });
                        },
                      ),
                    ],
                  ),
               */
                    )
                 ),
              ],
            ),
                  

                  
              
                ),
              ),
              postss.isEmpty 
              ?SliverToBoxAdapter(
                    child: Center(
                      // Display a message or an alternative widget
                      child: Text('No posts available.'),
                    ),
                  )
              :SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    //not filter
                    if(location == null && framework==null && stateOnline==false && stateUniv==false){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          /* Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['appliedStuId'].length==0
                                            ?  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Color.fromARGB(255, 240, 105, 105)),
                                            )
                                            :IconButton(
                                              onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => showStu(postss[index]['_id'],studentinfo['ID'],studentinfo['Name'],studentinfo['img'], postss[index]['appliedStuId'])));
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Colors.greenAccent
                                              ))
                                          ),*/
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                          /*Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isFreezed']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_outlined,color: Colors.red,),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                  networkHandlerC.updateIsFreezed(avaliblepostss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_open_outlined,color: Colors.green,),
                                            )
                                          ),
                                          */
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      /* Padding(
                                        padding: const EdgeInsets.only(left: 160),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: 170,
                                                height: 30,
                                                //  color: Colors.blue,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      comments,
                                                      style: TextStyle(color: Color(0xff003566)),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )*/
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );

                    }
                    //location
                    else if(location != null && framework==null && stateOnline==false && stateUniv==false){
                      if(postss[index]['location']==location){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      /* Padding(
                                        padding: const EdgeInsets.only(left: 160),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: 170,
                                                height: 30,
                                                //  color: Colors.blue,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      comments,
                                                      style: TextStyle(color: Color(0xff003566)),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )*/
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                      }
                    }
                    //framework
                    else if(location == null && framework !=null && stateOnline==false && stateUniv==false){
                      if(postss[index]['field']==framework){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          /* Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['appliedStuId'].length==0
                                            ?  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Color.fromARGB(255, 240, 105, 105)),
                                            )
                                            :IconButton(
                                              onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => showStu(postss[index]['_id'],studentinfo['ID'],studentinfo['Name'],studentinfo['img'], postss[index]['appliedStuId'])));
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Colors.greenAccent
                                              ))
                                          ),*/
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                          /*Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isFreezed']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_outlined,color: Colors.red,),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                  networkHandlerC.updateIsFreezed(avaliblepostss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_open_outlined,color: Colors.green,),
                                            )
                                          ),
                                          */
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      /* Padding(
                                        padding: const EdgeInsets.only(left: 160),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: 170,
                                                height: 30,
                                                //  color: Colors.blue,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      comments,
                                                      style: TextStyle(color: Color(0xff003566)),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )*/
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );                        
                      }
                    }
                    //online
                    else if(location == null && framework==null && stateOnline ==true && stateUniv==false){
                      if(postss[index]['isRemotly']==stateOnline){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          /* Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['appliedStuId'].length==0
                                            ?  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Color.fromARGB(255, 240, 105, 105)),
                                            )
                                            :IconButton(
                                              onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => showStu(postss[index]['_id'],studentinfo['ID'],studentinfo['Name'],studentinfo['img'], postss[index]['appliedStuId'])));
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Colors.greenAccent
                                              ))
                                          ),*/
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                          /*Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isFreezed']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_outlined,color: Colors.red,),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                  networkHandlerC.updateIsFreezed(avaliblepostss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_open_outlined,color: Colors.green,),
                                            )
                                          ),
                                          */
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      /* Padding(
                                        padding: const EdgeInsets.only(left: 160),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: 170,
                                                height: 30,
                                                //  color: Colors.blue,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      comments,
                                                      style: TextStyle(color: Color(0xff003566)),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )*/
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );                        
                      }
                    }
                    //university
                    else if(location != null && framework==null && stateOnline==false && stateUniv==true){
                      if(postss[index]['isUni']==stateUniv){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          /* Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['appliedStuId'].length==0
                                            ?  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Color.fromARGB(255, 240, 105, 105)),
                                            )
                                            :IconButton(
                                              onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => showStu(postss[index]['_id'],studentinfo['ID'],studentinfo['Name'],studentinfo['img'], postss[index]['appliedStuId'])));
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Colors.greenAccent
                                              ))
                                          ),*/
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                          /*Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isFreezed']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_outlined,color: Colors.red,),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                  networkHandlerC.updateIsFreezed(avaliblepostss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_open_outlined,color: Colors.green,),
                                            )
                                          ),
                                          */
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      /* Padding(
                                        padding: const EdgeInsets.only(left: 160),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: 170,
                                                height: 30,
                                                //  color: Colors.blue,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      comments,
                                                      style: TextStyle(color: Color(0xff003566)),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )*/
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );                        
                      }
                    }
                    // location+framework
                    else if(location != null && framework !=null && stateOnline==false && stateUniv==false){
                      if(postss[index]['field']==framework && postss[index]['location']==location ){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          /* Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['appliedStuId'].length==0
                                            ?  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Color.fromARGB(255, 240, 105, 105)),
                                            )
                                            :IconButton(
                                              onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => showStu(postss[index]['_id'],studentinfo['ID'],studentinfo['Name'],studentinfo['img'], postss[index]['appliedStuId'])));
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Colors.greenAccent
                                              ))
                                          ),*/
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                          /*Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isFreezed']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_outlined,color: Colors.red,),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                  networkHandlerC.updateIsFreezed(avaliblepostss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_open_outlined,color: Colors.green,),
                                            )
                                          ),
                                          */
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      /* Padding(
                                        padding: const EdgeInsets.only(left: 160),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: 170,
                                                height: 30,
                                                //  color: Colors.blue,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      comments,
                                                      style: TextStyle(color: Color(0xff003566)),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )*/
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );                        
                      }
                    }    
                    //location + onlone          
                    else if(location != null && framework==null && stateOnline==true && stateUniv==false){
                      if(postss[index]['isRemotly']==stateOnline && postss[index]['location']==location ){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          /* Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['appliedStuId'].length==0
                                            ?  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Color.fromARGB(255, 240, 105, 105)),
                                            )
                                            :IconButton(
                                              onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => showStu(postss[index]['_id'],studentinfo['ID'],studentinfo['Name'],studentinfo['img'], postss[index]['appliedStuId'])));
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Colors.greenAccent
                                              ))
                                          ),*/
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                          /*Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isFreezed']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_outlined,color: Colors.red,),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                  networkHandlerC.updateIsFreezed(avaliblepostss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_open_outlined,color: Colors.green,),
                                            )
                                          ),
                                          */
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      /* Padding(
                                        padding: const EdgeInsets.only(left: 160),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: 170,
                                                height: 30,
                                                //  color: Colors.blue,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      comments,
                                                      style: TextStyle(color: Color(0xff003566)),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )*/
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );                        
                      }
                    }
                    //location+university
                    else if(location != null && framework==null && stateOnline==false && stateUniv==true){
                      if(postss[index]['isUni']==stateUniv && postss[index]['location']==location ){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          /* Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['appliedStuId'].length==0
                                            ?  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Color.fromARGB(255, 240, 105, 105)),
                                            )
                                            :IconButton(
                                              onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => showStu(postss[index]['_id'],studentinfo['ID'],studentinfo['Name'],studentinfo['img'], postss[index]['appliedStuId'])));
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Colors.greenAccent
                                              ))
                                          ),*/
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                          /*Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isFreezed']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_outlined,color: Colors.red,),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                  networkHandlerC.updateIsFreezed(avaliblepostss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_open_outlined,color: Colors.green,),
                                            )
                                          ),
                                          */
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      /* Padding(
                                        padding: const EdgeInsets.only(left: 160),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: 170,
                                                height: 30,
                                                //  color: Colors.blue,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      comments,
                                                      style: TextStyle(color: Color(0xff003566)),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )*/
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );                        
                      }
                    }
                    // framework+ online 
                    else if(location == null && framework !=null && stateOnline==true && stateUniv==false){
                      if(postss[index]['field']==framework && postss[index]['isRemotly']==stateOnline){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          /* Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['appliedStuId'].length==0
                                            ?  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Color.fromARGB(255, 240, 105, 105)),
                                            )
                                            :IconButton(
                                              onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => showStu(postss[index]['_id'],studentinfo['ID'],studentinfo['Name'],studentinfo['img'], postss[index]['appliedStuId'])));
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Colors.greenAccent
                                              ))
                                          ),*/
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                          /*Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isFreezed']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_outlined,color: Colors.red,),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                  networkHandlerC.updateIsFreezed(avaliblepostss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_open_outlined,color: Colors.green,),
                                            )
                                          ),
                                          */
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      /* Padding(
                                        padding: const EdgeInsets.only(left: 160),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: 170,
                                                height: 30,
                                                //  color: Colors.blue,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      comments,
                                                      style: TextStyle(color: Color(0xff003566)),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )*/
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );                       
                      }
                    }
                    // framework+ university 
                    else if(location == null && framework !=null && stateOnline==false && stateUniv==true){
                      if(postss[index]['field']==framework && postss[index]['isUni']==stateUniv){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          /* Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['appliedStuId'].length==0
                                            ?  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Color.fromARGB(255, 240, 105, 105)),
                                            )
                                            :IconButton(
                                              onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => showStu(postss[index]['_id'],studentinfo['ID'],studentinfo['Name'],studentinfo['img'], postss[index]['appliedStuId'])));
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Colors.greenAccent
                                              ))
                                          ),*/
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                          /*Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isFreezed']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_outlined,color: Colors.red,),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                  networkHandlerC.updateIsFreezed(avaliblepostss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_open_outlined,color: Colors.green,),
                                            )
                                          ),
                                          */
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      /* Padding(
                                        padding: const EdgeInsets.only(left: 160),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: 170,
                                                height: 30,
                                                //  color: Colors.blue,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      comments,
                                                      style: TextStyle(color: Color(0xff003566)),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )*/
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );                        
                      }
                    }
                    // online + university 
                    else if(location == null && framework ==null && stateOnline==true && stateUniv==true){
                      if(postss[index]['isRemotly']==stateOnline && postss[index]['isUni']==stateUniv){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          /* Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['appliedStuId'].length==0
                                            ?  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Color.fromARGB(255, 240, 105, 105)),
                                            )
                                            :IconButton(
                                              onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => showStu(postss[index]['_id'],studentinfo['ID'],studentinfo['Name'],studentinfo['img'], postss[index]['appliedStuId'])));
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Colors.greenAccent
                                              ))
                                          ),*/
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                          /*Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isFreezed']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_outlined,color: Colors.red,),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                  networkHandlerC.updateIsFreezed(avaliblepostss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_open_outlined,color: Colors.green,),
                                            )
                                          ),
                                          */
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      /* Padding(
                                        padding: const EdgeInsets.only(left: 160),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: 170,
                                                height: 30,
                                                //  color: Colors.blue,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      comments,
                                                      style: TextStyle(color: Color(0xff003566)),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )*/
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );                       
                      }
                    }
                    // location + framework +online
                    else if(location != null && framework!=null && stateOnline==true && stateUniv==false){
                      if(postss[index]['field']==framework && postss[index]['location']==location && postss[index]['isRemotly']==stateOnline ){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          /* Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['appliedStuId'].length==0
                                            ?  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Color.fromARGB(255, 240, 105, 105)),
                                            )
                                            :IconButton(
                                              onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => showStu(postss[index]['_id'],studentinfo['ID'],studentinfo['Name'],studentinfo['img'], postss[index]['appliedStuId'])));
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Colors.greenAccent
                                              ))
                                          ),*/
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                          /*Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isFreezed']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_outlined,color: Colors.red,),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                  networkHandlerC.updateIsFreezed(avaliblepostss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_open_outlined,color: Colors.green,),
                                            )
                                          ),
                                          */
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      /* Padding(
                                        padding: const EdgeInsets.only(left: 160),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: 170,
                                                height: 30,
                                                //  color: Colors.blue,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      comments,
                                                      style: TextStyle(color: Color(0xff003566)),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )*/
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );                        
                      }
                    }
                    // loction + framework +university
                    else if(location != null && framework !=null && stateOnline==false && stateUniv==true){
                      if(postss[index]['field']==framework && postss[index]['location']==location && postss[index]['isUni']==stateUniv ){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          /* Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['appliedStuId'].length==0
                                            ?  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Color.fromARGB(255, 240, 105, 105)),
                                            )
                                            :IconButton(
                                              onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => showStu(postss[index]['_id'],studentinfo['ID'],studentinfo['Name'],studentinfo['img'], postss[index]['appliedStuId'])));
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Colors.greenAccent
                                              ))
                                          ),*/
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                          /*Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isFreezed']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_outlined,color: Colors.red,),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                  networkHandlerC.updateIsFreezed(avaliblepostss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_open_outlined,color: Colors.green,),
                                            )
                                          ),
                                          */
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      /* Padding(
                                        padding: const EdgeInsets.only(left: 160),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: 170,
                                                height: 30,
                                                //  color: Colors.blue,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      comments,
                                                      style: TextStyle(color: Color(0xff003566)),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )*/
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );                        
                      }
                    }
                    // loction + online +university
                    else if(location != null && framework==null && stateOnline==true && stateUniv==true){
                      if(postss[index]['isRemotly']==stateOnline && postss[index]['location']==location && postss[index]['isUni']==stateUniv ){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          /* Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['appliedStuId'].length==0
                                            ?  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Color.fromARGB(255, 240, 105, 105)),
                                            )
                                            :IconButton(
                                              onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => showStu(postss[index]['_id'],studentinfo['ID'],studentinfo['Name'],studentinfo['img'], postss[index]['appliedStuId'])));
                                              },
                                              icon: Icon(Icons.visibility_outlined,color: Colors.greenAccent
                                              ))
                                          ),*/
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                          /*Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isFreezed']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_outlined,color: Colors.red,),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                  networkHandlerC.updateIsFreezed(avaliblepostss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.lock_open_outlined,color: Colors.green,),
                                            )
                                          ),
                                          */
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                      /* Padding(
                                        padding: const EdgeInsets.only(left: 160),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: 170,
                                                height: 30,
                                                //  color: Colors.blue,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      comments,
                                                      style: TextStyle(color: Color(0xff003566)),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        ),
                                      )*/
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );                        
                      }
                    }
                    // framework + online +university
                    else if(location == null && framework!=null && stateOnline==true && stateUniv==true){
                      if(postss[index]['isRemotly']==stateOnline && postss[index]['field']==framework && postss[index]['isUni']==stateUniv ){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),
                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  //  color: Colors.pink,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        /* width: 137,
                                        height: 30.0,*/
                                        // color: Colors.yellow,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*  width: 137,
                                        height: 30.0,*/
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        /*   width: 137,
                                        height: 30.0,*/
                                        //color: Colors.yellow,
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );                        
                      }
                    }
                    // loction + framework + online +university
                    else if(location != null && framework!=null && stateOnline==true && stateUniv==true){
                      if(postss[index]['location']==location && postss[index]['isRemotly']==stateOnline && postss[index]['field']==framework && postss[index]['isUni']==stateUniv ){
                      return Card(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(height: 20,),
                                Container(
                                  width: MediaQuery.of(context).size.width,//400.0,
                                  height: 50.0,
                                  // color: Colors.amber,
                                  child: Row(
                                    children: <Widget>[
                                    // Column(
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                        //children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                                            child: Container(
                                              width: 50.0,
                                              height: 50.0,
                                              child: Container(
                                                width: 50.0,
                                                height: 50.0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(40.0),
                                                      border: Border.all(
                                                          //    color: Color(0xff003566),
                                                          style: BorderStyle.solid,
                                                          color: Colors.grey.shade400),
                                                    image: DecorationImage(
                                                        image: NetworkImage("http://localhost:5000/"+avaliblepostss[index]['cimg']),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        //],
                                      //),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                width: 260.0,
                                                height: 20.0,
                                                // color: Colors.pink,
                                                child: Text(
                                                  avaliblepostss[index]['cname'],
                                                  style: TextStyle(
                                                    fontSize: 17.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(left: 10, top: 5),
                                                width: 200.0,
                                                height: 30.0,
                                                // color: Colors.purple,
                                                child: Text(
                                                
                                                  avaliblepostss[index]['postDate']+"    "+avaliblepostss[index]['location'],
                                                  style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.blueGrey[500]),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(children: [
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isRemotly']
                                            ?  IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                                            )
                                            :  IconButton(                         
                                              onPressed: () {
                                                setState(() {
                                                  print(avaliblepostss[index]['_id']);
                                                // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                                  //super.initState();                                
                                                });
                                              },
                                              icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                                            )
                                          ),
                                          Container(
                                            width: 30.0,
                                            height: 30.0,
                                            // color: Colors.brown,
                                            child : avaliblepostss[index]['isUni']
                                            ?  IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                                              ))
                                            :  IconButton(                         
                                              onPressed: () {
                                              /* setState(() {
                                                networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                                                });*/
                                              },
                                              icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                                            )
                                          ),

                                        ],)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  // height: 480.0,
                                  //  color: Colors.amber,
                                  child: Column(
                                    children: [
                                      SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Center(
                                            child: Container(
                                              //   height: 80.0,
                                              width: MediaQuery.of(context).size.width,
                                              padding: EdgeInsets.all(20),
                                              //  color: Colors.blue,
                                              child: ReadMoreText(
                                                avaliblepostss[index]['postContent'],
                                                trimLines: 3,
                                                style: TextStyle(fontSize: 15),
                                                trimCollapsedText: '... Read More',
                                                trimExpandedText: '... Read Less',
                                                trimMode: TrimMode.Line,
                                                textAlign: TextAlign.justify,
                                                lessStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                                moreStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ),
                                          )

                                          // color: Colors.blue,

                                          ),
                                      Container(
                                        width: 411.0,
                                        height: 380.0,
                                        decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage("http://localhost:5000/"+ avaliblepostss[index]['postImg']),
                                          fit: BoxFit.cover,
                                        )),

                                        //  color: Color.fromARGB(255, 243, 117, 45),
                                      )
                                  
                                    ],
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  // color: Colors.green,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              width: 80,
                                              height: 30,
                                              //color: Colors.blue,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Color(0xff003566),
                                                    size: 17,
                                                  ),
                                                  Text(
                                                    avaliblepostss[index]['appliedStuId'].length.toString(),
                                                    style: TextStyle(color: Color(0xff003566)),
                                                  )
                                                ],
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(child: Divider()),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 30.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if(studentinfo['available']==false){
                                                  _showDialog(context,'You already In Training , ypu cant applay for any training until you finish current training.');
                                                }
                                                else if(studentinfo['request']==true && studentinfo['available']==true){
                                                  _showDialog(context,'You applay a training please wait for company reply .');
                                                }                              
                                                else if(studentinfo['available']==true && avaliblepostss[index]['isUni']==true && studentinfo['universityTraining']==true){
                                                  _showDialog(context,'You already Finshed Your University Training .');
                                                }                                                
                                                else if(studentinfo['available'] || studentinfo['request']==false ){
                                                setState(() {
                                                isCliked=true;
                                                ss=avaliblepostss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                                ss.add(studentinfo['RegNum']);
                                                });
                                                networkHandlerC.updateapllidStuId( avaliblepostss[index]['_id'], ss);
                                                networkHandlers.updatepostidstud(studentinfo['RegNum'],avaliblepostss[index]['_id'],true);
                                                }

                                              },
                                              iconSize: 25,
                                              icon: Icon(Icons.check),
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),
                                              //color: isCliked?  Color(0xffffc300):Color.fromARGB(255, 4, 57, 97),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                "Request",
                                                style: TextStyle(
                                              color: studentinfo['request']
                                              ? studentinfo['postid']== avaliblepostss[index]['_id']
                                              ?  Color(0xffffc300)
                                              : Color.fromARGB(255, 105, 103, 98)
                                              : Color.fromARGB(255, 4, 57, 97),                                                  
                                                    //color: isCliked?  Color(0xffffc300) :Color.fromARGB(255, 4, 57, 97),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: postss[index]['isUni']
                                              ? Icon(Icons.date_range_sharp)
                                              : Icon(Icons.timelapse),
                                              color: Color(0xff003566),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                                                postss[index]['isUni']
                                                ? postss[index]['semester']
                                                :  postss[index]['hours'].toString(),
                                                style: TextStyle(
                                                    color:  Color.fromARGB(255, 21, 28, 82),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {},
                                              iconSize: 20,
                                              icon: Icon(Icons.lock_clock_outlined),
                                              color: Colors.red,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 6),
                                              child: Text(
                          
                                                avaliblepostss[index]['lockDate'],
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );                       
                      }
                    }

                                    

                  
                  },
                  childCount: avaliblepostss.length,
                ),
              ),
            ]
      )
       
      : Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    ),);
    }
}
 

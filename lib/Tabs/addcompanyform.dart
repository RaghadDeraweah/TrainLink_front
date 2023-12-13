import 'dart:ui' as ui;

import 'package:flutter/material.dart';
//import 'package:open_file/open_file.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

String? name = "Flutter Fall23";
String? members;

class AddCompanyform extends StatelessWidget {
  late Map<String,dynamic> groupinfo;
  late String CID;
  late String groupid;
  late String postid;
  late String StuId;
  late String StuName;
  late String StuImg;
 // late List<dynamic> studentsid;

  //howStu(post, companyinfo, companyinfo2, companyinfo3);
  AddCompanyform(Map<String,dynamic> groupinfo,String CID ,String groupid,String StuId, String StuName,String StuImg, String postid){
    super.key;
    this.groupinfo=groupinfo;
    this.CID=CID;
    this.groupid=groupid;
    this.StuId=StuId;
    this.StuName=StuName;
    this.StuImg=StuImg;
    this.postid=postid;
   
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
            "Add Form",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: formpage( this.groupinfo,this.CID,this.groupid,this.StuId,this.StuName,this.StuImg,this.postid),
      ),
    );
  }
}
class formpage extends StatefulWidget {
 late Map<String,dynamic> groupinfo;
  late String CID;
  late String groupid;
  late String StuId;
  late String StuName;
  late String StuImg;
  late  String postid;

  //howStu(post, companyinfo, companyinfo2, companyinfo3);
  formpage(Map<String,dynamic> groupinfo,String CID ,String groupid,String StuId, String StuName,String StuImg, String postid){
    super.key;
    this.groupinfo=groupinfo;
    this.CID=CID;
    this.groupid=groupid;
    this.StuId=StuId;
    this.StuName=StuName;
    this.StuImg=StuImg;
    this.postid=postid;
  }


  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<formpage> {
  bool isDataReady=false;
  bool isuni=false;
    double _sliderValue = 0.0;
    RangeValues _currentRangeValues = const RangeValues(0, 100);
    int mark=0;
    double q1 = 100.0;
    double q2 = 100.0;
    double q3 = 100.0;
    double q4 = 100.0;
  int hours=0;
  int taskscount=0;
  int reportscount=0;
  List<Map<String,dynamic>> stuinfo=[];
  List<Map<String,dynamic>> postss=[];
  Map<String,dynamic> student={};
  Map<String,dynamic> companyinfo={};
  Map<String,dynamic> postiii={};
  GlobalKey<FormState>  addform= GlobalKey();
  final networkHandlerC = NetworkHandlerC();
  final networkHandler = NetworkHandlerS();
Future<void> fetchData() async {
  try {
    companyinfo = await networkHandlerC.fetchCompanyData(widget.CID);
    print(companyinfo);
   postss = await networkHandlerC.fetchPosts(widget.CID!);
    for(int i=0;i<postss.length;i++){
          print("inside loop");
          print("widget.postid"+widget.postid);
          print("post "+postss[i]['_id']);
          if(postss[i]['_id']==widget.postid){
              setState(() {
                postiii=postss[i];
                print(postiii);
              });
              if(postss[i]['isUni']==true){
              print("post is uni");
              setState(() {
                isuni=true;
              });
              }
          }
          }
    student = await networkHandler.fetchStudent(widget.StuId);
    var reportslist = await networkHandlerC.getReportsStudent(widget.groupid,widget.StuId);
    setState(() {
      reportscount=reportslist.length;
    });
      for (var map in reportslist) {
      print("inside groups");
      map.forEach(
        (key, value) {
          if(key=="actualhours"){
            setState(() {
             hours+=int.parse(value);
            print(hours);
            });
          }
        });
        }
    var tasks= await networkHandlerC.gettasksubmissionsStu(widget.groupid,widget.StuId);
    setState(() {
      taskscount=tasks.length;
    });
    //gettasksubmissionsStu
    /*Map<String, dynamic> temp = {
      "id_status": false,
      "RegNum": sinfo['RegNum'],
      "sname": sinfo['fname'] + " " + sinfo['lname'],
      "img": sinfo['img'],
      "cv":sinfo['cv'],

    };*/
 
  

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
    // TODO: implement build
    return Scaffold(
      body: isDataReady
      ? SingleChildScrollView(
      child :Column(children: [
        Card(
            
            margin:EdgeInsets.fromLTRB(2, 7, 2, 5),
            color: ui.Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.amber),
            borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
          ),
          elevation: 5,
          child: Column(
          children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          Container(
            margin:EdgeInsets.only(top: 20,left: 30, right: 20),
            padding: EdgeInsets.all(10),
           // margin: EdgeInsets.only(right: 20),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                border: Border.all(color: Colors.amber),
                image: DecorationImage(
                    image:NetworkImage("http://localhost:5000/"+widget.StuImg),
                    fit: BoxFit.cover
                    )
               )
             ),
          Container(
            alignment: Alignment.topRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(widget.StuName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Container(height: 15,),
              Text("Major: "+student['Major'],style: TextStyle(color: Colors.grey,fontSize: 15,fontWeight: FontWeight.w600),),

            ],),
          ),
          ],),
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(top: 20),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
            color: Colors.amber
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Submited Reports : $reportscount",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),
                Container(height: 10,),
                Text("Submited Tasks : $taskscount",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),
                Container(height: 10,),
                Text("Completed Hours : $hours",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),
              ],
            ),
          ),
      ])
        ),
        Form(child: Column(
          children: [
            Container(height: 30,),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("First Question",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q1,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q1 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q1.toInt()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ),
                  Container(height: 20,),
                  Text("Second Question",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q2,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q2 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q2.toInt()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ),
                  Container(height: 20,),
                   Text("Third Question",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q3,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q3 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q3.toInt()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ),
                  Container(height: 20,),
                  Text("Forth Question",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q4,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q4 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q4.toInt()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ),
                  Container(height: 20,),
                  Container(
                    //color: Color.fromARGB(255 ,248, 154, 0),
                  width: 411,
                  height: 50,
                   //margin:EdgeInsets.fromLTRB(38, 20, 1, 10),
                  alignment: Alignment.center,
                 child: ButtonTheme(
                  minWidth: 200,
                  height: 40,
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
                  child: MaterialButton(onPressed:() {
                    mark=((q1+q2+q3+q4)/4).toInt();
                    print("Mark=$mark");
                    print(reportscount);
                   networkHandlerC.addcompanyform(widget.groupid,widget.CID,widget.StuId,widget.StuName,widget.StuImg,hours.toString(),q1.toString(),q2.toString(),q3.toString(),q4.toString(),mark,reportscount);
                    if(!isuni){
                      Map<String,dynamic> temp={
                        "groupid":widget.groupid,
                        "isUni":false,
                        "CID": widget.CID,
                        "cname": widget.groupinfo['cname'],
                        "groupname":widget.groupinfo['groupname'],
                        "cimg":widget.groupinfo['cimg'],
                        "framework":postiii['field'],                        
                        "mark":mark,
                        "hours":postiii['hours'],
                        "StartDate":widget.groupinfo['StartDate'],
                        "EndDate":widget.groupinfo['EndDate'],
                        "isRated":false,
                      };
                      Map<String,dynamic> trinee={                        
                        "RegNum":widget.StuId,
                        "name":widget.StuName,
                        "img": widget.StuImg,
                      };                      
                      student['finishedGroups'].add(temp);
                      companyinfo['trainee'].add(trinee);
                      networkHandlerC.updatetrainee(widget.CID,  companyinfo['trainee']);
                      networkHandler.updatefinishedcourses(widget.StuId, student['finishedGroups']);
                    }
                    else{
                      Map<String,dynamic> trinee={                        
                        "RegNum":widget.StuId,
                        "name":widget.StuName,
                        "img": widget.StuImg,
                      };                      
                      companyinfo['trainee'].add(trinee);
                      networkHandlerC.updatetrainee(widget.CID,  companyinfo['trainee']);                      
                    }
                  },
                  textColor: Colors.white,
                  color: Color.fromARGB(255 ,248, 154, 0),
                  child: Text("Submit",style: TextStyle(fontSize: 18,color: Colors.white),),
                  ),),)

                ],
              ),
            ),

          ],
        ),),
      ],)
      )
      : Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }


}
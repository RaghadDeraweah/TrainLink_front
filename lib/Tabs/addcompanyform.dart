import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:open_file/open_file.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class AddCompanyform extends StatefulWidget {
  final VoidCallback onDataRefresh;
  late Map<String,dynamic> groupinfo;
  late String CID;
  late String groupid;
  late String postid;
  late String StuId;
  late String StuName;
  late String StuImg;

  //howStu(post, companyinfo, companyinfo2, companyinfo3);
    AddCompanyform({required this.groupinfo ,required this.CID ,required this.groupid,required this.StuId, required this.StuName,required this.StuImg, required this.postid,required this.onDataRefresh});


  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<AddCompanyform> {
  bool s1 = false, s2 = false, s3 = false, s4 = false, s5 = false;
  int rate=0;
    String _SOT1 = '';
    String _SOT2 = '';
    String _SOT3 = '';
    String _SOT4 = '';
  TextEditingController _T5 = TextEditingController();
  TextEditingController _T6 = TextEditingController();
  TextEditingController _T7 = TextEditingController(); 
  TextEditingController _T8 = TextEditingController();
  TextEditingController _T9 = TextEditingController();
  TextEditingController _T10 = TextEditingController(); 
  TextEditingController _T11 = TextEditingController();

  TextEditingController _S1 = TextEditingController();
  TextEditingController _S2 = TextEditingController();
  TextEditingController _S3 = TextEditingController(); 
  TextEditingController _S4 = TextEditingController();
 
  bool isDataReady=false;
  bool isuni=false;
    double _sliderValue = 0.0;
    RangeValues _currentRangeValues = const RangeValues(0, 100);
    int mark=0;
    double q1 = 100.0;
    double q2 = 100.0;
    double q3 = 100.0;
    double q4 = 100.0;
    double q5 = 100.0;
    double q6 = 100.0;
    double q7 = 100.0;
    double q8 = 100.0;
    double q9 = 100.0;
    double q10 = 100.0;
    double q11 = 100.0;
    double q12 = 100.0;
    double q13 = 100.0;
    double q14 = 100.0;
    double q15 = 100.0;
    double q16 = 100.0;    
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
  bool containerVisible1 = false;
  bool containerVisible2 = false;
  bool containerVisible3 = false;
  
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
      appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            color: const Color(0xffff003566),
            icon: const Icon(Icons.arrow_back),
            iconSize: 30,
            onPressed: () {
              widget.onDataRefresh();
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
                widget.groupinfo['isUni']
                ? Text("Submited Reports : $reportscount",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),)
                :Container(height: 1,),
                Container(height: 10,),
                Text("Submited Tasks : $taskscount",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),
                widget.groupinfo['isUni']
                ?Container(height: 10,)
                :Container(height: 5,),
                widget.groupinfo['isUni']
                ?Text("Completed Hours : $hours",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),)
                :Container(height: 2,),
              ],
            ),
          ),
      ])
        ),
        Form(child: Column(
          children: [
            Container(height: 5,),
            widget.groupinfo['isUni']
            ? Container(
              margin: EdgeInsets.all(8),
              child: Column(children: [
               // Container(height: 5,),
                Card(
                      child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        Icon(Icons.portrait_sharp,color: ui.Color.fromARGB(255, 126, 126, 126),size: 25,),
                        Text(
                                "  Student Evaluation",
                                style: TextStyle(
                                  color: ui.Color.fromARGB(255, 126, 126, 126) ,
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),

                      ],),
                      IconButton(
                      onPressed:() {
                      setState(() {
                        print("yes clicked");
                        containerVisible1 = !containerVisible1;
                      });
                      }, 
                      color:  ui.Color.fromARGB(255, 126, 126, 126),
                      icon:  containerVisible1
                                  ?Icon(Icons.keyboard_arrow_up_sharp)
                                  :Icon(Icons.keyboard_arrow_down_sharp),
                      ),
                   
                  ],),
                     ),
                Container(
                padding: EdgeInsets.only(left: 10),
                width: 400,
                height: containerVisible1
                ?400
                :5,
                //margin: EdgeInsets.only(left:10),
              // padding: EdgeInsets.only(top: 20,left: 15,bottom: 10,right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:  ui.Color.fromARGB(255, 255, 251, 251)
                ),
                child: SingleChildScrollView(
                  child: //Column(children: [
                   /* Card(
                      child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        Icon(Icons.portrait_sharp,color: ui.Color.fromARGB(255, 126, 126, 126),size: 25,),
                        Text(
                                "Student Evaluation",
                                style: TextStyle(
                                  color: ui.Color.fromARGB(255, 126, 126, 126) ,
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),

                      ],),
                      IconButton(
                      onPressed:() {
                      setState(() {
                        print("yes clicked");
                        containerVisible1 = !containerVisible1;
                      });
                      }, 
                      color:  ui.Color.fromARGB(255, 126, 126, 126),
                      icon:  containerVisible1
                                  ?Icon(Icons.keyboard_arrow_up_sharp)
                                  :Icon(Icons.keyboard_arrow_down_sharp),
                      ),
                   
                  ],),
                     ),*/
                    Visibility(
                      visible: containerVisible1,
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //q1
                        Text("General trainee behaviour",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
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
                        //Container(height: 5,),
                        //q2
                        Text("Commitment to attend",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
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
                        //Container(height: 5,),
                        //q3
                        Text("Performance and motivation",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
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
                        //Container(height: 5,),
                        //q4
                        Text("Ability to follow instructions",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
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
                        //Container(height: 5,),
                        //q5
                        Text("Initiative",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Slider(
                          thumbColor: Colors.indigo,
                          activeColor: Colors.indigo,
                          value: q5,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              q5 = value;
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 25),
                          alignment: Alignment.topRight,
                      child: Text(
                          textAlign: TextAlign.right ,
                          'Mark : ${q5.toInt()}',
                          style: TextStyle(fontSize: 12),
                        ),
                        ),                 
                        //Container(height: 5,),
                        //q6
                        Text("Desire for continuous development and learning",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Slider(
                          thumbColor: Colors.indigo,
                          activeColor: Colors.indigo,
                          value: q6,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              q6 = value;
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 25),
                          alignment: Alignment.topRight,
                      child: Text(
                          textAlign: TextAlign.right ,
                          'Mark : ${q6.toInt()}',
                          style: TextStyle(fontSize: 12),
                        ),
                        ),                 
                        //Container(height: 5,),
                        //q7
                        Text("Written communication skills",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Slider(
                          thumbColor: Colors.indigo,
                          activeColor: Colors.indigo,
                          value: q7,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              q7 = value;
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 25),
                          alignment: Alignment.topRight,
                      child: Text(
                          textAlign: TextAlign.right ,
                          'Mark : ${q7.toInt()}',
                          style: TextStyle(fontSize: 12),
                        ),
                        ),                 
                        //Container(height: 5,),
                        //q8
                        Text("Verbal communication skills",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Slider(
                          thumbColor: Colors.indigo,
                          activeColor: Colors.indigo,
                          value: q8,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              q8 = value;
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 25),
                          alignment: Alignment.topRight,
                      child: Text(
                          textAlign: TextAlign.right ,
                          'Mark : ${q8.toInt()}',
                          style: TextStyle(fontSize: 12),
                        ),
                        ),                                     
                        //Container(height: 5,),
                        //q9
                        Text("Technical competence",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Slider(
                          thumbColor: Colors.indigo,
                          activeColor: Colors.indigo,
                          value: q9,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              q9 = value;
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 25),
                          alignment: Alignment.topRight,
                      child: Text(
                          textAlign: TextAlign.right ,
                          'Mark : ${q9.toInt()}',
                          style: TextStyle(fontSize: 12),
                        ),
                        ),
                        //Container(height: 10,),
                        //q10
                        Text("work perfiction",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Slider(
                          thumbColor: Colors.indigo,
                          activeColor: Colors.indigo,
                          value: q10,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              q10 = value;
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 25),
                          alignment: Alignment.topRight,
                      child: Text(
                          textAlign: TextAlign.right ,
                          'Mark : ${q10.toInt()}',
                          style: TextStyle(fontSize: 12),
                        ),
                        ),  
                        //Container(height: 10,),
                        //q11
                        Text("Collaborative skills",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Slider(
                          thumbColor: Colors.indigo,
                          activeColor: Colors.indigo,
                          value: q11,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              q11 = value;
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 25),
                          alignment: Alignment.topRight,
                      child: Text(
                          textAlign: TextAlign.right ,
                          'Mark : ${q11.toInt()}',
                          style: TextStyle(fontSize: 12),
                        ),
                        ), 
                        //Container(height: 10,),
                        //q12
                        Text("Ability to solve problems",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Slider(
                          thumbColor: Colors.indigo,
                          activeColor: Colors.indigo,
                          value: q12,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              q12 = value;
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 25),
                          alignment: Alignment.topRight,
                      child: Text(
                          textAlign: TextAlign.right ,
                          'Mark : ${q12.toInt()}',
                          style: TextStyle(fontSize: 12),
                        ),
                        ),                                                                       
                        //Container(height: 10,),
                        //q13
                        Text("Administrative and organizational skills",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Slider(
                          thumbColor: Colors.indigo,
                          activeColor: Colors.indigo,
                          value: q13,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              q13 = value;
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 25),
                          alignment: Alignment.topRight,
                      child: Text(
                          textAlign: TextAlign.right ,
                          'Mark : ${q13.toInt()}',
                          style: TextStyle(fontSize: 12),
                        ),
                        ),                  
                        //Container(height: 10,),
                        //q14
                        Text("The trainee commitment to ethics and professional responsibilities",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Slider(
                          thumbColor: Colors.indigo,
                          activeColor: Colors.indigo,
                          value: q14,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              q14 = value;
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 25),
                          alignment: Alignment.topRight,
                      child: Text(
                          textAlign: TextAlign.right ,
                          'Mark : ${q14.toInt()}',
                          style: TextStyle(fontSize: 12),
                        ),
                        ), 
                      // Container(height: 10,),
                      //q15
                        Text("Acquire design skill",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Slider(
                          thumbColor: Colors.indigo,
                          activeColor: Colors.indigo,
                          value: q15,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              q15 = value;
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 25),
                          alignment: Alignment.topRight,
                      child: Text(
                          textAlign: TextAlign.right ,
                          'Mark : ${q15.toInt()}',
                          style: TextStyle(fontSize: 12),
                        ),
                        ),                  
                        //Container(height: 10,),
                        //q16
                        Text("The ability to analyze information and use it appropriately",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Slider(
                          thumbColor: Colors.indigo,
                          activeColor: Colors.indigo,
                          value: q16,
                          min: 0,
                          max: 100,
                          onChanged: (value) {
                            setState(() {
                              q16 = value;
                            });
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 25),
                          alignment: Alignment.topRight,
                      child: Text(
                          textAlign: TextAlign.right ,
                          'Mark : ${q16.toInt()}',
                          style: TextStyle(fontSize: 12),
                        ),
                        ),                  



                      ],
                    ),
                    ),
                  //],),

                ),
                ),
                Container(height: 5,),
                Card(
                      child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        Icon(Icons.pending_actions_rounded,color: ui.Color.fromARGB(255, 126, 126, 126),size: 25,),
                        Text(
                                "  Training Evaluation",
                                style: TextStyle(
                                  color: ui.Color.fromARGB(255, 126, 126, 126) ,
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),

                      ],),
                      IconButton(
                      onPressed:() {
                      setState(() {
                        print("yes clicked");
                        containerVisible2 = !containerVisible2;
                      });
                      }, 
                      color:  ui.Color.fromARGB(255, 126, 126, 126),
                      icon:  containerVisible2
                                  ?Icon(Icons.keyboard_arrow_up_sharp)
                                  :Icon(Icons.keyboard_arrow_down_sharp),
                      ),
                   
                  ],),
                     ),
                Container(
                padding: EdgeInsets.only(left: 10),
                width: 400,
                height: containerVisible2
                ?400
                :5,
                //margin: EdgeInsets.only(left:10),
              // padding: EdgeInsets.only(top: 20,left: 15,bottom: 10,right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:  ui.Color.fromARGB(255, 255, 251, 251)
                ),
                child: SingleChildScrollView(
                  child:// Column(children: [
                    
                    Visibility(
                      visible: containerVisible2,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text("During the internship, was there an improvement in the student's written and verbal skills?",style: TextStyle(color: const ui.Color.fromARGB(255, 36, 36, 36),fontSize: 15,fontWeight: FontWeight.w600),),
                        Row(
                            children: [
                              Expanded( 
                              flex: 1,
                              child:RadioListTile(
                                selectedTileColor: Colors.amber,
                                activeColor: Colors.amber,
                                title: Text('Yes',
                                    style: GoogleFonts.salsa(color:ui.Color.fromARGB(255, 0, 0, 0),fontSize: 15,fontWeight: FontWeight.w600)),
                                value: 'Yes',
                                groupValue: _SOT1,
                                onChanged: (value) {
                                  setState(() {
                                    _SOT1 = value!;
                                  });
                                },
                              ),),
                              Expanded(
                                flex: 1,
                              child:RadioListTile(
                                selectedTileColor: Colors.amber,
                                activeColor: Colors.amber,
                                title:
                                    Text('No', style: GoogleFonts.salsa(color:ui.Color.fromARGB(255, 0, 0, 0),fontSize: 15,fontWeight: FontWeight.w600)),
                                value: 'No',
                                groupValue: _SOT1,
                                onChanged: (value) {
                                  setState(() {
                                    _SOT1 = value!;
                                  });
                                },
                              ),),
                            ],
                          ),

                        Text("During the internship, was there a significant improvement in the student's ability to organize work?",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
                        Row(
                            children: [
                              Expanded( 
                              flex: 1,
                              child:RadioListTile(
                                selectedTileColor: Colors.amber,
                                activeColor: Colors.amber,
                                title: Text('Yes',
                                    style: GoogleFonts.salsa(color:ui.Color.fromARGB(255, 0, 0, 0),fontSize: 15,fontWeight: FontWeight.w600)),
                                value: 'Yes',
                                groupValue: _SOT2,
                                onChanged: (value) {
                                  setState(() {
                                    _SOT2 = value!;
                                  });
                                },
                              ),),
                              Expanded(
                                flex: 1,
                              child:RadioListTile(
                                selectedTileColor: Colors.amber,
                                activeColor: Colors.amber,
                                title:
                                    Text('No', style: GoogleFonts.salsa(color:ui.Color.fromARGB(255, 0, 0, 0),fontSize: 15,fontWeight: FontWeight.w600)),
                                value: 'No',
                                groupValue: _SOT2,
                                onChanged: (value) {
                                  setState(() {
                                    _SOT2 = value!;
                                  });
                                },
                              ),),
                            ],
                          ),
                       Text("Did the student trainee meet your expectations?",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
                       Row(
                            children: [
                              Expanded( 
                              flex: 1,
                              child:RadioListTile(
                                selectedTileColor: Colors.amber,
                                activeColor: Colors.amber,
                                title: Text('Yes',
                                    style: GoogleFonts.salsa(color:ui.Color.fromARGB(255, 0, 0, 0),fontSize: 15,fontWeight: FontWeight.w600)),
                                value: 'Yes',
                                groupValue: _SOT3,
                                onChanged: (value) {
                                  setState(() {
                                    _SOT3 = value!;
                                  });
                                },
                              ),),
                              Expanded(
                                flex: 1,
                              child:RadioListTile(
                                selectedTileColor: Colors.amber,
                                activeColor: Colors.amber,
                                title:
                                    Text('No', style: GoogleFonts.salsa(color:ui.Color.fromARGB(255, 0, 0, 0),fontSize: 15,fontWeight: FontWeight.w600)),
                                value: 'No',
                                groupValue: _SOT3,
                                onChanged: (value) {
                                  setState(() {
                                    _SOT3 = value!;
                                  });
                                },
                              ),),
                            ],
                          ),
                        Text("What is your overall assessment of An-Najah University students?",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  s1 = true;
                                  s2 = false;
                                  s3 = false;
                                  s4 = false;
                                  s5 = false;
                                  rate=1;
                                  _T5.text=rate.toString();
                                });
                              },
                              icon: (s1)
                                  ? Icon(
                                      Icons.star,
                                      color: Color(0xffffc300),
                                    )
                                  : Icon(Icons.star_border),
                              iconSize: 20,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  s1 = true;
                                  s2 = true;
                                  s3 = false;
                                  s4 = false;
                                  s5 = false;
                                  rate=2;
                                  _T5.text=rate.toString();
                                });
                              },
                              icon: (s2)
                                  ? Icon(
                                      Icons.star,
                                      color: Color(0xffffc300),
                                    )
                                  : Icon(Icons.star_border),
                              iconSize: 20,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  s1 = true;
                                  s2 = true;
                                  s3 = true;
                                  s4 = false;
                                  s5 = false;
                                  rate=3;
                                  _T5.text=rate.toString();
                                });
                              },
                              icon: (s3)
                                  ? Icon(
                                      Icons.star,
                                      color: Color(0xffffc300),
                                    )
                                  : Icon(Icons.star_border),
                              iconSize: 20,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  s1 = true;
                                  s2 = true;
                                  s3 = true;
                                  s4 = true;
                                  s5 = false;
                                  rate=4;
                                  _T5.text=rate.toString();
                                });
                              },
                              icon: (s4)
                                  ? Icon(
                                      Icons.star,
                                      color: Color(0xffffc300),
                                    )
                                  : Icon(Icons.star_border),
                              iconSize: 20,
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  s1 = true;
                                  s2 = true;
                                  s3 = true;
                                  s4 = true;
                                  s5 = true;
                                  rate=5;
                                  _T5.text=rate.toString();
                                });
                              },
                              icon: (s5)
                                  ? Icon(
                                      Icons.star,
                                      color: Color(0xffffc300),
                                    )
                                  : Icon(Icons.star_border),
                              iconSize: 20,
                            ),
                          ],
                        ),
                        Text("Feedback on your review ",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
                       Container(
                          height: 70,
                           // margin: EdgeInsets.only(left: 15,right: 10),
                          child: 
                          TextFormField(
                            maxLines: 2,
                           // keyboardType: TextInputType.number,
                            controller: _T6,
                            onChanged: (value) {
                              setState(() {
                              _T6.text=value;
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 3,color: Colors.amber)),
                              //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                              alignLabelWithHint:true,hintText: "Write your Feedback here",),),
                          ),
                        Text("If you have job opportunities and do you recommend hiring a student intern? ",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
                        Row(
                            children: [
                              Expanded( 
                              flex: 1,
                              child:RadioListTile(
                                selectedTileColor: Colors.amber,
                                activeColor: Colors.amber,
                                title: Text('Yes',
                                    style: GoogleFonts.salsa(color:ui.Color.fromARGB(255, 0, 0, 0),fontSize: 15,fontWeight: FontWeight.w600)),
                                value: 'Yes',
                                groupValue: _SOT4,
                                onChanged: (value) {
                                  setState(() {
                                    _SOT4 = value!;
                                  });
                                },
                              ),),
                              Expanded(
                                flex: 1,
                              child:RadioListTile(
                                selectedTileColor: Colors.amber,
                                activeColor: Colors.amber,
                                title:
                                    Text('No', style: GoogleFonts.salsa(color:ui.Color.fromARGB(255, 0, 0, 0),fontSize: 15,fontWeight: FontWeight.w600)),
                                value: 'No',
                                groupValue: _SOT4,
                                onChanged: (value) {
                                  setState(() {
                                    _SOT4 = value!;
                                  });
                                },
                              ),),
                            ],
                          ),
                        
                        Text("Do you have any notes that you would like to record to enrich the training process for the enrolled students?",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
                        Container(
                         // height: 40,
                           // margin: EdgeInsets.only(left: 15,right: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _T7,
                            onChanged: (value) {
                              setState(() {
                              _T7.text=value;
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 3,color: Colors.amber)),
                              //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                              alignLabelWithHint:true,hintText: "Write your notes here",),),
                          ),
                        Text("Do you suggest adding any courses to the student program to meet the student's needs during training?",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
                        Container(
                          height: 40,
                           // margin: EdgeInsets.only(left: 15,right: 10),
                          child: TextFormField(
                           // keyboardType: TextInputType.number,
                            controller: _T8,
                            onChanged: (value) {
                              setState(() {
                              _T8.text=value;
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 3,color: Colors.amber)),
                              //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                              alignLabelWithHint:true,hintText: "Write your suggestions here",),),
                          ),
                        Text("What are the personal and practical skills that this student needs to develop?",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
                        Container(
                          height: 40,
                           // margin: EdgeInsets.only(left: 15,right: 10),
                          child: TextFormField(
                           // keyboardType: TextInputType.number,
                            controller: _T9,
                            onChanged: (value) {
                              setState(() {
                              _T9.text=value;
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 3,color: Colors.amber)),
                              //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                              alignLabelWithHint:true,hintText: "Write skills here",),),
                          ),
                        Text("Recommendations of the student training supervisor",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
                        Container(
                          height: 40,
                           // margin: EdgeInsets.only(left: 15,right: 10),
                          child: TextFormField(
                           // keyboardType: TextInputType.number,
                            controller: _T10,
                            onChanged: (value) {
                              setState(() {
                              _T10.text=value;
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 3,color: Colors.amber)),
                              //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                              alignLabelWithHint:true,hintText: "Write your recommendations here",),),
                          ),
                        Text("Please suggest ideas as graduation projects nominated for students of the specialization",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w600),),
                        Container(
                          height: 40,
                           // margin: EdgeInsets.only(left: 15,right: 10),
                          child: TextFormField(
                           // keyboardType: TextInputType.number,
                            controller: _T11,
                            onChanged: (value) {
                              setState(() {
                              _T11.text=value;
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 3,color: Colors.amber)),
                              //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                              alignLabelWithHint:true,hintText: "Write your suggestions here",),),
                          ),
                      ],),
                     ),
                 // ],),

                ),
                ),
                Container(height: 5,),
                Card(
                      child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        Icon(Icons.medical_information_outlined,color: ui.Color.fromARGB(255, 126, 126, 126),size: 25,),
                        Text(
                                "  Superviser Information",
                                style: TextStyle(
                                  color: ui.Color.fromARGB(255, 126, 126, 126) ,
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),

                      ],),
                      IconButton(
                      onPressed:() {
                      setState(() {
                        print("yes clicked");
                        containerVisible3 = !containerVisible3;
                      });
                      }, 
                      color:  ui.Color.fromARGB(255, 126, 126, 126),
                      icon:  containerVisible3
                                  ?Icon(Icons.keyboard_arrow_up_sharp)
                                  :Icon(Icons.keyboard_arrow_down_sharp),
                      ),
                   
                  ],),
                     ),
                Container(
                padding: EdgeInsets.only(left: 10,),
                width: 400,
                height: containerVisible3
                ?280
                :5,
               // margin: EdgeInsets.only(left:10),
              // padding: EdgeInsets.only(top: 20,left: 15,bottom: 10,right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:  ui.Color.fromARGB(255, 255, 251, 251)
                ),
                child: SingleChildScrollView(
                  
    
                  child:// Column(children: [
                   
                    Visibility(
                      visible: containerVisible3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                       Text("General Specialization of the Supervisor",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Container(
                          height: 40,
                           // margin: EdgeInsets.only(left: 15,right: 10),
                          child: TextFormField(
                            //keyboardType: TextInputType.number,
                            controller: _S1,
                            onChanged: (value) {
                              setState(() {
                              _S1.text=value;
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 3,color: Colors.amber)),
                              //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                              alignLabelWithHint:true,hintText: "Write here",),),
                          ),                       
                       Text("Job Title",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Container(
                          height: 40,
                           // margin: EdgeInsets.only(left: 15,right: 10),
                          child: TextFormField(
                            //keyboardType: TextInputType.number,
                            controller: _S2,
                            onChanged: (value) {
                              setState(() {
                              _S2.text=value;
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 3,color: Colors.amber)),
                              //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                              alignLabelWithHint:true,hintText: "Write Title here",),),
                          ),                       
                       Text("A brief description of the nature of the work",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Container(
                          height: 40,
                           // margin: EdgeInsets.only(left: 15,right: 10),
                          child: TextFormField(
                            //keyboardType: TextInputType.number,
                            controller: _S3,
                            onChanged: (value) {
                              setState(() {
                              _S3.text=value;
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 3,color: Colors.amber)),
                              //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                              alignLabelWithHint:true,hintText: "Write description here",),),
                          ),                       
                       Text("Number of years of experience",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                        Container(
                          height: 40,
                           // margin: EdgeInsets.only(left: 15,right: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _S4,
                            onChanged: (value) {
                              setState(() {
                              _S4.text=value;
                              });
                            },
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 3,color: Colors.amber)),
                              //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
                              alignLabelWithHint:true,hintText: "Write  here",),),
                          ),
                      ],),
                     ),
                  //],),

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
                          mark=((q1+q2+q3+q4+q5+q6+q7+q8+q9+q10+q11+q12+q13+q14+q15+q16)/16).toInt();
                          print("Mark=$mark");
                          print(reportscount);
                        networkHandlerC.addcompanyform(widget.groupid,widget.CID,widget.StuId,widget.StuName,widget.StuImg,hours.toString(),widget.groupinfo['isUni'],q1.toString(),q2.toString(),q3.toString(),q4.toString(),q5.toString(),q6.toString(),q7.toString(),q8.toString(),q9.toString(),q10.toString(),q11.toString(),q12.toString(),q13.toString(),q14.toString(),q15.toString(),q16.toString(),_SOT1,_SOT2,_SOT3,_SOT4,_T5.text,_T6.text,_T7.text,_T8.text,_T9.text,_T10.text,_T11.text,_S1.text,_S2.text,_S3.text,_S4.text,mark,reportscount);
                          if(isuni){
                            Map<String,dynamic> temp={
                              "groupid":widget.groupid,
                              "isUni":true,
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
                            widget.onDataRefresh();
                            Navigator.pop(context);
                          }
                          /*else{
                            Map<String,dynamic> trinee={                        
                              "RegNum":widget.StuId,
                              "name":widget.StuName,
                              "img": widget.StuImg,
                            };                      
                            companyinfo['trainee'].add(trinee);
                            networkHandlerC.updatetrainee(widget.CID,  companyinfo['trainee']);                      
                          }*/
                        },
                        textColor: Colors.white,
                        color: Color.fromARGB(255 ,248, 154, 0),
                        child: Text("Submit",style: TextStyle(fontSize: 18,color: Colors.white),),
                        ),),)
              ]),

           /*   child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //q1
                  Text("General trainee behaviour",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
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
                  //Container(height: 5,),
                  //q2
                  Text("Commitment to attend",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
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
                  //Container(height: 5,),
                  //q3
                   Text("Performance and motivation",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
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
                  //Container(height: 5,),
                  //q4
                  Text("Ability to follow instructions",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
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
                  //Container(height: 5,),
                  //q5
                  Text("Initiative",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q5,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q5 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q5.toInt()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ),                 
                  //Container(height: 5,),
                  //q6
                  Text("Desire for continuous development and learning",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q6,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q6 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q6.toInt()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ),                 
                  //Container(height: 5,),
                  //q7
                  Text("Written communication skills",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q7,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q7 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q7.toInt()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ),                 
                  //Container(height: 5,),
                  //q8
                  Text("Verbal communication skills",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q8,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q8 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q8.toInt()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ),                                     
                  //Container(height: 5,),
                  //q9
                  Text("Technical competence",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q9,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q9 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q9.toInt()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ),
                  //Container(height: 10,),
                  //q10
                  Text("work perfiction",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q10,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q10 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q10.toInt()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ),  
                  //Container(height: 10,),
                  //q11
                  Text("Collaborative skills",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q11,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q11 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q11.toInt()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ), 
                  //Container(height: 10,),
                  //q12
                  Text("Ability to solve problems",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q12,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q12 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q12.toInt()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ),                                                                       
                  //Container(height: 10,),
                  //q13
                  Text("Administrative and organizational skills",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q13,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q13 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q13.toInt()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ),                  
                  //Container(height: 10,),
                  //q14
                  Text("The trainee commitment to ethics and professional responsibilities",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q14,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q14 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q14.toInt()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ), 
                 // Container(height: 10,),
                 //q15
                  Text("Acquire design skill",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q15,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q15 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q15.toInt()}',
                    style: TextStyle(fontSize: 12),
                  ),
                  ),                  
                  //Container(height: 10,),
                  //q16
                  Text("The ability to analyze information and use it appropriately",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
                  Slider(
                    thumbColor: Colors.indigo,
                    activeColor: Colors.indigo,
                    value: q16,
                    min: 0,
                    max: 100,
                    onChanged: (value) {
                      setState(() {
                        q16 = value;
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 25),
                    alignment: Alignment.topRight,
                 child: Text(
                    textAlign: TextAlign.right ,
                    'Mark : ${q16.toInt()}',
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
                    mark=((q1+q2+q3+q4+q5+q6+q7+q8+q9+q10+q11+q12+q13+q14+q15+q16)/16).toInt();
                    print("Mark=$mark");
                    print(reportscount);
                   networkHandlerC.addcompanyform(widget.groupid,widget.CID,widget.StuId,widget.StuName,widget.StuImg,hours.toString(),widget.groupinfo['isUni'],q1.toString(),q2.toString(),q3.toString(),q4.toString(),q5.toString(),q6.toString(),q7.toString(),q8.toString(),q9.toString(),q10.toString(),q11.toString(),q12.toString(),q13.toString(),q14.toString(),q15.toString(),q16.toString(),mark,reportscount);
                    if(isuni){
                      Map<String,dynamic> temp={
                        "groupid":widget.groupid,
                        "isUni":true,
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
                      widget.onDataRefresh();
                      Navigator.pop(context);
                    }
                    /*else{
                      Map<String,dynamic> trinee={                        
                        "RegNum":widget.StuId,
                        "name":widget.StuName,
                        "img": widget.StuImg,
                      };                      
                      companyinfo['trainee'].add(trinee);
                      networkHandlerC.updatetrainee(widget.CID,  companyinfo['trainee']);                      
                    }*/
                  },
                  textColor: Colors.white,
                  color: Color.fromARGB(255 ,248, 154, 0),
                  child: Text("Submit",style: TextStyle(fontSize: 18,color: Colors.white),),
                  ),),)

                ],
              ),
            */
            )



            : Container(
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("General trainee behaviour",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
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
                  Text("Commitment to attend",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
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
                   Text("Performance and motivation",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
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
                  Text("Desire for continuous development and learning",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w600),),
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
                   networkHandlerC.addcompanyform(widget.groupid,widget.CID,widget.StuId,widget.StuName,widget.StuImg,hours.toString(),widget.groupinfo['isUni'],q1.toString(),q2.toString(),q3.toString(),q4.toString(),"","","","","","","","","","","","","","","","","","","","","","","","","","","",mark,reportscount);
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
                      widget.onDataRefresh();
                      Navigator.pop(context);                      
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
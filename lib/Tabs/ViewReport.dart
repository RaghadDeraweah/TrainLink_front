import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:open_file/open_file.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

String? name = "Flutter Fall23";
String? members;

class ViewReport extends StatelessWidget {
  late String groupid;
  late String reportid;
  late String StuId;
  late String Week;
  late String StuName;
  late String StuImg;
 // late List<dynamic> studentsid;

  //howStu(post, companyinfo, companyinfo2, companyinfo3);
  ViewReport(String Week ,String groupid,String reportid,String StuId, String StuName,String StuImg){
    super.key;
    this.Week=Week;
    this.groupid=groupid;
    this.reportid=reportid;
    this.StuId=StuId;
    this.StuName=StuName;
    this.StuImg=StuImg;
   
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
            "Report View",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: reportpage( this.Week,this.groupid,this.reportid,this.StuId,this.StuName,this.StuImg),
      ),
    );
  }
}
class reportpage extends StatefulWidget {
   late String Week;
  late String groupid;
  late String reportid;
  late String StuId;
  late String StuName;
  late String StuImg;
 

  //howStu(post, companyinfo, companyinfo2, companyinfo3);
  reportpage(String Week,String groupid,String reportid,String StuId, String StuName,String StuImg){
    super.key;
    this.Week=Week;
    this.groupid=groupid;
    this.reportid=reportid;
    this.StuId=StuId;
    this.StuName=StuName;
    this.StuImg=StuImg;

  }


  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<reportpage> {
  TextEditingController feedbackController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  bool isDataReady=false;
  int hours=0;
  int taskscount=0;
  int reportscount=0;
  List<Map<String,dynamic>> stuinfo=[];
  Map<String,dynamic> student={};
  Map<String,dynamic> reportdetails={};
  GlobalKey<FormState>  addform= GlobalKey();
  final networkHandlerC = NetworkHandlerC();
  final networkHandler = NetworkHandlerS();
Future<void> fetchData() async {
  try {
    // (String sid in widget.studentsid) {
   // print(sid);
    student = await networkHandler.fetchStudent(widget.StuId);
    var reportslist = await networkHandlerC.getReportsStudent(widget.groupid,widget.StuId);
    for(var map in reportslist){
      map.forEach((key, value) {
        if(key=='_id' && value==widget.reportid){
          setState(() {
            reportdetails=map;
            print(reportdetails);
          });
        }
      });
    }
    setState(() {
      reportscount=reportslist.length;
    });
      for (var map in reportslist) {
      print("inside groups");
      map.forEach(
        (key, value) {
          if(key=="actualhours" && value !=null && value !="" ){
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
      /*  Form(
          child: Column(
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
                    'Mark : ${q4.toInt()}',
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
                    networkHandlerC.addcompanyform(widget.groupid,widget.CID,widget.StuId,widget.StuName,widget.StuImg,hours.toString(),q1.toString(),q2.toString(),q3.toString(),q4.toString());
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
      */
      Container(
        child: Column(children: [
          Container(height: 15,),
          Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber),
            color:ui.Color.fromARGB(255, 245, 245, 204),
          ),
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
          child: Row(children: [
            Text("Number of working days per week :  ",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
            Container(width: 10,),
            Text(reportdetails['DaysOfWeek'],style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
          ],),),
          Container(height: 10,),
          Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber),
            color: ui.Color.fromARGB(255, 245, 245, 204),
          ),
          alignment: Alignment.centerRight,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: Row(children: [
            Text("Number of working hours per week : ",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
            Container(width: 10,),
            Text(reportdetails['hours'],style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
          ],),),
          Container(height: 10,),
          Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber),
            color: ui.Color.fromARGB(255, 245, 245, 204),
          ),
          alignment: Alignment.centerRight,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),

          child: Row(children: [
            Text("Number of hours of absence per week : ",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
            Container(width: 10,),
            Text(reportdetails['nonattendancehours'],style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
          ],),),
          Container(height: 10,),
          Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber),
            color: ui.Color.fromARGB(255, 245, 245, 204),
          ),
          alignment: Alignment.topLeft,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
            Text("Excuse :",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.end,),
            Container(width: 10,),
            
             TextFieldTapRegion(child:Text(reportdetails['excuse'],style: TextStyle(fontSize: 15,color: Colors.black,),), ),

          ],),),
          Container(height: 10,),
          Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber),
            color:ui.Color.fromARGB(255, 245, 245, 204),
          ),
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("Achievements this week : ",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
           Container(width: 10,),
            TextFieldTapRegion(child:Text(reportdetails['work'],style: TextStyle(fontSize: 15,color: Colors.black,),), ),

          ],),),
          Container(height: 10,),
          Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber),
            color: ui.Color.fromARGB(255, 245, 245, 204),
          ),
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
          child: reportdetails['companyApproval'] 
          ?  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
               Text("Completed Hours in this Week ? ",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
               Text(reportdetails['actualhours'],style: TextStyle(fontSize: 15,color: Colors.black,)),
            ],),
            Container(height: 10,),
            Text("Your Feedback ",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
            Container(width: 10,),
            //TextFieldTapRegion(child: tex)
           /* TextFormField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(alignLabelWithHint:true,hintText: "Write Here",),
            ),
            */
            TextFieldTapRegion(child:Text(reportdetails['companyFeedback'],style: TextStyle(fontSize: 15,color: Colors.black,),), ),
            Container(height: 10,),
           /* Container(
             // margin: EdgeInsets.only(bottom: 20),
            alignment: Alignment.center,
            child: ButtonTheme(
              buttonColor: Colors.amber,
              height: 50,
              minWidth: 200,
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
            child: MaterialButton(onPressed:() {
              networkHandlerC.updateCompanyFeedback(widget.reportid,feedbackController.text,hoursController.text);
            },
            textColor: Colors.white,
            color: Colors.amber,
            child: Text("Send"),
            ),
            ),),
            */
            //Text("24",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
          ],)
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            //Row(
              //crossAxisAlignment:CrossAxisAlignment.start,
              //children: [
               Text("Completed Hours in this Week ? ",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
               
               TextField(
                  controller: hoursController,
                  keyboardType: TextInputType.number, // Specify numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly // Allow only digits
                  ],
                  decoration: InputDecoration(
                    
                    labelText: 'Hours',
                   // hintText: 'Only numbers are allowed',
                  ),
                ),
           // ],),
            Container(height: 10,),
            Text("Provide Feedback ",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
            Container(width: 10,),
            //TextFieldTapRegion(child: tex)
            TextFormField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(alignLabelWithHint:true,hintText: "Write Here",),
            ),
            Container(height: 10,),
            Container(
             // margin: EdgeInsets.only(bottom: 20),
            alignment: Alignment.center,
            child: ButtonTheme(
              buttonColor: Colors.amber,
              height: 50,
              minWidth: 200,
              shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
            child: MaterialButton(onPressed:() {
              networkHandlerC.updateCompanyFeedback(widget.reportid,feedbackController.text,hoursController.text);
            },
            textColor: Colors.white,
            color: Colors.amber,
            child: Text("Send"),
            ),
            ),),
            //Text("24",style: TextStyle(fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold),),
          ],),
          
          ),
          Container(height: 20,),
        ],),
      ),
      ],)
      )
      : Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }


}
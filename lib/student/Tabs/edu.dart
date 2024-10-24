import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled4/BStudent.dart';

class edu extends StatefulWidget {
  late Map<String,dynamic> stuinfo={};
  edu(Map<String,dynamic> stuinfo){super.key;
  this.stuinfo=stuinfo;}

    //super.key;

  @override
  _eduState createState() => _eduState();
}

class _eduState extends State<edu> {
  Map<String,dynamic> unistu={};
   File? _image;
   bool edit=false;
  bool isDataReady=false;
  bool majorState = false;
  final networkHandler = NetworkHandlerS();
  TextEditingController _controllerMajor = TextEditingController();
  TextEditingController _controllerYearJoin = TextEditingController();
  TextEditingController _controllerStudyState = TextEditingController();
  TextEditingController _controllerGY = TextEditingController();
  TextEditingController _controllerCC = TextEditingController();
  TextEditingController _controllerGPA = TextEditingController(text: '-');
  Future<void> fetchData() async {
  try {
    unistu = await networkHandler.fetchUniStudentData( widget.stuinfo['RegNum']);
    _controllerMajor =TextEditingController(text: unistu['Major']);
    _controllerYearJoin = TextEditingController(text: unistu['startyear']);
    _controllerStudyState = TextEditingController(text: unistu['stustatus']);
    _controllerGY = TextEditingController(text: unistu['graduationyear']);
    _controllerGPA = TextEditingController(text: unistu['GPa']);
    _controllerCC = TextEditingController(text: unistu['finishedhours']);
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
      print(widget.stuinfo);
    });
    });
}
Future<void> _getImage() async {

  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      _image = File(pickedFile.path);
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            color: const Color(0xffff003566),
            icon: const Icon(Icons.arrow_back),
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Education",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
      body:isDataReady
      ?Container(
        child:Stack(
        children: [
         
          Positioned(
            top: 0,
            child:Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 5,left: 5),
            child: //widget.fromstu
            //? 
            Container( color: Color(0xff0F2C59),width: 1,) ,            
            width: 411,
            height: 200,
            decoration: BoxDecoration(
              color: Color(0xff0F2C59),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
                    ),
          ),),

         Positioned(
            bottom: 0,
            child:Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 5,left: 5),
            child: //widget.fromstu
            //? 
            Container( color: Color(0xff0F2C59),width: 1,) ,            
            width: 411,
            height: 200,
            decoration: BoxDecoration(
              color: Color(0xff0F2C59),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40)),
                    ),
          ),),
          Positioned(
            right: 50,
            left: 50,
            top: 120,
            bottom: 100,
            child:Container(
              //padding: EdgeInsets.all(10),
              padding:EdgeInsets.only(top: 140,bottom: 10,right: 10,left: 10),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 202, 202, 202),
                borderRadius: BorderRadius.circular(10),
               // border: Border.all()
              ),
             child:Card(
              elevation: 0,
              color: Color.fromARGB(255, 202, 202, 202),
            child: Column(
              children: [
              Container(
                 padding: EdgeInsets.all(10),               
                width: 350,
                decoration: BoxDecoration(color: const Color.fromARGB(255, 202, 202, 202),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xff0F2C59))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.engineering,color:  Color(0xff0F2C59),size: 25,),
                  Container(width: 10,),
                  Text(_controllerMajor.text, style: TextStyle(color: Color.fromARGB(255, 100, 100, 100),fontWeight: FontWeight.w500),)
                ],
              ),
              ),
              Container(height: 10,),
              Container(
                padding: EdgeInsets.all(10),                
                width: 350,
                decoration: BoxDecoration(color: const Color.fromARGB(255, 202, 202, 202),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xff0F2C59))),
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.workspace_premium_rounded,color:  Color(0xff0F2C59),size: 25,),
                  Container(width: 10,),
                  Text(_controllerStudyState.text, style: TextStyle(color: Color.fromARGB(255, 100, 100, 100),fontWeight: FontWeight.w500),)
                ],
              ),
              ),
              Container(height: 10,),
              Container(
                padding: EdgeInsets.all(10),                
                width: 350,
                decoration: BoxDecoration(color: const Color.fromARGB(255, 202, 202, 202),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xff0F2C59))),
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.date_range_rounded,color:  Color(0xff0F2C59),size: 25,),
                  Container(width: 10,),
                  Text(_controllerYearJoin.text, style: TextStyle(color: Color.fromARGB(255, 100, 100, 100),fontWeight: FontWeight.w500),)
                ],
              ),
              ),
              Container(height: 10,),
              Container(
                padding: EdgeInsets.all(10),
                width: 350,
                decoration: BoxDecoration(color: const Color.fromARGB(255, 202, 202, 202),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xff0F2C59))),
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.school,color:  Color(0xff0F2C59),),
                  Container(width: 10,),
                  Text(_controllerGY.text, style: TextStyle(color: Color.fromARGB(255, 100, 100, 100),fontWeight: FontWeight.w500),)
                ],
              ),
              ), 
              Container(height: 10,),                                         
              Container(
                padding: EdgeInsets.all(10),
                width: 350,
                decoration: BoxDecoration(color: const Color.fromARGB(255, 202, 202, 202),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xff0F2C59))),
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.task_alt,color:  Color(0xff0F2C59),),
                  Container(width: 10,),
                  Text(_controllerCC.text, style: TextStyle(color: Color.fromARGB(255, 100, 100, 100),fontWeight: FontWeight.w500),)
                ],
              ),
              ),
               Container(height: 10,),                                         
              Container(
                padding: EdgeInsets.all(10),
                width: 350,
                decoration: BoxDecoration(color: const Color.fromARGB(255, 202, 202, 202),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xff0F2C59))),
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.percent_rounded,color:  Color(0xff0F2C59),),
                  Container(width: 10,),
                  Text(_controllerGPA.text, style: TextStyle(color: Color.fromARGB(255, 100, 100, 100),fontWeight: FontWeight.w500),)
                ],
              ),
              ),
            ]),
          )
          ),
        ),
          Positioned(
            top: 50,
            left: 50 ,
            right: 50,
            child: Column(children: [
              imageProfile(),
              Container(height: 8,),
              Text(widget.stuinfo['fname']+" "+widget.stuinfo['lname'],style: TextStyle(color: Color(0xff0F2C59),fontSize: 20,fontWeight: FontWeight.w700),)
            ],)
            
            ),
         /* Positioned(
            top: 120,
            left: 300 ,
            right: 50,           
            child: IconButton(icon: Icon(Icons.edit,color: Color(0xff0F2C59),) ,
            onPressed:() {
            setState(() {
              edit=true;
            });
          }, ))*/
      ]),
      )
      :Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }
  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        Container(
          
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:Border.all(color:Color.fromARGB(97, 15, 45, 89) ,width: 5,style: BorderStyle.solid),
            color: Color.fromARGB(97, 15, 45, 89) ,
          ),
          height: 140,
          width: 150,
          child: CircleAvatar(
        radius: 80, // Customize the radius as needed
        foregroundColor: Color.fromARGB(253, 15, 45, 89),
        backgroundImage: _image != null 
        ? FileImage(_image!) 
        : NetworkImage("http://localhost:5000/" + widget.stuinfo['img']) as ImageProvider,
      
      ),
      ),


      ]),
    );
  }

}
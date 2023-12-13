// ignore: file_names
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:untitled4/BCompany.dart';

import 'package:flutter/src/material/dropdown.dart';
import 'package:untitled4/HomePage.dart';

class GroupPost extends StatelessWidget {
String companyname="";
String cimg="";
String CID="";
String groupid="";
late String groupname="";
  GroupPost(String Name,String ID,String img,String groupid,String groupname){
    super.key;
    this.companyname= Name;
    this.CID= ID;
    this.cimg= img;
    this.groupid=groupid;
    this.groupname=groupname;
    }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
          title:  Text(
            this.groupname,
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: MyHomePage(this.companyname,this.CID,this.cimg,this.groupid,this.groupname),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
 late String cn ;
  late String img;
  late String id;
  late String groupid="";
late String groupname="";
   MyHomePage(String Name,String ID,String img,String groupid,String groupname){
    super.key;
    this.cn= Name;
    this.id= ID;
    this.img= img;
    this.groupid=groupid;
    this.groupname=groupname;
  }

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState(this.cn,this.id,this.img);
}

class _MyHomePageState extends State<MyHomePage> {
  late String cn ;
  late  String img="";
  late String id;
  String dropdownValue = "Flutter";
  String Location ="Nablus";
  bool isRemotly=false;
  bool isUni=false;
  TextEditingController content = TextEditingController();
  TextEditingController seats = TextEditingController();
  final networkHandler = NetworkHandlerC();
  _MyHomePageState(String Name,String ID,String img){
    this.cn= Name;
    this.id= ID;
    this.img= img;

  }


  DateTime _dateTime = DateTime.now();
  TimeOfDay _timeOfDay = TimeOfDay(hour: 8, minute: 20);
  File? _selectedImage;
  void _showTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) {
      setState(() {
        _timeOfDay = value!;
      });
    });
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime(2025))
        .then((value) {
      setState(() {
        _dateTime = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String url = "http://localhost:5000/$img";
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      //color: Colors.amber,
     // child: Container(
      //height: MediaQuery.of(context).size.height,
      //width: MediaQuery.of(context).size.width,
        child: 
            Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          border: Border.all(
                              //    color: Color(0xff003566),
                              style: BorderStyle.solid,
                              color: Colors.grey.shade400),
                               image:  DecorationImage(
                           // String url="http://localhost:5000/"+img,
                             image: NetworkImage("http://localhost:5000/$img"),
                                        fit: BoxFit.cover)),
                              
                             //image: NetworkImage("http://localhost:5000/"+cimg),
//fit: BoxFit.cover)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child:  Text(
                        cn,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                //   color: Colors.blue,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 900,
                //  color: Colors.green,

                child:  Column(
                      children: [
                       /* Container(
                          height :130,
                        child: Column(
                          
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          //Expanded(child: 
                          CheckboxListTile(title:Text("Remotly"),value:isRemotly, onChanged:(val){
                            setState(() {
                            if(val == true) isRemotly=true;
                            else{isRemotly=false;}
                              //isRemotly=val!;
                            });
                          }),
                          //),
                         // Expanded(child: 
                          CheckboxListTile(title:Text("University Training"),value:isUni, onChanged:(val){
                            setState(() {
                            if(val == true) isUni=true;
                            else{isUni=false;}
                             // isUni=val!;
                            });
                          }),
                         // ),
                        ],
                        ),
                        ),*/
                      
                      /*Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          /*Container(
                          width: MediaQuery.of(context).size.width/2,
                          height: 50,
                            child:  DropdownButton<String>(
                            padding: EdgeInsets.only(left: 20),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16),
                            alignment: Alignment.center,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                child: Text(
                                  "Flutter",
                                ),
                                value: "Flutter",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "React",
                                ),
                                value: "React",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Angular",
                                ),
                                value: "Angular",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "VueJs",
                                ),
                                value: "VueJs",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Svelte",
                                ),
                                value: "Svelte",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "jQuery",
                                ),
                                value: "jQuery",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Backbone.js",
                                ),
                                value: "Backbone.js",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "JavaScript",
                                ),
                                value: "JavaScript",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Django",
                                ),
                                value: "Django",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "ExpressJS",
                                ),
                                value: "ExpressJS",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Laravel",
                                ),
                                value: "Laravel",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "ASP .NET Core",
                                ),
                                value: "ASP .NET Core",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Spring Boot",
                                ),
                                value: "Spring Boot",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "-",
                                ),
                                value: "-",
                              ),
                            ],
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_drop_down_rounded),
                          ),
                          ),*/
                        /*    Container(
                          width: MediaQuery.of(context).size.width/2,
                          height: 50,
                           child: DropdownButton<String>(
                            padding: EdgeInsets.only(left: 20),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16),
                            alignment: Alignment.center,
                            onChanged: (String? newValue) {
                              setState(() {
                                Location = newValue!;
                              });
                            },
                            items: const [
                              DropdownMenuItem(
                                child: Text(
                                  "Nablus",
                                ),
                                value: "Nablus",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Ramallah",
                                ),
                                value: "Ramallah",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Salfit",
                                ),
                                value: "Salfit",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Hebron",
                                ),
                                value: "Hebron",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Jenin",
                                ),
                                value: "Jenin",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Tulkarm",
                                ),
                                value: "Tulkarm",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Qalqeiliah",
                                ),
                                value: "Qalqeiliah",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Tubas",
                                ),
                                value: "Tubas",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Bethlehem",
                                ),
                                value: "Bethlehem",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "48 Lands",
                                ),
                                value: "48 Lands",
                              ),
                              DropdownMenuItem(
                                child: Text(
                                  "Jerchio",
                                ),
                                value: "Jerchio",
                              ),
                            ],
                            value: Location,
                            icon: Icon(Icons.arrow_drop_down_rounded),
                          ),
                          ),*/

                        ],
                        ),                      
                        */
                        Container(
                        height: 300,
                        child :TextField(
                          controller: content,
                          keyboardType: TextInputType.text,
                          maxLines: 15,
                          decoration: InputDecoration(
                              hintText: " Write your announce! "),
                          onChanged: (val){
                            setState(() {
                           content.text =val;
                          });
                          },
                        ),
                        ),
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(width: 20,),
                            Expanded(
                              child: TextFormField(
                                controller: seats,
                                keyboardType: TextInputType.number,
                                maxLines: 1,
                                decoration: InputDecoration(
                                    hintText: "# of Seats",
                                    border: InputBorder.none),
                              onChanged: (value) {
                                setState(() {
                                  seats.text=value;
                                });
                              },
                              ),
                            ),
                            Expanded(
                             // width: 100,
                              //height: 50,
                              // color: Color(0xFFFFEB3B),
                              flex: 2,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _showTimePicker();
                                    },
                                    icon: Icon(
                                      Icons.alarm,
                                    ),
                                  ),
                                  Text(
                                    _timeOfDay.format(context).toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              //width: 150,
                              //height: 50,
                              //   color: Color(0xFFFFEB3B),
                              flex: 2,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _showDatePicker();
                                    },
                                    icon: Icon(Icons.calendar_month_rounded),
                                  ),
                                  Text(
                                    _dateTime.day.toString() +
                                        "/" +
                                        _dateTime.month.toString() +
                                        "/" +
                                        _dateTime.year.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),*/
                        Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 190,
                              height: 190,
                              padding: EdgeInsets.only(top: 20),
                              margin: EdgeInsets.only(left: 0),
                                child: Column(
                                  children: [
                                    Container(
                                        width: 130,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          boxShadow: [
                                            BoxShadow(
                                                spreadRadius: 0.5,
                                                offset: Offset.fromDirection(
                                                    BorderSide
                                                        .strokeAlignCenter),
                                                color: Colors.blue)
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blue,
                                        ),
                                        //padding: EdgeInsets.all(10),
                                        child: IconButton(
                                          onPressed: () {
                                            _pickImageFromGallery();
                                          },
                                          icon: Icon(
                                            Icons.image,
                                            color: Colors.white,
                                          ),
                                        )
                                        ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _selectedImage != null
                                        ? Container(
                                            child: Image.file(_selectedImage!),
                                            width: 80,
                                            height: 80,
                                          )
                                        : Text("Please selected an image"),
                                  ],
                                ),
                              
                              //  color: Colors.green,
                            ),
                            Container(
                              width: 130,
                              height: 50,
                              margin: EdgeInsets.only(right: 30, bottom: 100),
                              // color: const Color.fromARGB(255, 210, 165, 218),
                              child: MaterialButton(
                                child: Text("POST"),
                                color: Colors.blue,
                                textColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                onPressed: () async{
                                  print(id);
                                  print(cn);
                                  print(img);
                                  //print(_dateTime);
                                  //print(_timeOfDay);
                                  //print(Location);
                                  //print(int.parse(seats.text));
                                  //print(dropdownValue);
                                  print(content.text);
                                  print(isRemotly);
                                  //print(isUni);
                                 // print(content.text);
                                  //int se =int.parse(seats.text);
                                  //List appliedStuId =[];
                                  String result = await networkHandler.addgrouppost(widget.groupid,widget.id, widget.cn,widget.img, content.text);
                                  if(result.length>5) {
                                    networkHandler.patchImagegrouppost(_selectedImage!.path.toString(), result);
                                  }
                                  //Navigator.push(context,MaterialPageRoute(builder: (context) {return MyHomePage(cn,id,img);}));
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  
                
              ),
            ]),
          
        
     // ),
    );
  }

  Future _pickImageFromGallery() async {
    final returnedPhoto =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedPhoto == null) {
      return;
    }
    setState(() {
      _selectedImage = File(returnedPhoto.path);
    });
  }
}

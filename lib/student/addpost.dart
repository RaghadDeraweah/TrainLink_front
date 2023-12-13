// ignore: file_names
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/src/material/dropdown.dart';
import 'package:untitled4/BStudent.dart';


class HomePost extends StatelessWidget {
  late Map<String,dynamic> stuinfo={};

  HomePost(Map<String,dynamic> stuinfo){super.key;
  this.stuinfo=stuinfo;}
  //late String id;
  //late String 
  //const HomePost({super.key});

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
          title: const Text(
            "TrainLink Post",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: MyHomePage(this.stuinfo),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  late Map<String,dynamic> stuinfo={};
  MyHomePage(Map<String,dynamic> stuinfo){super.key;
  this.stuinfo=stuinfo;}
  //const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final networkHandler = NetworkHandlerS();
  TextEditingController _controllerDes = TextEditingController();
  TextEditingController _controllerUrl = TextEditingController();
  String dropdownValue = "Flutter";

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
    return Container(
      height: 780,
      width: 411.0,
      //color: Colors.amber,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(children: [
              Container(
                width: 411,
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
                              image: NetworkImage("http://localhost:5000/" + widget.stuinfo['img']),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child:  Text(
                        widget.stuinfo['fname']+" "+widget.stuinfo['lname'],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                //   color: Colors.blue,
              ),
              Container(
                width: 411,
                height: 700,
                //  color: Colors.green,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        TextField(
                          controller: _controllerDes,
                          keyboardType: TextInputType.text,
                          maxLines: 15,
                          decoration: InputDecoration(
                              hintText: " Describe your work. "),
                          onChanged: (value) {
                            setState(() {
                              _controllerDes.text=value;
                            });
                          },                         
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: TextFormField(
                            controller: _controllerUrl,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.link),
                                label: Text("Add your project link")),
                          onChanged: (value) {
                            setState(() {
                              _controllerUrl.text=value;
                            });
                          },                            
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 130,
                              height: 50,
                              margin: EdgeInsets.only(
                                  bottom: 100, top: 10, left: 250),
                              // color: const Color.fromARGB(255, 210, 165, 218),
                              child: MaterialButton(
                                child: Text("POST"),
                                color: Colors.blue,
                                textColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                onPressed: () async{
                                  String postid= await networkHandler.addstupost(widget.stuinfo['RegNum'],widget.stuinfo['fname']+" "+widget.stuinfo['lname'],widget.stuinfo['img'],_controllerDes.text,_controllerUrl.text);
                                  if(postid.length>5){print("Post added");}
                                  setState(() {
                                    _controllerDes.text="";
                                    _controllerUrl.text="";
                                  });
                                  //Navigator.of(context).pop();
                                  //addstupost
                                 /* Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MyApp(0);
                                  }));*/
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
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

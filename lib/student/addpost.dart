// ignore: file_names
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/src/material/dropdown.dart';
import 'package:untitled4/BStudent.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

/*class HomePost extends StatelessWidget {
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
}*/

class HomePost extends StatefulWidget {
    final VoidCallback onDataRefresh;
  late Map<String,dynamic> stuinfo={};
  HomePost({required this.stuinfo,required this.onDataRefresh});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}
class Interests {
   int Iid;
   String Iname;

  Interests({ required this.Iid, required this.Iname,});
}
class _MyHomePageState extends State<HomePost> {
     static List<Interests> interests = [
   Interests(Iid:1,Iname:'Flutter'),
    Interests(Iid:2,Iname:'React'),
    Interests(Iid:3,Iname:'Angular'),
    Interests(Iid:4,Iname:'Vue.js'),
    Interests(Iid:5,Iname:'Svelte'),
    Interests(Iid:6,Iname:'jQuery'),
    Interests(Iid:7,Iname:'Backbone.js'),
    Interests(Iid:8,Iname:'JavaScript'),
    Interests(Iid:9,Iname:' Django'),
    Interests(Iid:10,Iname:'ExpressJS '),
    Interests(Iid:11,Iname:'Laravel'),
    Interests(Iid:12,Iname:'ASP .NET Core'),
    Interests(Iid:13,Iname:'Spring Boot'),
    //Interests(Iid:1,Iname:' '),
];
  final _feilds = interests.map((interest) => MultiSelectItem<Interests>(interest, interest.Iname)).toList();
  List<Interests> _selectedInterests = [];
  final networkHandler = NetworkHandlerS();
  TextEditingController _controllerti = TextEditingController();  
  TextEditingController _controllerDes = TextEditingController();
  TextEditingController _controllerUrl = TextEditingController();
     List<String> ss=[];
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
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            color: const Color(0xffff003566),
            icon: const Icon(Icons.arrow_back),
            iconSize: 30,
            onPressed: () {
              widget.onDataRefresh();
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "Add Project",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),

      body: SingleChildScrollView(
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
                child: Column(
                  children: [
                    Column(
                      children: [
                        TextField(
                          controller: _controllerti,
                          keyboardType: TextInputType.text,
maxLines: 2,
                          decoration: InputDecoration(
                              hintText: "Project Title "),
                          onChanged: (value) {
                            setState(() {
                              _controllerti.text=value;
                            });
                          },                         
                        ),                        
                        TextField(
                          controller: _controllerDes,
                          keyboardType: TextInputType.text,
                          maxLines: 7,
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
                        Container(height: 10,),
                    MultiSelectDialogField(
                      dialogHeight: 160,
                      items: _feilds,
                      
                      title: Text("Interests",style: TextStyle(color:Color.fromARGB(255, 10, 1, 71)),),
                      selectedColor:Color.fromARGB(255, 10, 1, 71),
                      decoration: BoxDecoration(                       
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                          color:  Color.fromARGB(255, 133, 133, 133),
                          //width: ,
                        ),
                      ),
                      buttonIcon: Icon(
                        
                        Icons.keyboard_double_arrow_down_outlined,
                        color: Color.fromARGB(255, 95, 95, 95),
                      ),
                      
                      buttonText: Text(
                        "frameworks",
                        style: TextStyle(
                          color: Color.fromARGB(255, 107, 106, 106),
                          fontSize: 17,
                        ),
                      ),
                      onConfirm: (results) {
                        _selectedInterests = results;
                      },
                      onSelectionChanged: (p0) {
                        setState(() {
                         _selectedInterests = p0;
                      });
                       
                      },
                      onSaved: (newValue) {
                        _selectedInterests = newValue!;
                      },
              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 130,
                              height: 50,
                              margin: EdgeInsets.only(
                                  bottom: 100, top: 10, left: 50,right: 50),
                              // color: const Color.fromARGB(255, 210, 165, 218),
                              child: MaterialButton(
                                child: Text("POST"),
                                color:const Color(0xffff003566),
                                textColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                onPressed: () async{
                                  for(int i=0;i<_selectedInterests.length;i++)
                                ss.add(_selectedInterests[i].Iname);
                                  String postid= await networkHandler.addstupost(widget.stuinfo['RegNum'],widget.stuinfo['fname']+" "+widget.stuinfo['lname'],widget.stuinfo['img'],_controllerti.text,_controllerDes.text,_controllerUrl.text,ss);
                                  if(postid.length>5){print("Post added");
                                  widget.onDataRefresh();
                                  Navigator.of(context).pop();

                                  }
                                  
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

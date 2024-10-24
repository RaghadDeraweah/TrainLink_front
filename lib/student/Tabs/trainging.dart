import 'dart:io';

import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class traingingg extends StatelessWidget {
  late Map<String,dynamic> stu;
   traingingg(this.stu);

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
            "Training",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: MyHomePage(this.stu),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  late Map<String,dynamic> stu;
   MyHomePage(this.stu);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool containerVisible = false;
  bool containerVisible2 = false;
  bool isDataReady = false;
  int finalrate=0;
     File? _image;
  double evaluation=0;
  double mapValue(double x, double min1, double max1, double min2, double max2) {
  return min2 + (max2 - min2) * ((x - min1) / (max1 - min1));
}
  bool s1 = false, s2 = false, s3 = false, s4 = false, s5 = false;
 
  void initState() {
  super.initState();
      fetchData().then((_) {
      setState(() {
        isDataReady=true;

      });
      },);
      }
Future<void> fetchData() async {
  try {
    if(widget.stu['finishedGroups']!=[]){
      for(int x=0;x<widget.stu['finishedGroups'].length;x++){
        evaluation+=widget.stu['finishedGroups'][x]['mark'];
        print("evaluation= $evaluation");
      }}
      if(evaluation!=0.0){
      evaluation=evaluation/widget.stu['finishedGroups'].length;
      print("evaluation after div= $evaluation");
      
      finalrate=mapValue(evaluation,0,100,0,5).round();
      print("finalrate= $finalrate");
      }
if (finalrate == 1) {
    s1 = true;
  } else if (finalrate == 2) {
    s2 = true;
    s1 = true;
  } else if (finalrate == 3) {
    s1 = true;
    s2 = true;
    s3 = true;
  } else if (finalrate == 4) {
    s1 = true;
    s2 = true;
    s3 = true;
    s4 = true;
  } else if (finalrate == 5) {
    s1 = true;
    s2 = true;
    s3 = true;
    s4 = true;
    s5 = true;
  }

    isDataReady=true;
  } catch (error) {
    print(error);
  }
}
  @override
  Widget build(BuildContext context) {
    
    return isDataReady
    ?CustomScrollView(
      
       shrinkWrap: true,
            slivers: [
              SliverAppBar(
                //pinned: true,
                leading: Icon(Icons.access_alarms_rounded,color: Color(0xff0F2C59),),
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                expandedHeight: 270, // Set the height you want for the flexible space
                flexibleSpace: FlexibleSpaceBar(
                background:
                Stack(children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: 
                   Container(
                  padding: EdgeInsets.only(top: 60,),
                width: 360,
                height: 270,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color(0xff0F2C59),
                        ),               
                child:
                 Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Container(     
                     // margin: EdgeInsets.only(left: 10),                       
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:Border.all(color:Color.fromARGB(97, 15, 45, 89) ,width: 5,style: BorderStyle.solid),
                              color: Color.fromARGB(97, 15, 45, 89) ,
                            ),
                            height: 100,
                            width: 110,
                            child: CircleAvatar(
                          radius: 80, // Customize the radius as needed
                          foregroundColor: Color.fromARGB(253, 15, 45, 89),
                          backgroundImage: _image != null 
                          ? FileImage(_image!) 
                          : NetworkImage("http://localhost:5000/" + widget.stu['img']) as ImageProvider,
                        
                        ),
                        ),                    

                  Container(width: 20,color:Color(0xff0F2C59) ,),
                  Expanded(
                    child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.stu['fname']+" "+widget.stu['lname'],style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                        Row(
                        children: [
                          Icon(
                            (s1) ? Icons.star : Icons.star_border,
                            color: (s1) ? Color(0xffffc300) : Color.fromARGB(255, 102, 102, 102),
                            size: 20,
                          ),
                          Icon(
                            (s2) ? Icons.star : Icons.star_border,
                            color: (s2) ? Color(0xffffc300) : Color.fromARGB(255, 102, 102, 102),
                            size: 20,
                          ),
                          Icon(
                            (s3) ? Icons.star : Icons.star_border,
                            color: (s3) ? Color(0xffffc300) : Color.fromARGB(255, 102, 102, 102),
                            size: 20,
                          ),
                          Icon(
                            (s4) ? Icons.star : Icons.star_border,
                            color: (s4) ? Color(0xffffc300) : Color.fromARGB(255, 102, 102, 102),
                            size: 20,
                          ),
                          Icon(
                            (s5) ? Icons.star : Icons.star_border,
                            color: (s5) ? Color(0xffffc300) : Color.fromARGB(255, 102, 102, 102),
                            size: 20,
                          ),
                        ],
                      ),
                    ],),
                    ),
                  ],),
                  Container(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Column(children: [
                      widget.stu['finishedGroups']==[]
                      ? Text("0",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w800),)
                      : Text( widget.stu['finishedGroups'].length.toString(),style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w800),),
                      Text("Trainings",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w300),),
                    ],),
                    Column(children: [
                      Container(height: 10,width: 40,),
                      widget.stu['available']
                      ?Text("Available",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w800),)
                      :Text("Busy",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w800),),
                      Text("Status",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w300),),
                    ],)                    
                  ],)
                ]),
              )
                ),
                  Positioned(
                    right: 0,
                    left: 0,
                    top: 240,
                    child: Container(height: 30,decoration: BoxDecoration(
                       color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(                  
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),),)
                    ),
                ],))
              ),

              widget.stu['finishedGroups'].isEmpty
              ? SliverToBoxAdapter(
                    child: Center(
                      // Display a message or an alternative widget
                      child: Text('You dont join to any traning'),
                    ),
                  )
              : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return showD(context,widget.stu['finishedGroups'][index]['cname'],widget.stu['finishedGroups'][index]['cimg'],containerVisible,widget.stu['finishedGroups'][index]['isUni'],widget.stu['finishedGroups'][index]['hours'],
                    widget.stu['finishedGroups'][index]['StartDate'],widget.stu['finishedGroups'][index]['EndDate'],
                    widget.stu['finishedGroups'][index]['mark'],              
                    () {
                      setState(() {
                        print("yes clicked");
                        containerVisible = !containerVisible;
                      });
                  },);
                  },
                  childCount: widget.stu['finishedGroups'].length ,
                  )
              )
            ]
    )
    : Center(
            child: CircularProgressIndicator(), // Loading indicator
          );
  }
Widget showD(  context,
    namecompany,
    image,
    containerVisible,
    _cTypeTrainText,
    _cnumberOfhoursText,
    start,
    end,
    mark,
    Function toggleVisibility,){
    final TextEditingController _cTypeTrain ;
    if(_cTypeTrainText==true){
       _cTypeTrain = TextEditingController(text: "University Training");
    }
    else{
      _cTypeTrain = TextEditingController(text: "Non University Training");
    }
    final TextEditingController _cnumberOfhours =
        TextEditingController(text: _cnumberOfhoursText.toString());
    final TextEditingController _cmonth =
        TextEditingController(text: start);// "("+start+")-("+end+")");
    final TextEditingController _cstate ;
    final TextEditingController _cRange;
    if(mark>50){
      _cstate =TextEditingController(text: "Pass");
      int r=(mark/10).toInt();
      _cRange = TextEditingController(text: r.toString());
    }
    else{
      _cstate =TextEditingController(text: "Not Pass");      
      int r=mark/10;
      _cRange = TextEditingController(text: r.toString());
    }
    return Container(
      width: 370,
      height: containerVisible
      ?270
      :80,
      margin: EdgeInsets.only(left:10,top:5),
    child: Row(
      children: [
        Icon(Icons.verified_rounded,color: const Color.fromARGB(255, 117, 160, 235),size: 50,),
        //SingleChildScrollView(
         // child: 
          Container(
            width: 330,
            height: containerVisible
            ?240
            :80,
            margin: EdgeInsets.only(left:10),
           // padding: EdgeInsets.only(top: 20,left: 15,bottom: 10,right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:  Color.fromARGB(144, 0, 53, 102)
           ),  
           child:SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          image: DecorationImage(
                              fit: BoxFit.cover, image: NetworkImage("http://localhost:5000/"+image))),
                      margin: EdgeInsets.only(top: 10,left: 10),                     
                    ),
                    
                    Container(
                      width: 250,
                      margin: EdgeInsets.only(left: 20,),// bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        
                        children: [
                          Text(
                            namecompany,
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255) ,
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 15, top: 5),
                            child: MaterialButton(
                              child: containerVisible
                              ?Icon(Icons.keyboard_arrow_up_sharp)
                              :Icon(Icons.keyboard_arrow_down_sharp),
                              color: Color(0xff003566),
                              textColor: Color.fromARGB(255, 255, 255, 255),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              onPressed: () {
                                toggleVisibility();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),                    
              ],),
                    Visibility(
                      visible: containerVisible,
                      child: Column(children: [
                        Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text(
                              "Kinds of training : ",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 53, 102),
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                width: 150,
                                child: TextField(
                                  //      enabled: StartYearState,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:  Color.fromARGB(255, 0, 53, 102), // Set the text color to green
                                  ),
                                  controller: _cTypeTrain,
                                  // Optional: Style the text field
                                  decoration: InputDecoration(
                                    //   labelText: 'Field Label', // Change the label text if needed
                                    border: InputBorder
                                        .none, // Remove the default underline
                                  ),
                                ))
                          ],
                        ),
                      ),
                        Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text(
                              "Hours : ",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 53, 102),
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                width: 100,
                                child: TextField(
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                   color: Color.fromARGB(255, 0, 53, 102), // Set the text color to green
                                  ),
                                  controller: _cnumberOfhours,
                                  // Optional: Style the text field
                                  decoration: InputDecoration(
                                    //   labelText: 'Field Label', // Change the label text if needed
                                    border: InputBorder
                                        .none, // Remove the default underline
                                  ),
                                ))
                          ],
                        ),
                      ),
                        Container(
                       margin: EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text(
                              "Start Date Training  : ",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 53, 102),
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                width: 100,
                                child: TextField(
                                  //   enabled: GYState,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 53, 102),// Set the text color to green
                                  ),
                                  controller: _cmonth,
                                  // Optional: Style the text field
                                  decoration: InputDecoration(
                                    //   labelText: 'Field Label', // Change the label text if needed
                                    border: InputBorder
                                        .none, // Remove the default underline
                                  ),
                                ))
                          ],
                        ),
                      ),
                        Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text(
                              "Evaluation : ",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 53, 102),
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                width: 100,
                                child: TextField(
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 53, 102), // Set the text color to green
                                  ),
                                  controller: _cRange,
                                  // Optional: Style the text field
                                  decoration: InputDecoration(
                                    //   labelText: 'Field Label', // Change the label text if needed
                                    border: InputBorder
                                        .none, // Remove the default underline
                                  ),
                                ))
                          ],
                        ),
                      ),
                      ],)
                      ),     
           /*         Visibility(
                      visible: containerVisible,
                      child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "Kinds of training : ",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 53, 102),
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                width: 150,
                                child: TextField(
                                  //      enabled: StartYearState,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:  Color.fromARGB(255, 0, 53, 102), // Set the text color to green
                                  ),
                                  controller: _cTypeTrain,
                                  // Optional: Style the text field
                                  decoration: InputDecoration(
                                    //   labelText: 'Field Label', // Change the label text if needed
                                    border: InputBorder
                                        .none, // Remove the default underline
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: containerVisible,
                      child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "Hours : ",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 53, 102),
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                width: 100,
                                child: TextField(
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                   color: Color.fromARGB(255, 0, 53, 102), // Set the text color to green
                                  ),
                                  controller: _cnumberOfhours,
                                  // Optional: Style the text field
                                  decoration: InputDecoration(
                                    //   labelText: 'Field Label', // Change the label text if needed
                                    border: InputBorder
                                        .none, // Remove the default underline
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: containerVisible,
                      child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "Start Date Training  : ",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 53, 102),
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                width: 100,
                                child: TextField(
                                  //   enabled: GYState,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 53, 102),// Set the text color to green
                                  ),
                                  controller: _cmonth,
                                  // Optional: Style the text field
                                  decoration: InputDecoration(
                                    //   labelText: 'Field Label', // Change the label text if needed
                                    border: InputBorder
                                        .none, // Remove the default underline
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  /*  Visibility(
                      visible: containerVisible,
                      child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "State :",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                width: 200,
                                child: TextField(
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .black, // Set the text color to green
                                  ),
                                  controller: _cstate,
                                  // Optional: Style the text field
                                  decoration: InputDecoration(
                                    //   labelText: 'Field Label', // Change the label text if needed
                                    border: InputBorder
                                        .none, // Remove the default underline
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),*/
                    Visibility(
                      visible: containerVisible,
                      child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "Evaluation : ",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 53, 102),
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                width: 100,
                                child: TextField(
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 53, 102), // Set the text color to green
                                  ),
                                  controller: _cRange,
                                  // Optional: Style the text field
                                  decoration: InputDecoration(
                                    //   labelText: 'Field Label', // Change the label text if needed
                                    border: InputBorder
                                        .none, // Remove the default underline
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
           */
           ]),
           ),
          ),

     // ),
      ],
      
    )
    );
    }

}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/student/addpost.dart';
import 'package:untitled4/student/Tabs/link.dart';

class pc extends StatefulWidget {
  late Map<String,dynamic> stuinfo={};
  late String ID;
  pc(Map<String,dynamic> stuinfo,String ID){
  this.stuinfo=stuinfo;
  this.ID=ID;}

    //super.key;

  @override
  _projectState createState() => _projectState();
}

class _projectState extends State<pc> {

   File? _image;
  final networkHandler = NetworkHandlerS();
  bool isDataReady=false;
  bool save = false;
  bool onLastPage = false;
  String namewithstate="";
  List<Map<String,dynamic>> posts=[];
    Map<String,dynamic> unistu={};
  num likes=0;
    @override
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
    likes=0;
      unistu = await networkHandler.fetchUniStudentData( widget.stuinfo['RegNum']);
    posts = await networkHandler.getStuposts(widget.stuinfo['RegNum']);
    namewithstate= unistu['Major']+" | "+unistu['stustatus'];
    if(posts!=[]){
    for(int i=0;i<posts.length;i++){
      likes=likes+posts[i]['likes'].length!;
    }}
    print(posts);
    isDataReady=true;
  } catch (error) {
    print(error);
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
            "Projects",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
    body: isDataReady
    ? CustomScrollView(
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
                          : NetworkImage("http://localhost:5000/" + widget.stuinfo['img']) as ImageProvider,
                        
                        ),
                        ),                    

                  Container(width: 20,color:Color(0xff0F2C59) ,),
                  Expanded(
                    child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.stuinfo['fname']+" "+widget.stuinfo['lname'],style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                        Text(namewithstate,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w200),),
                    ],),
                    ),
                  ],),
                  Container(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Column(children: [
                      posts==[]
                      ? Text("0",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w800),)
                      : Text(posts.length.toString(),style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w800),),
                      Text("Projects",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w300),),
                    ],),
                    Column(children: [
                      Container(height: 10,width: 40,),
                      Text(likes.toString(),style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w800),),
                      Text("Likes",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w300),),
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
             
             posts.isEmpty 
              ?SliverToBoxAdapter(
                    child: Center(
                      // Display a message or an alternative widget
                      child: Text('You dont post any project'),
                    ),
                  )
              
              :
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                   return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [                    
                    Column(
                    children: [
                    IconButton(onPressed:() {
                      setState(() {
                        isDataReady=false;
                      });
                     posts[index]['likes'].add(widget.ID);
                     networkHandler.updatelikes(posts[index]['_id'], posts[index]['likes']);                 
                     fetchData().then((_) {
                        setState(() {
                          isDataReady=true;

                        });
                        },);                    
                    }, 
                    icon: posts[index]['likes'].contains(widget.ID)
                    ?Icon(Icons.favorite,color: Colors.red,size: 35,)
                    :Icon(Icons.favorite_outline_sharp,color: Colors.red,size: 35,),
                    ),
                    posts[index]['likes']==[]
                    ?Text("0",style: TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontWeight: FontWeight.w300),)  
                    :Text(posts[index]['likes'].length.toString(),style: TextStyle(color: Color.fromARGB(255, 0, 0, 0),fontWeight: FontWeight.w300),)  
                      ],
                    ),
                    Container(
                      width: 300,
                      height: 240,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.only(top: 20,left: 15,bottom: 10,right: 10),
                      decoration: BoxDecoration(
                       // borderRadius: BorderRadius.all(col)
                       borderRadius: BorderRadius.circular(20),
                       color:  Color.fromARGB(144, 0, 53, 102)

                      ),
                     // child: Container(
                        //color: Color.fromARGB(209, 0, 53, 102),
                        //elevation: 0,
                        //color: Color.fromARGB(143, 0, 53, 102),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          Text(posts[index]['title'],style:TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w400)),
                          Container(height: 15,),
                          Text(posts[index]['content'],style:TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w300)),
                          Container(height: 10,),
                          Linkrep(posts[index]['projectlink']),
                          /* Container(
                          //width: 200,
                          height: 50,
                          child: Linkrep(link),
                          ),*/
                          Row(children: [
                            for(int x=0;x<posts[index]['frameworks'].length;x++)
                            Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                            decoration:BoxDecoration(
                              color: Color.fromARGB(185, 0, 53, 102),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            //color: Color.fromARGB(185, 0, 53, 102),
                            child: Text(posts[index]['frameworks'][x],style: TextStyle(color: Color.fromARGB(204, 255, 255, 255)),),
                          )
                          
                          ],)


                        ],),
                     // ),
                    )
                   ],);
                  },
                  childCount: posts.length ,
                  )
                  ),
 
            ])
    : Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
  );
  }

}
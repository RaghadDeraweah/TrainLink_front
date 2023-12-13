//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/student/GroupTabs/posts.dart';
import 'package:untitled4/student/GroupTabs/tasks.dart';

class MyGroupHomePage extends StatelessWidget {
late String Taskid;
   late String idgroup;
  late String SID;
  late String cname;
  late String cimg;
  late String groupname;
   int selectedPage=0;
  MyGroupHomePage(String _id,String SID ,String cname, String cimg,String groupname){
    selectedPage=this.selectedPage;
    super.key;
    this.idgroup=_id;
    this.SID=SID;
    this.cname=cname;
    this.cimg=cimg;
    this.groupname=groupname;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MyGroupHomePagesS(this.idgroup,this.SID,this.cname,this.cimg,this.groupname),
      ),
    );
  }
}

class MyGroupHomePagesS extends StatefulWidget {
   late String idgroup;
  late String CID;
  late String cname;
  late String cimg;
  late String groupname;
   int selectedPage=0;
  MyGroupHomePagesS(String _id,String CID ,String cname, String cimg,String groupname){
    selectedPage=this.selectedPage;
    super.key;
    this.idgroup=_id;
    this.CID=CID;
    this.cname=cname;
    this.cimg=cimg;
    this.groupname=groupname;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState(selectedPage);
}

class _MyHomePageState extends State<MyGroupHomePagesS> {
      Map<String, dynamic>  groupinfo={};
  final networkHandler = NetworkHandlerC();
  Map<String,dynamic> companyinfo={};
  int selectedPage;
  //late String IDCompany;
  bool isDataReady=false;
  
  _MyHomePageState(this.selectedPage);
  @override
  void initState() {
  super.initState();
      fetchData().then((_) {
      setState(() {
        isDataReady=true;
         print("from Home"+widget.CID);
      });
      },);
}
Future<void> fetchData() async {
  try {

    groupinfo = await networkHandler.getGroupById(widget.idgroup);
    groupinfo.values.forEach((value) {
      print(value);
    });
    isDataReady=true;
  } catch (error) {
    print(error);
  }
}
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: selectedPage,
      length: 2,
      child: isDataReady
      ? NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
     // shrinkWrap: true,
     return <Widget>[
      //slivers: [
        SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: 300.0, 
         
          //Tab Bar
          
               // expandedHeight: 470.0, 
            flexibleSpace: FlexibleSpaceBar(
                 background:Column(children: [ 
               // Stack(children: [

                Container(
                 width: 411,
                 height: 150,
                  decoration: BoxDecoration(
                  /*: [
                  /*  BoxShadow(
                        blurStyle: BlurStyle.outer,
                        blurRadius: 3,
                        color: Colors.blueGrey)*/
                  ],*/
                  image: DecorationImage(
                      image:NetworkImage("http://localhost:5000/"+ groupinfo['groupImg']),
                      fit: BoxFit.cover)),
            ),
           
                Container(
                margin: EdgeInsets.only(top: 10),
                child: MaterialButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                      child: Container(
                        width: 235,
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          groupinfo['groupname'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),),
                      Expanded(
                       // width: 120,
                       flex: 2,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment:CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        Tooltip(
                        message: "Exam Phase",
                        child: IconButton(onPressed:() {
                          
                        },
                        tooltip:"Exam Phase" , 
                        icon: groupinfo['phase']=="Assessment"
                        ? Icon(Icons.circle,color: Colors.deepOrangeAccent,)
                        : Icon(Icons.circle_outlined,color: Colors.deepOrangeAccent,),
                        ),),
                        Tooltip(
                        message: "Interview Phase",                          
                          child:IconButton(onPressed:() {
                          }, 
                        icon: groupinfo['phase']=="selection"
                        ? Icon(Icons.circle,color: Colors.amber)
                        : Icon(Icons.circle_outlined,color: Colors.amber,),
                          ),),
                        Tooltip(
                        message: "Training Phase",                          
                          child: IconButton(
                            onPressed:() {
                            },
                        icon: groupinfo['phase']=="starting"
                        ? Icon(Icons.circle,color: Colors.green)
                        : Icon(Icons.circle_outlined,color: Colors.green,),
                             ) ,
                        )
                        
                      ],),),
                   /* Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 17,
                      color: Colors.grey,
                    )*/
                  ],
                ),
              ),
            ),
                Container(
              margin: EdgeInsets.only(
                left: 20,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.people_alt,color: Color.fromARGB(255, 46, 46, 46),),
                    onPressed: () {
                      //showMem
                        //   Navigator.push( context,  MaterialPageRoute(builder: (context) => showMem( groupinfo['_id'],widget.CID,widget.cname,widget.cimg,groupinfo['membersStudentId'])));
                    },
                    ),
                  Text(
                    groupinfo['membersStudent'].length.toString(),
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    " members",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w900),
                  )
                ],
              ),
            ),

                 ],
                 ),  
                ),

          bottom : const TabBar(
            //isScrollable: true,
            unselectedLabelColor: Color(0xff003566),
            indicatorColor: Color(0xffffc300),
            labelColor: Color(0xffffc300),
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  size: 28,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.task_outlined,
                  size: 28,
                ),
              ),

            ],
          ),
       
        ),
      

      ];
      
  },
  body:TabBarView(
          children: <Widget>[
            groupHomePage(widget.idgroup),
            ttList(widget.idgroup,widget.CID,widget.cname,widget.cimg),
           // groupHomePage(widget.idgroup,widget.CID,widget.cname,widget.cimg),
            //TaskssList(widget.idgroup,widget.CID,widget.cname,widget.cimg,widget.groupname),
          ],
        ),
  )
      :Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }
}

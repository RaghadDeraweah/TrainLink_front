//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/GroupTaps/posts.dart';
import 'package:untitled4/GroupTaps/showmembers.dart';
import 'package:untitled4/GroupTaps/tasks.dart';
import 'package:untitled4/Tabs/group.dart';
class MyGroupHomePage extends StatelessWidget {
late String Taskid;
   late String idgroup;
  late String CID;
  late String cname;
  late String cimg;
  late String groupname;
   int selectedPage=0;
  MyGroupHomePage(String _id,String CID ,String cname, String cimg,String groupname){
    selectedPage=this.selectedPage;
    super.key;
    this.idgroup=_id;
    this.CID=CID;
    this.cname=cname;
    this.cimg=cimg;
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
          primary: false,
          backgroundColor: Colors.white,
         /* title: const Text(
            "Task Details",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),*/
        ),
        body: MyGroupHomePagesS(this.idgroup,this.CID,this.cname,this.cimg,this.groupname),
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
    bool greenNow=false;
  bool yellowNow=false;
      Map<String, dynamic>  groupinfo={};
  final networkHandler = NetworkHandlerC();
  Map<String,dynamic> companyinfo={};
  int selectedPage;
  late String IDCompany;
  bool isDataReady=false;
  
  _MyHomePageState(this.selectedPage);
  @override
  void initState() {
  super.initState();
      fetchData().then((_) {
      setState(() {
        isDataReady=true;
         print("from Home"+IDCompany);
      });
      },);
}
Future<void> fetchData() async {
  try {
    IDCompany = await networkHandler.getidddd();
    print(IDCompany);
    companyinfo = await networkHandler.fetchCompanyData(IDCompany!);
    companyinfo.values.forEach((value) {
      print(value);
    });
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
                            if(groupinfo['phase'] =="Assessment"){
                            setState(() {
                              yellowNow=true;
                            networkHandler.updateGroupphase(groupinfo['_id'],"selection");                              
                            });}
                          }, 
                        icon: groupinfo['phase']=="selection" || yellowNow
                        ? Icon(Icons.circle,color: Colors.amber)
                        : Icon(Icons.circle_outlined,color: Colors.amber,),
                          ),),
                        Tooltip(
                        message: "Training Phase",                          
                          child: IconButton(
                            onPressed:() {
                              if(groupinfo['phase'] =="selection"){
                            setState(() {
                              greenNow=true;
                            networkHandler.updateGroupphase(groupinfo['_id'],"starting");
                            networkHandler.updateStartDate(groupinfo['_id']);                              
                            });}
                            },
                        icon: groupinfo['phase']=="starting" || greenNow
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
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => showMem(groupinfo)));
                            //MaterialPageRoute(builder: (context) => showMem( groupinfo['_id'],widget.CID,widget.cname,widget.cimg,groupinfo['membersStudentId'],groupinfo['membersStudent'])));
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
             /*   Container(
              width: 380,
              margin: EdgeInsets.only(right: 210, top: 10),
             // child: MaterialButton(
               // color: Colors.blue,
                //textColor: Colors.white,
             /*   shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),*/
                //onPressed: () {},
                child:// Row(
                  //children: [
                    //Icon(Icons.group_add_sharp),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        groupinfo['des'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    //Icon(Icons.arrow_drop_down_sharp)
                  //],
                //),
              //),
            ),
             */
             /*TabBar(
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
          ),*/
                /*Divider(
              thickness: 5,
            ),*/

              /*  Container(
                  width: 390.0,
                  height: 50.0,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  // color: Color(0xff003566),
                  child: Row(
                    children: <Widget>[
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.post_add,
                                color: Color(0xff003566),
                                size: 40.0,
                              ),
                              ),

                         /* Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 2.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      width: 1.0, color: Colors.grey.shade400),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(60.0))),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => GroupPost(widget.cname,widget.CID,widget.cimg,widget.idgroup,groupinfo['groupname']),
                                ));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 13.0),
                                child: Text(
                                  "Let's announce a training!                                ",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.blueGrey),
                                ),
                              ),
                            ),
                          ),*/

                    ],
                  ),
                ),*/
                /*Divider(
                  thickness: 5,
                ),*/
                 ],
                 ),  
                ),
         /* actions: <Widget>[
            
           Column(children: [ 
               // Stack(children: [
                Container(
                 width: 411,
                 height: 220,
                  decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurStyle: BlurStyle.outer,
                        blurRadius: 3,
                        color: Colors.blueGrey)
                  ],
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
                      Container(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(
                          groupinfo['groupname'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
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
                Container(
              width: 380,
              margin: EdgeInsets.only(right: 210, top: 10),
             // child: MaterialButton(
               // color: Colors.blue,
                //textColor: Colors.white,
             /*   shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),*/
                //onPressed: () {},
                child:// Row(
                  //children: [
                    //Icon(Icons.group_add_sharp),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        groupinfo['des'],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    //Icon(Icons.arrow_drop_down_sharp)
                  //],
                //),
              //),
            ),
                Divider(
              thickness: 5,
            ),

                Container(
                  width: 390.0,
                  height: 50.0,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  // color: Color(0xff003566),
                  child: Row(
                    children: <Widget>[
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.post_add,
                                color: Color(0xff003566),
                                size: 40.0,
                              ),
                              ),

                          /*Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, top: 2.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      width: 1.0, color: Colors.grey.shade400),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(60.0))),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => GroupPost(widget.cname,widget.CID,widget.cimg,widget.idgroup,groupinfo['groupname']),
                                ));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 13.0),
                                child: Text(
                                  "Let's announce a training!                                ",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.blueGrey),
                                ),
                              ),
                            ),
                          ),*/

                    ],
                  ),
                ),
                Divider(
                  thickness: 5,
                ),
                 ],
                 ),  
          ],
          */
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
      
        //Tab Bar View
       /* SliverList(delegate: _SliverAppBarDelegate( TabBarView(
          children: <Widget>[
            groupHomePage(widget.idgroup,widget.CID,widget.cname,widget.cimg),
            TaskssList(widget.idgroup,widget.CID,widget.cname,widget.cimg),
          ],
        ),),),*/

      ];
      
  },
  body:TabBarView(
          children: <Widget>[
            groupHomePage(widget.idgroup,widget.CID,widget.cname,widget.cimg),
            TaskssList(widget.idgroup,widget.CID,widget.cname,widget.cimg,widget.groupname),
          ],
        ),
  )
      :Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }
}

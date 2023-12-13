import 'package:flutter/material.dart';

import 'dart:io';
import 'package:readmore/readmore.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/student/Tabs/link.dart';
import 'package:untitled4/student/addpost.dart';

class projects extends StatelessWidget {
  late Map<String,dynamic> stuinfo={};
  late bool fromstu;
  projects(Map<String,dynamic> stuinfo,bool fromstu){super.key;
  this.stuinfo=stuinfo;
  this.fromstu=fromstu;}

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
            "Projects ",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: contact(this.stuinfo,this.fromstu),
      ),
    );
  }
}

class contact extends StatefulWidget {
  late Map<String,dynamic> stuinfo={};
  late bool fromstu;
  contact(Map<String,dynamic> stuinfo,bool fromstu){super.key;
  this.stuinfo=stuinfo;
  this.fromstu=fromstu;}

  @override
  // ignore: library_private_types_in_public_api
  _contactState createState() => _contactState();
}

class _contactState extends State<contact> {
  final networkHandler = NetworkHandlerS();
  bool isDataReady=false;
  bool save = false;
  bool onLastPage = false;
  List<Map<String,dynamic>> posts=[];
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
    posts = await networkHandler.getStuposts(widget.stuinfo['RegNum']);
    print(posts);
    isDataReady=true;
  } catch (error) {
    print(error);
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            floatingActionButton: FloatingActionButton(
              elevation: widget.fromstu
              ? 0
              : 1.0 ,
          backgroundColor: widget.fromstu
         ? Color(0xffffc300)
         :  Color.fromARGB(255, 255, 255, 255),
          onPressed: () {
            if(widget.fromstu){
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => HomePost(widget.stuinfo)));}
            // print("yes");
          },
          child: Icon(
            Icons.add,
            color: widget.fromstu
            ? Color(0xff003566)
            :  Color.fromARGB(255, 255, 255, 255),
          ),
        ),
    body: isDataReady
    ? CustomScrollView(
        shrinkWrap: true,
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                expandedHeight: 250, // Set the height you want for the flexible space
                flexibleSpace: FlexibleSpaceBar(
                 background:Container(
                width: 360,
                height: 250,

                // color: Colors.yellow,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/projects.jpeg"))),
                margin: EdgeInsets.only(top: 65),
              ) )
              ),
              
              posts.isEmpty 
              ?SliverToBoxAdapter(
                    child: Center(
                      // Display a message or an alternative widget
                      child: Text('You dont post any project'),
                    ),
                  )
              
              : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return pro(posts[index]['projectlink'], posts[index]['content']);
                  },
                  childCount: posts.length ,
                  )
                  ),
 
            ])// Container(
      //child: SingleChildScrollView(
       // scrollDirection: Axis.vertical,
       // child:
       /*  posts.length ==0
        ? Text("No posts found ")
        : Stack(
          children: [
          ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) => ListTile(
                      title: pro(posts[index]['projectlink'], posts[index]['content']),),) ,
          
          Container(
                width: 360,
                height: 360,

                // color: Colors.yellow,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/projects.jpeg"))),
                margin: EdgeInsets.only(top: 65),
              )
          ],)*/
          //height: 780,
          //color: Colors.white,
         // child:  ListView.builder(
                   //   itemCount: posts.length,
                     // itemBuilder: (context, index) => ListTile(
                     // title: pro(posts[index]['projectlink'], posts[index]['contant']),),)
         /* Column(
            children: [
              pro("https://daliadwaikat-restaurantsite.netlify.app/",
                  "New web-page using #HTML #CSS and #Media_query"),
              pro("https://daliadwaikat2.netlify.app/",
                  "This is my first web-page using #HTML #CSS and #Media_query"),
              Container(
                width: 360,
                height: 360,

                // color: Colors.yellow,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/projects.jpeg"))),
                margin: EdgeInsets.only(top: 65),
              )
            ],
          ),*/

     // ),
   // )
    : Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }

  Widget pro(link, describe) {
    return Container(
        width: 400,
        // height: 20,
        decoration: BoxDecoration(
            color: Colors.amber, borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.only(top: 20, left: 5,right: 5),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  Text(
                    "Project Link : ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Container(
                      width: 200,
                      height: 50,
                      child: Linkrep(link),
                      ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    
                    "Describe Project: ",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,

                      child: Container(
                        //   height: 80.0,
                        padding: EdgeInsets.fromLTRB(10,0,10,20),
                        width: 211.0,
                        //padding: EdgeInsets.all(20),
                        //  color: Colors.blue,
                        child: ReadMoreText(
                          describe,
                          trimLines: 3,
                          style: TextStyle(fontSize: 15),
                          trimCollapsedText: '... Read More',
                          trimExpandedText: '... Read Less',
                          trimMode: TrimMode.Line,
                          textAlign: TextAlign.justify,
                          lessStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          moreStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),

                      // color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),);
  }
}
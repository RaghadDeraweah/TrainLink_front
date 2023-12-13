import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/GroupsPostsTasks.dart';
import 'package:untitled4/createGroup/intro_page1.dart';
import 'package:untitled4/createGroup/intro_page2.dart';
import 'package:untitled4/createGroup/intro_page3.dart';
import 'package:untitled4/createGroup/intro_page4.dart';
import 'package:untitled4/groupHomePage.dart';
import 'package:untitled4/Tabs/group.dart';

String? name = "Flutter Fall23";
String? members;

class createNewGroup extends StatelessWidget {
  late String CID;
  late String cname;
   late String cimg;
  createNewGroup(String companyid, String cname,String cimg){
   super.key;
   this.CID=companyid;
   this.cname=cname;
   this.cimg=cimg;
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
          title: const Text(
            "Create New Group",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: MyHomePage(this.CID,this.cname,this.cimg),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  late String CID;
  late String cname;
   late String cimg;
  MyHomePage(String companyid, String cname,String cimg){
    super.key;
   this.CID=companyid;
   this.cname=cname;
   this.cimg=cimg;
  }

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState(this.CID);
}

class _MyHomePageState extends State<MyHomePage> {
  PageController _controller = PageController();
     final networkHandler = NetworkHandlerC();
  final networkHandlerss = NetworkHandlerS();
  String groupname="";
  String about="";
  String des="";
   String postid="";
  File? groupimg;
  List<Map<String,dynamic>> groupmembers=[];
   List<String> groupmembersId=[];
  bool onLastPage = false;
  late String CID;
  _MyHomePageState(String companyid){
    this.CID=companyid;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            resizeToAvoidBottomInset: true,
    body : Stack(
      
      children: [
        
        PageView(
          //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          onPageChanged: (Index) {
            if(Index==0){
              
            }else if(Index==1){

            }else if(Index==2){

            }else if(Index==3){

            }
            setState(() {
              onLastPage = (Index == 3);
            });
          },
          controller: _controller,
          children: [IntroPage1( 
             onGroupNameChanged: (value) {
                setState(() {
                  groupname = value;
                });
              },
              onAboutChanged: (value) {
                setState(() {
                  about = value;
                });
              },
          ), IntroPage2(
             ondesChanged: (value) {
                setState(() {
                  des = value;
                });
              },
          ), IntroPage3(
              onImgSelected: (value) {
                setState(() {
                  groupimg = value;
                });
              },
          ), IntroPage4(
            CID: CID,
           postid: (value) {
              setState(() {
                postid=value;
              });
            },
            getStudents: (value) {
              setState(() {
                groupmembers=value;
              });
            },
            getStudentsId: (value) {
              setState(() {
                groupmembersId=value;
              });
            },
          )],
        ),
        Positioned(
          top: 20,
          left: 10,
          right: 10,
          
          child: 
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                  onTap: () {
                    _controller.previousPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  child: Text(
                    "back",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
              SmoothPageIndicator(controller: _controller, count: 4),
              onLastPage
                  ? GestureDetector(
                      onTap: () async{
                        String _id =await networkHandler.addgroup(postid, widget.CID,widget.cname,widget.cimg, groupname, about, des, groupmembers,groupmembersId);
                        for(int i=0;i < groupmembersId.length;i++){
                          networkHandlerss.updategroupidstud(groupmembersId[i], _id, false);
                          print("update groupid+ status");
                        }
                        if(_id.length>5){
                           networkHandler.updatehasgroup(postid,true);
                          await networkHandler.patchImagegroup(groupimg!.path, _id);
                          
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MyGroupHomePage(_id,widget.CID,widget.cname,widget.cimg,groupname)));
                        // print("yes");
                      },
                      child: Text(
                        "done",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ))
                  : GestureDetector(
                      onTap: () {
                        print(groupname);
                        print(about);
                        print(des);
                        _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                      child: Text(
                        "next",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
            ],
          ),
          alignment: Alignment(0, 0.75),
        )
    ),
      ],
    ));
  }
}

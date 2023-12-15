import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/Tabs/viewTrainee.dart';
import 'package:untitled4/postHomePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled4/BCompany.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:untitled4/ratingReivews.dart';
import 'package:untitled4/showStudents.dart';
import 'package:untitled4/student/Tabs/ratingpost.dart';

//import 'package:read_more_text/read_more_text.dart';
class SearchCompany extends StatelessWidget {
  late String CompanyID;
  late Map<String,dynamic> stu;
  SearchCompany(String CompanyID,Map<String,dynamic> stu){
    super.key;
    this.CompanyID=CompanyID;
    this.stu=stu;

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
            "Search",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: HomeS(this.CompanyID,this.stu),
      ),
    );
  }
}
class HomeS extends StatefulWidget {
  late String ID;
  late Map<String,dynamic> stu;
  HomeS(String ID,Map<String,dynamic> stu){
    super.key;
    this.ID=ID;
    this.stu=stu;
  }
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

Future<List<Map<String, dynamic>>> fetchPosts(String companyId) async {
    final response = await http.get(Uri.parse("http://localhost:5000/post/posts/$companyId"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = convert.jsonDecode(response.body);
      List<Map<String, dynamic>> posts = [];

      for (var item in jsonData) {
        posts.add(item);
      }

      return posts;
    } else {
      //print("faild : ${response.body}");
      throw Exception("faild : ${response.body}");
    }
}
String? contentPost =
    "Happy HR Professional Day! 💙 \nBehind every successful organization lies an HR team dedicated to shaping company culture, fostering talent, managing compliance, and so much more. 🚀\n\n\nWe're privileged to partner with so many exceptional HR leaders across the globe, who passionately strive to make the service industry a better place - especially for frontline workers.\n We couldn't help but share some of their wisdom on this special day! 🎉⤵\n Events season is truly upon us! ⏳";

class _HomeScreenState extends State<HomeS> {
  bool canRate =false;
  bool isDataReady=false;
  bool isCliked=false;
  List<dynamic> ss=[];
  List<Map<String, dynamic>> postss = [];
  List<String> availableframeworks=[];
  DateTime? dateTime ;
  Map<String, dynamic>  companyinfo={};
  List<Map<String, dynamic>> reversedItems=[];
  final storage = FlutterSecureStorage();
  final networkHandlerC = NetworkHandlerC();
  final networkHandler = NetworkHandlerS();
  @override
  void initState() {
    super.initState();
    fetchData().then((_) {
      setState(() {
        postss = List.from(reversedItems.reversed);
        isDataReady = true; // Set the flag to true when data is fetched
      });
      });
  }

Future<void> fetchData() async {
  try {

    companyinfo = await networkHandlerC.fetchCompanyData(widget.ID);
    companyinfo.values.forEach((value) {
      print(value);
    });

    dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").parse(companyinfo["BD"]);
    reversedItems = await fetchPosts(widget.ID);
    for (var map in reversedItems) {
      map.forEach((key, value) {
        print('$key: $value');
      });
    }
    for(int i=0;i<widget.stu['finishedGroups'].length;i++){
      if(widget.stu['finishedGroups'][i]['CID']==widget.ID && (widget.stu['finishedGroups'][i]['isRated']==false)){
        canRate=true;
        availableframeworks.add(widget.stu['finishedGroups'][i]['framework']);
      }
    }
    isDataReady=true;
  } catch (error) {
    print(error);
  }
}
  void _showDialog(BuildContext context,String contenttxt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Return the AlertDialog widget
        return AlertDialog(
          icon: Icon(Icons.warning,color: const Color.fromARGB(255, 244, 225, 54),size: 40,),
          //title: Text('Dialog Title'),
          content: Text(contenttxt,style: TextStyle(fontSize: 25),),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
              Navigator.of(context).pop();
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(   
      body: isDataReady
      ? CustomScrollView(
        shrinkWrap: true,
            slivers: [
              SliverAppBar(
               // pinned: true,
                backgroundColor: Colors.white,
                expandedHeight: 
                canRate
                ?345
                :300.0, // Set the height you want for the flexible space
                flexibleSpace: FlexibleSpaceBar(
                 background://Column(children: [     
                  Padding(
                    padding:EdgeInsets.only(top: 10.0),
                    child :Container(          
                      width: MediaQuery.of(context).size.width,
                      height: 350,
                      //margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade400, blurRadius: 13.0)
                      ]),
                    child : Column(
                    children: [
                    Container(
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                    boxShadow: [
                        BoxShadow(color: Color(0xff003566), blurRadius: 13.0)
                      ],
                      borderRadius: BorderRadius.circular(100),
                      // margin: EdgeInsets.only(left: 50, bottom: 50),
                      image: DecorationImage(
                          image: NetworkImage("http://localhost:5000/"+companyinfo['img']),
                          fit: BoxFit.cover),
                    ),
                    width: 100.0,
                    height: 100,
                    ),
                  Container(height: 20,),
                  Column(
                    children: [
                      Text(
                        companyinfo['Name'],
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                        IconButton(onPressed:() {
                                          
                                         if(!companyinfo['rating'].isEmpty){
                                          Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                          ratingReviews(companyinfo['img'],companyinfo['Name'],companyinfo['rating']),));
                                          }
                                        },
                                          icon:Icon(
                                            Icons.star,
                                            size: 24,
                                            color: Color(0xffffc300),
                                          ),),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 0),
                                            child:
                                             Text(
                                              companyinfo['rating'].isEmpty
                                              ?"0 Rating"
                                               : companyinfo['rating'].length.toString()+" Rating",
                                              style: TextStyle(fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        ],
                                ),
                              Column(
                                children: [
                                        IconButton(
                                          onPressed:() {
                                            if(!companyinfo['trainee'].isEmpty){
                                          Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) =>
                                          trainee(companyinfo['trainee']),));
                                          }},
                                          icon:Icon(
                                            Icons.person,
                                            size: 24,
                                          ),
                                          ),                                 
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: Text(
                                              companyinfo['trainee'].isEmpty
                                              ?"0 Trainee"
                                              : companyinfo['trainee'].length.toString()+ " Trainee",
                                                style:
                                                    TextStyle(fontWeight: FontWeight.w600)),
                                          )
                                        ],
                                ),
                              Column(
                                children: [
                                        IconButton(
                                          onPressed:() {
                                      
                                        },
                                          icon: Icon(
                                            Icons.handshake,
                                            size: 24,
                                            color: Color(0xffffc300),
                                          ),
                                          ),                                   

                                          Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: Text(
                                              
                                              dateTime!.year.toString(),
                                                style:
                                                    TextStyle(fontWeight: FontWeight.w600)),
                                          )
                                        ],
                                ),
                              Column(
                                children: [
                                        IconButton(
                                          onPressed:() {
                                        },
                                          icon:Icon(
                                            Icons.location_on,
                                            size: 24,
                                          ),
                                          ),                                   

                                          Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: Text( companyinfo['city'],
                                                style:
                                                    TextStyle(fontWeight: FontWeight.w600)),
                                          )
                                        ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                  Container(height: 10,),
                  canRate
                  ? Row(
                children: <Widget>[
                  Container(
                    //  width: 90.0,
                    height: 70.0,
                    //   margin: EdgeInsets.only(top: 10, bottom: 10),
                    // color: Color(0xff003566),
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.rate_review_outlined,
                                  color: Color(0xff003566),
                                  size: 40.0,
                                ))
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 2.0),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                        width: 1.0,
                                        color: Colors.grey.shade400),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60.0))),
                                onPressed: () {
                                  Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => RatingPost(widget.stu,widget.ID,availableframeworks)));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 13.0),
                                  child: Text(
                                    "Type your rating!                                                ",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.blueGrey),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )    
                  : const Divider(color: Colors.white,),   
                      ]),
                      ),
                  // Positioned(
                    //child:  
              ),
                  
              //  ],) 
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Card(
            child: Row(
            children: <Widget>[
        Container(
          width: 400.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width,//400.0,
                height: 50.0,
                // color: Colors.amber,
                child: Row(
                  children: <Widget>[
                   // Column(
                     // crossAxisAlignment: CrossAxisAlignment.start,
                      //children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Container(
                            width: 50.0,
                            height: 50.0,
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40.0),
                                    border: Border.all(
                                        //    color: Color(0xff003566),
                                        style: BorderStyle.solid,
                                        color: Colors.grey.shade400),
                                  image: DecorationImage(
                                       image: NetworkImage("http://localhost:5000/"+postss[index]['cimg']),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ),
                        ),
                      //],
                    //),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              width: 230.0,
                              height: 20.0,
                              // color: Colors.pink,
                              child: Text(
                                postss[index]['cname'],
                                style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10, top: 5),
                              width: 200.0,
                              height: 30.0,
                              // color: Colors.purple,
                              child: Text(
                               
                                postss[index]['postDate']+"    "+postss[index]['location'],
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.blueGrey[500]),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(children: [
                        Container(
                          width: 30.0,
                          height: 30.0,
                          // color: Colors.brown,
                          child : postss[index]['isRemotly']
                          ?  IconButton(
                            onPressed: () {
                            },
                            icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                          )
                          :  IconButton(                         
                            onPressed: () {
                              /*setState(() {
                                print(postss[index]['_id']);
                               // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                //super.initState();                                
                              });*/
                            },
                            icon: Icon(Icons.videocam_off_outlined,color: Color.fromARGB(255, 158, 158, 158),),
                          )
                        ),
                        Container(
                          width: 30.0,
                          height: 30.0,
                          // color: Colors.brown,
                          child : postss[index]['isUni']
                          ?  IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.school,color: Color.fromARGB(255, 1, 2, 82)
                            ))
                          :  IconButton(                         
                            onPressed: () {
                             /* setState(() {
                              networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                              });*/
                            },
                            icon: Icon(Icons.school,color: Color.fromARGB(255, 158, 158, 158)),
                          )
                        ),
                        Container(
                          width: 30.0,
                          height: 30.0,
                          // color: Colors.brown,
                          child : postss[index]['isFreezed']
                          ?  IconButton(
                            onPressed: () {
                             /* setState(() {
                                print(postss[index]['_id']);
                               // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                //super.initState();                                
                              });*/
                            },
                            icon: Icon(Icons.lock_outlined,color: Colors.red,),
                          )
                          :  IconButton(                         
                            onPressed: () {
                            /*  setState(() {
                                print(postss[index]['_id']);
                                networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                //super.initState();                                
                              });*/
                            },
                            icon: Icon(Icons.lock_open_outlined,color: Colors.green,),
                          )
                        ),
                        
                      ],)
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 480.0,
                //  color: Colors.amber,
                child: Column(
                  children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Container(
                            //   height: 80.0,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(20),
                            //  color: Colors.blue,
                            child: ReadMoreText(
                              postss[index]['postContent'],
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
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        )

                        // color: Colors.blue,

                        ),
                    Container(
                      width: 411.0,
                      height: 380.0,
                      decoration: BoxDecoration(
                       image: DecorationImage(
                        image: NetworkImage("http://localhost:5000/"+ postss[index]['postImg']),
                        fit: BoxFit.cover,
                      )),

                      //  color: Color.fromARGB(255, 243, 117, 45),
                    )
                 
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 30.0,
                // color: Colors.green,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                            width: 80,
                            height: 30,
                            //color: Colors.blue,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.check,
                                  color: Color(0xff003566),
                                  size: 17,
                                ),
                                Text(
                                  postss[index]['appliedStuId'].length.toString(),
                                  style: TextStyle(color: Color(0xff003566)),
                                )
                              ],
                            ))
                      ],
                    ),
                  ],
                ),
              ),
              Container(child: Divider()),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 30.0,
                //  color: Colors.pink,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              if(postss[index]['isFreezed']==true){
                                 _showDialog(context,'We apologize, the application for this training has ended');
                              }
                              else if(widget.stu['available']==false){
                                _showDialog(context,'You already In Training ');
                              }
                              else if(widget.stu['request']==true && widget.stu['available']==true){
                                _showDialog(context,'You already request plz wait company reply .');
                              }                              
                              else if(widget.stu['available']==true && postss[index]['isUni']==true && widget.stu['universityTraining']==true){
                                _showDialog(context,'You already Finshed Your University Training ');
                              }
                              else{
                                setState(() {
                                isCliked=true;
                                ss=postss[index]['appliedStuId'];//.add(studentinfo['RegNum']);
                                ss.add(widget.stu['RegNum']);
                                });
                                networkHandlerC.updateapllidStuId( postss[index]['_id'], ss);
                                networkHandler.updatepostidstud(widget.stu['RegNum'],postss[index]['_id'],true);
                              }
                            },
                            iconSize: 25,
                            icon: Icon(Icons.check),                           
                            color:postss[index]['isFreezed']
                             ? Color.fromARGB(255, 105, 103, 98)
                             : widget.stu['request']
                                ? widget.stu['postid']== postss[index]['_id']
                                ?  Color(0xffffc300)
                                : Color.fromARGB(255, 105, 103, 98)
                                : Color.fromARGB(255, 4, 57, 97),
                            
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "Request",
                              style: TextStyle(
                                  color: postss[index]['isFreezed']
                             ? Color.fromARGB(255, 105, 103, 98)
                             : widget.stu['request']
                                ? widget.stu['postid']== postss[index]['_id']
                                ?  Color(0xffffc300)
                                : Color.fromARGB(255, 105, 103, 98)
                                : Color.fromARGB(255, 4, 57, 97),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            iconSize: 20,
                            icon: Icon(Icons.person_add_alt),
                            color: Color(0xff003566),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              postss[index]['seats'].toString(),
                              style: TextStyle(
                                  color: Color(0xff003566),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(

                      child: Row(
                        
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            iconSize: 20,
                            icon: Icon(Icons.lock_clock_outlined),
                            color: Colors.red,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
        
                              postss[index]['lockDate'],
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                
              )
            ],
          ),
        ),
      ],
    ),
          );
                  
                  },
                  childCount: postss.length,
                ),
              ),
            ]
      )
       
      : Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
    }
}
 

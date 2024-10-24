import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:untitled4/Tabs/viewTrainee.dart';
import 'package:untitled4/postHomePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/HomePage.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled4/ratingReivews.dart';
import 'package:untitled4/showStudents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

//import 'package:read_more_text/read_more_text.dart';

class HomeScreen extends StatefulWidget {
  late String token="";
  HomeScreen({required this.token});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

Future<List<Map<String, dynamic>>> fetchPosts(String companyId) async {
    final response = await http.get(Uri.parse("http://localhost:5000/post/posts/$companyId"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<Map<String, dynamic>> posts = [];

      for (var item in jsonData) {
        posts.add(item);
      }

      return posts;
    } else {
      throw Exception("faild : ${response.body}");
    }
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDataReady=false;
  late double rate;
  List<Map<String, dynamic>> postss = [];
  DateTime? dateTime ;
  DateTime? temp ;
  DateTime? currentDate ;
  List<Map<String, dynamic>> reversedItems=[];
  Map<String, dynamic>  companyinfo={};
  final storage = FlutterSecureStorage();

    final networkHandlerC = NetworkHandlerC();
  String? IDC ;

    @override
void initState() {
  super.initState();
  currentDate = DateTime.now();
  
  fetchData().then((_) {
    setState(() {
       postss = List.from(reversedItems.reversed);
      isDataReady = true; // Set the flag to true when data is fetched
    });
    });
}

Future<void> fetchData() async {
  try {
    IDC = await networkHandlerC.getidddd();
    print(IDC);

    companyinfo = await networkHandlerC.fetchCompanyData(IDC!);
    companyinfo.values.forEach((value) {
      print(value);
    });
    

    dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS").parse(companyinfo["BD"]);

    reversedItems = await fetchPosts(IDC!);
    for (var map in reversedItems) {
      map.forEach((key, value) {
        if(key=="lockDate"){
          //for(int i=0;i<value.length;i++){
            print(value);
            List<String> ll=value.toString().split("-");
            print(ll);
          if(currentDate!.year>int.parse(ll[0]) || (currentDate!.year==int.parse(ll[0]) && currentDate!.month>int.parse(ll[1])) || (currentDate!.year==int.parse(ll[0]) && currentDate!.month==int.parse(ll[1]) && currentDate!.day>int.parse(ll[2]))){
           networkHandlerC.updateIsFreezed(map['_id'], true);
          }
        }
        print('$key: $value');
      });
    }
   /* setState(() {
    isDataReady=true;      
    });*/

  } catch (error) {
    print(error);
  }
}

  void sendPushMessage(String token, String body , String title ,String type )async{
    try{
      print("////////////////////////////////////////////////////////////////Sending");
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers:<String,String>{
          'Content-Type':'application/json',
          'Authorization':'key=AAAAmDSv3W4:APA91bELF6hUFbbWYjwqVxszPYU7273f886c9VezyyMoi2xHzzT398GwtbxQ7ecmomD9s40KleqUU0yl5NZNiuF7FRBu77cbbtWgG8pY8QqZFyTxcCPXKXNJU1a0wfmQRPB208jhNOn-'
        },
        body: jsonEncode(
          <String,dynamic>{
            'priority':'high',
            'data':{
              'click_action':'FLUTTER_NOTIFICATION_CLICK',
              'status':'done',
              'body':body,
              'title':title,
              'ID':IDC,
              'img':companyinfo['img'],
              'name':companyinfo['Name'],
              'type':type,
            },
            "notification":<String,dynamic>{
              "title":title,
              "body":body,
              "android_channel_id":"dbfood"
            },
            "to":token,
          }
        )
      );
    }catch(e){
      if(kDebugMode){
        print("Error sending push notification: $e");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(

      body: isDataReady
      ? CustomScrollView(
        shrinkWrap: true,
            slivers: [
              SliverAppBar(
                leading: Icon(Icons.arrow_back_ios,color: Color.fromARGB(255, 255, 255, 255),),
                backgroundColor: Colors.white,
                expandedHeight: 380.0, // Set the height you want for the flexible space
                flexibleSpace: FlexibleSpaceBar(
                 
                 background://Column(children: [     
                  Padding(
                    padding:EdgeInsets.only(top: 5.0),
                    child :Container(          
                      width: MediaQuery.of(context).size.width,
                      height: 370,
                      //margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade400, blurRadius: 13.0)
                      ]),
                    child : Column(
                    children: [
                    Row(children: [
                      companyinfo['isdeldete']
                        ?Container(
                          margin: EdgeInsets.only(top: 5,left: 12),
                        child:IconButton(onPressed:() {
                          List<String> ss=companyinfo['deletedate'].split('T');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return  MyDialog2(companyinfo['reason'],ss[0]); // Your custom dialog content goes here
                          },
                        );                          
                        }, icon: Icon(Icons.warning_rounded,color: Colors.redAccent,size: 30,)),)
                        :Container(width: 40,),
                        // ),
                      Container(
                        margin: EdgeInsets.only(top: 5,left: 297),
                        child:IconButton(onPressed:() {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return  MyDialog(companyinfo['ID'],companyinfo['Name'],companyinfo['img'],companyinfo['Password']); // Your custom dialog content goes here
                          },
                        );
                         
                        }, icon: Icon(Icons.close,color: Color(0xff003566),))),
                    ],),
                    Container(
                    margin: EdgeInsets.only(top: 0),
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
                                        trainee(companyinfo['trainee'],companyinfo['ID']),));
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
                  Container(height: 20,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        //padding: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width,
                        height: 50.0,
                        margin: EdgeInsets.only(top: 0, bottom: 10),
                        // color: Color(0xff003566),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                  onPressed: () async{

                                          setState(() {
                                            isDataReady=false;
                                          });
                                      Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => HomePost(onDataRefresh: ()async{   
                                      fetchData().then((_) {
                                      setState(() {
                                        postss = List.from(reversedItems.reversed);
                                        isDataReady = true; // Set the flag to true when data is fetched
                                      });
                                      });} ,cn :companyinfo['Name'],id :companyinfo['ID'],img :companyinfo['img']),
                                    ));
                                        },
                                        icon: Icon(
                                          Icons.post_add,
                                          color: Color(0xff003566),
                                          size: 33.0,
                                        ),
                                        )
                                  ],
                                ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0, top: 0,right: 0),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                          width: 1.0, color: Colors.grey.shade400),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(60.0))),
                                  onPressed: () {
                                           setState(() {
                                            isDataReady=false;
                                          });
                                      Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => HomePost(onDataRefresh: ()async{   
                                      fetchData().then((_) {
                                      setState(() {
                                        postss = List.from(reversedItems.reversed);
                                        isDataReady = true; // Set the flag to true when data is fetched
                                      });
                                      });} ,cn :companyinfo['Name'],id :companyinfo['ID'],img :companyinfo['img']),
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
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    //Divider(height: 5,color: Color.fromARGB(255, 88, 88, 88),)
                    ]),
                      ),
                  // Positioned(
                    //child:  
              ),
                  
              //  ],) 
                ),
              ),
              postss.isEmpty 
              ?SliverToBoxAdapter(child: Center(child: Text('No posts available.'),),)
              : SliverList(
                
                delegate: SliverChildBuilderDelegate(
                 //rever 
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
                              width: 200.0,
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
                          child : postss[index]['appliedStuId'].length==0
                          ?  IconButton(                         
                            onPressed: () {
                             /* setState(() {
                              networkHandlerC.updateIsFreezed(postss[index]['_id'], false);                                
                              });*/
                            },
                            icon: Icon(Icons.visibility_outlined,color: Color.fromARGB(255, 240, 105, 105)),
                          )
                          :IconButton(
                            onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => showStu(postid: postss[index]['_id'],CID: companyinfo['ID'],cname: companyinfo['Name'],cimg: companyinfo['img'], studentsid: postss[index]['appliedStuId'],onDataRefresh: ()async{   
                                    fetchData().then((_) {
                                      setState(() {
                                        postss = List.from(reversedItems.reversed);
                                        isDataReady = true; // Set the flag to true when data is fetched
                                      });
                                      });
                                      }
                                      )
                                      )
                                      );
                            },
                            icon: Icon(Icons.visibility_outlined,color: Colors.greenAccent
                            ))
                        ),
                        Container(
                          width: 30.0,
                          height: 30.0,
                          // color: Colors.brown,
                          child : postss[index]['isRemotly']
                          ?  IconButton(
                            onPressed: () {
                              setState(() {
                                print(postss[index]['_id']);
                               // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                //super.initState();                                
                              });
                            },
                            icon: Icon(Icons.videocam_outlined,color: const Color.fromARGB(255, 89, 54, 244),),
                          )
                          :  IconButton(                         
                            onPressed: () {
                              setState(() {
                                print(postss[index]['_id']);
                               // networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                //super.initState();                                
                              });
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
                              setState(() {
                                print(postss[index]['_id']);
                               // networkHandlerC.updateIsFreezed(postss[index]['_id'], false);
                                //super.initState();                                
                              });
                            },
                            icon: Icon(Icons.lock_outlined,color: Colors.red,),
                          )
                          :  IconButton(                         
                            onPressed: () {
                              setState(() {
                                print(postss[index]['_id']);
                                networkHandlerC.updateIsFreezed(postss[index]['_id'], true);
                                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MyHomePage(0)));
                                //super.initState();                                
                              });
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
                    /* Padding(
                      padding: const EdgeInsets.only(left: 160),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              width: 170,
                              height: 30,
                              //  color: Colors.blue,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    comments,
                                    style: TextStyle(color: Color(0xff003566)),
                                  )
                                ],
                              ))
                        ],
                      ),
                    )*/
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
                      /* width: 137,
                      height: 30.0,*/
                      // color: Colors.yellow,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            iconSize: 25,
                            icon: postss[index]['isUni']
                            ? Icon(Icons.date_range_sharp)
                            : Icon(Icons.timelapse),
                            color:  Color.fromARGB(255, 21, 28, 82),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              postss[index]['isUni']
                              ? postss[index]['semester']
                              :  postss[index]['hours'].toString(),
                              style: TextStyle(
                                  color:  Color.fromARGB(255, 21, 28, 82),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      /*  width: 137,
                      height: 30.0,*/
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            iconSize: 20,
                            icon: postss[index]['isUni']
                            ? Icon(Icons.timelapse)
                            :Icon(Icons.person_add_alt),

                            color: Color(0xff003566),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              postss[index]['isUni']
                              ? postss[index]['hours'].toString()
                              : postss[index]['seats'].toString(),
                              style: TextStyle(
                                  color: Color(0xff003566),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      /*   width: 137,
                      height: 30.0,*/
                      //color: Colors.yellow,
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
 
class MyDialog extends StatelessWidget {
  //bool submit=false;
  late String CImg;
  late String name;
  late String ID;
  late String pwd;
  MyDialog(this.ID,this.name,this.CImg,this.pwd);
  final TextEditingController confirmid =TextEditingController();
  final TextEditingController reason =TextEditingController();
  final networkHandlerC = NetworkHandlerC();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 380,
        height: 390,
        // decoration: BoxDecoration( borderRadius: BorderRadius.circular(20),color: const Color.fromARGB(255, 255, 255, 255)),
        //padding: EdgeInsets.all(16.0),
        child:AlertDialog(
           backgroundColor: Colors.white,
         title: Text(

              'Delete Confirmation',
              //textAlign:,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 1, 30, 92),
              ),
            ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10, top: 10
                    ),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(40.0),
                        border: Border.all(
                            //    color: Color(0xff003566),
                            style: BorderStyle.solid,
                            color: Colors.grey.shade400),
                        image:  DecorationImage(
                            image: NetworkImage("http://localhost:5000/" + CImg),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 25,
                        color: Color(0xff003566),
                          fontWeight: FontWeight.bold),
                    ),
                    padding: EdgeInsets.only(left: 10),
                  ),
                ],
              ),
              Container(height: 20,),
              /*Container(

              child: TextFormField(  
                                                
                    maxLines: 5,
                    minLines: 5,
                    controller: reason,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      // focusedBorder: In,
                      // Optionally, you can customize the appearance of the text field
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0),
                      hintText: "Please Write why you freeze relationship with NNU"
                    ),
                    enabled: true, // Set to false to disable the TextField
                    onChanged: (value) {
                      reason.text=value;
                    },
                  ),),*/

              /*SizedBox(height: 10,),
              Text(
                  'Please enter the your ID:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 30, 92),
                  ),
                ),
              Container(

                  child: TextFormField(
                    controller: confirmid,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      //focusedBorder: InputBorder.none,
                      // Optionally, you can customize the appearance of the text field
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0),
                      hintText: "Confirm your ID"
                    ),
                    enabled:
                        true, 
                    onChanged: (value) {
                      confirmid.text=value;
                    },
                  ),

              ),*/
               SizedBox(height: 10,),
              Text(
                  'Please enter the your password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 30, 92),
                  ),
                ),
              Container(

                  child: TextFormField(
                    controller: reason,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      //focusedBorder: InputBorder.none,
                      // Optionally, you can customize the appearance of the text field
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0),
                      hintText: "Confirm your Password"
                    ),
                    enabled:
                        true, 
                    onChanged: (value) {
                      reason.text=value;

                    },
                  ),

              ),

              SizedBox(height: 30,),

          ],
        ),
        actions: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xff003566)), // Change color here
                ),
                onPressed: () {
                  if(pwd==reason.text){
                    networkHandlerC.deletecompany(ID);
                  }
                  // Close the dialog when the button is clicked
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Send',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
        ],
        ),
      //),
    );
  }
}
class MyDialog2 extends StatelessWidget {
  //bool submit=false;
  late String Reason;
  late String DelDate;
  MyDialog2(this.Reason,this.DelDate);
  final TextEditingController confirmid =TextEditingController();
  final TextEditingController reason =TextEditingController();
  //List<String> ss=DelDate.split('T');
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Your dialog content goes here
      child: Container(
        width: 380,
        height: 400,
         decoration: BoxDecoration( 
          //color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 350,
              alignment: Alignment.center,
              child: 
               Text("Deletion Alert",
                style: TextStyle(
                  fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 30, 92),
                  ),)
            ,),           
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10, top: 10
                    ),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(40.0),
                        border: Border.all(
                            //    color: Color(0xff003566),
                            style: BorderStyle.solid,
                            color: Colors.grey.shade400),
                        image:  DecorationImage(
                            image:AssetImage("images/najah.jpg"),
                            fit: BoxFit.cover)),
                  ),
                  Container(
                    child: Text(
                      "NNU",
                      style: TextStyle(
                        fontSize: 25,
                        color: Color(0xff003566),
                          fontWeight: FontWeight.bold),
                    ),
                    padding: EdgeInsets.only(left: 10),
                  ),
                ],
              ),
             // Container(height: 40,),
             // Container(

              //child:Column(
                //children: [
                Text("Reason of Deletion",
                style: TextStyle(
                  fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 30, 92),
                  ),),
               TextField(  
                    controller: TextEditingController(text: Reason),                            
                    maxLines: 5,
                    minLines: 5,
                    
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      
                       //border:,
                       focusedBorder: InputBorder.none,
                      // Optionally, you can customize the appearance of the text field
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0),
                     // hintText: "Please Write why you freeze relationship with NNU"
                    ),
                    enabled: false, // Set to false to disable the TextField
                  ),

               // ],
              //),
             // ),

              SizedBox(height: 10,),
              //Container(
                Text("Date of Deletion",
                style: TextStyle(
                  fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 30, 92),
                  ),),
                  //child: 
                  TextFormField(
                    controller: TextEditingController(text: DelDate),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      // Optionally, you can customize the appearance of the text field
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0),
                      //hintText: "Write Your ID here to confirm your request"
                    ),
                    enabled:
                        false, 
                  ),

              //),

              Divider(height: 30,),
              /*ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color(0xff003566)), // Change color here
                ),
                onPressed: () {
                  // Close the dialog when the button is clicked
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Send',
                  style: TextStyle(color: Colors.amber),
                ),
              ),*/
          ],
        ),
      ),
    );
  }
}
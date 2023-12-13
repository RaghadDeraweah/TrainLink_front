import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:untitled4/postHomePage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' as convert;

//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
//import 'package:logger/logger.dart';

//import 'package:read_more_text/read_more_text.dart';

class hc extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//String? contentPost =
//  "Happy HR Professional Day! 💙 \nBehind every successful organization lies an HR team dedicated to shaping company culture, fostering talent, managing compliance, and so much more. 🚀\n\n\nWe're privileged to partner with so many exceptional HR leaders across the globe, who passionately strive to make the service industry a better place - especially for frontline workers.\n We couldn't help but share some of their wisdom on this special day! 🎉⤵\n Events season is truly upon us! ⏳";

class _HomeScreenState extends State<hc> {
 


   bool filter=false;
   String? cityValue;
    List<Map<String, dynamic>> postss = [];
        final List<String> cities = [
      "Nablus",
      "Ramallah",
      "Tulkarm",
      "Salfit",
      "Hebron",
      "Jericho",
      "Qalqeileh",
      "Tubas",
      "Jenin",
      "48",
      "Jerusalem",
      "BethLahem"
      // Add more cities here
  ];
    @override
    void initState() {
    super.initState();
    // Fetch postss from the API and update the 'postss' list
     fetchPosts().then((fetchedPosts) {
      setState(() {
        postss = fetchedPosts;
      });
    });
    for(int i=0;i<postss.length;i++){
              print(postss[i]['cname']);
              //NetworkImage("http://localhost:5000/"+postss[index]['cimg']),
             // Color(0xffffc300),
             /* print(postss[i]['postDate']+"."+postss[i]['location']);
              print(postss[i]['appliedStuId'].length.toString());
              print(postss[i]['Seats'].toString());
              print(postss[i]['lockDate']);
              print(postss[i]['postContent']);*/}
  }
  Future<List<Map<String, dynamic>>> fetchPosts() async {
    final response = await http.get(Uri.parse("http://localhost:5000/post/posts"));

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
  @override
  Widget build(BuildContext context) {
       return Scaffold(
      appBar: AppBar(
        foregroundColor: Color(0xff003566),
        automaticallyImplyLeading: false,
       // title: Text('Horizontal Buttons AppBar'),
       leading:  IconButton(onPressed:  (){}, icon:Icon( Icons.filter_list)),
        actions: <Widget>[
            //IconButton(onPressed:  (){}, icon:Icon( Icons.filter_list)),
              DropdownButtonHideUnderline(                      
                    child: DropdownButton2<String>(                                         
                    isExpanded: true,
                    hint: const Row(
                      children: [
                        
                        Expanded(
                          child: Text(
                            'location',
                            style: TextStyle(
                              fontSize: 17,
                              //fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 107, 106, 106),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: cities.map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 17,
                                  //fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 80, 80, 80),
                                ),
                                overflow: TextOverflow.ellipsis,
                                selectionColor: Colors.amberAccent,
                              ),
                            ))
                        .toList(),
                    value: cityValue,
                     
                    onChanged: ( value) {
                      setState(() {
                        cityValue =  value;
                        filter=true;
                        //_SCity.text =cityValue!;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 57,
                      width: 160,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Color.fromARGB(255, 133, 133, 133),
                        ),
                        //fo
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      elevation: 0,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 17,
                      iconEnabledColor: Colors.grey,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      
                      direction: DropdownDirection.right,
                      maxHeight: 180,
                      width: 200,
                      decoration: BoxDecoration(
                        
                        borderRadius: BorderRadius.circular(14),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      offset: const Offset(155, 0),
                      scrollbarTheme: ScrollbarThemeData(                       
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all<double>(6),
                        thumbVisibility: MaterialStateProperty.all<bool>(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                  ),
                ),


        ],
      ),  
      body :ListView.builder(
        
        itemCount: postss.length,
        itemBuilder: (context, index) {
          if(filter){
            if(postss[index]['location']==cityValue){
                        return Card(
            child: Row(
            children: <Widget>[
        Container(
          width: 400.0,
          //   height: 660.0,
          // color: Colors.blue,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              width: 270.0,
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
                              width: 230.0,
                              height: 30.0,
                              // color: Colors.purple,
                              child: Text(
                               
                                postss[index]['postDate']+" "+postss[index]['location'],
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
                        Container(
                          width: 61.0,
                          height: 50.0,
                          // color: Colors.brown,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_horiz),
                          ),
                        )
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
                 /*   Container(
                      width: 411.0,
                      height: 380.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(imagePosts),
                        fit: BoxFit.cover,
                      )),

                      //  color: Color.fromARGB(255, 243, 117, 45),
                    )
                 */
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
                            icon: Icon(Icons.check),
                            color:  Color(0xffffc300),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "Request",
                              style: TextStyle(
                                  color:  Color(0xffffc300),
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
            }

          }
          else{
          return Card(
            child: Row(
            children: <Widget>[
        Container(
          width: 400.0,
          //   height: 660.0,
          // color: Colors.blue,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              width: 270.0,
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
                              width: 230.0,
                              height: 30.0,
                              // color: Colors.purple,
                              child: Text(
                               
                                postss[index]['postDate']+" "+postss[index]['location'],
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
                        Container(
                          width: 61.0,
                          height: 50.0,
                          // color: Colors.brown,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_horiz),
                          ),
                        )
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
                 /*   Container(
                      width: 411.0,
                      height: 380.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(imagePosts),
                        fit: BoxFit.cover,
                      )),

                      //  color: Color.fromARGB(255, 243, 117, 45),
                    )
                 */
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
                            icon: Icon(Icons.check),
                            color:  Color(0xffffc300),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "Request",
                              style: TextStyle(
                                  color:  Color(0xffffc300),
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
          }
/*return Card(
   child:Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Row(
      children: [
        Container(
          height: 50,
          width: 50,
          child: CircleAvatar(
        radius: 80, // Customize the radius as needed
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage("http://localhost:5000/"+postss[index]['cimg']),
      
      ),
      ), 
        Container(
          padding: EdgeInsets.only(left: 10),
          width: 290.0,
          height: 20.0,
          // color: Colors.pink,
          child: Text(
            postss[index]['cname'],
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
        padding: EdgeInsets.only(left: 10, top: 5),
        width: 290.0,
        height: 30.0,
        // color: Colors.purple,
        child: Text(
          postss[index]['postDate']+" "+postss[index]['location'],
          style: TextStyle(
              fontSize: 12.0,
              color: Colors.blueGrey[500]),
        ),
      ),
        Container(
          width: 61.0,
          height: 50.0,
          // color: Colors.brown,
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_horiz),
          ),
        )
      ],
     ),
     Text( postss[index]['postContent']),
    ],
   )
 );*/
           /*return Card(
            child: Column(
              children: [
                Text(postss[index]['cname']), // Company name
                Text(postss[index]['postContent']),
                              //Text(postss[index]['cname']),
             // NetworkImage("http://localhost:5000/"+postss[index]['cimg']),
//Text(    Color(0xffffc300)),
             Text(  postss[index]['postDate']+"."+postss[index]['location']),
             Text( postss[index]['appliedStuId'].length.toString()),
              Text(postss[index]['Seats'].toString()),
              Text(postss[index]['lockDate']),
              Text(postss[index]['postContent']), // Post content
                // Include other post details as needed, e.g., timestamp, images, etc.
              ],
            ),
          );*/
           /* StudentsPost(
                postss[index]['cname'], // Company name
//Text(postss[index]['cname']),
              NetworkImage("http://localhost:5000/"+postss[index]['cimg']),
             postss[index]['postDate'],
             postss[index]['location'],
             postss[index]['appliedStuId'].length.toString(),
              postss[index]['Seats'].toString(),
              postss[index]['lockDate'],
              postss[index]['postContent'], 
              );*/
            /*  "Harri",
              'images/Harri.jpeg',
              Color(0xffffc300),
              "Yesterday at 11:35 AM . Nablus",
              "21",
              "8 Seats",
              "15.Oct-9PM",
              "images/hr.jpeg",
              //contentPost),*/
        },),);}





  /*      return Scaffold(
      appBar: AppBar(
        title: Text('Post List'),
      ),
      body: ListView.builder(
        itemCount: postss.length,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              children: [
                Text(postss[index]['cname']), // Company name
                Text(postss[index]['postContent']), // Post content
                // Include other post details as needed, e.g., timestamp, images, etc.
              ],
            ),
          );
        },
      ),
    );
  }*/
 /*   return Container(
      child: ListView(
        children: <Widget>[
         /* Stack(
            alignment: Alignment(0, 0),
            children: [
              Container(
                  width: 400.0,
                  height: 280,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      /*border: Border.all(
                        width: 1,
                        color: Colors.grey.shade400,
                      ),*/
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade400, blurRadius: 13.0)
                      ])
                      ),
              Container(
                margin: EdgeInsets.only(bottom: 70),
                decoration: BoxDecoration(
                  /* border: Border.all(
                    width: 1,
                    color: Colors.grey.shade400,
                  ),*/
                  boxShadow: [
                    BoxShadow(color: Color(0xff003566), blurRadius: 13.0)
                  ],
                  borderRadius: BorderRadius.circular(100),
                  // margin: EdgeInsets.only(left: 50, bottom: 50),
                  image: DecorationImage(
                      image: AssetImage("images/Harri.jpeg"),
                      fit: BoxFit.cover),
                ),
                width: 100.0,
                height: 100,
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Harri",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    /*Divider(
                      color: Colors.grey.shade400,
                      thickness: 1,
                    ),*/
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      //   decoration: BoxDecoration(
                      //  border: Border.all(width: 3, color: Colors.grey)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(
                                Icons.star,
                                size: 24,
                                color: Color(0xffffc300),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  "8.9 Rating",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.person,
                                size: 24,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("210 Trainee",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.handshake,
                                size: 24,
                                color: Color(0xffffc300),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("2016",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 24,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("Nablus ",
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
                width: 410,
                height: 100,
                margin: EdgeInsets.only(top: 150),
                //  color: Colors.red,
              ),
            ],
          ),
          /*Divider(
            thickness: 1.0,
          ),*/
          Row(
            children: <Widget>[
              Container(
                width: 390.0,
                height: 50.0,
                margin: EdgeInsets.only(top: 10, bottom: 10),
                // color: Color(0xff003566),
                child: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.post_add,
                              color: Color(0xff003566),
                              size: 40.0,
                            ))
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 2.0),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    width: 1.0, color: Colors.grey.shade400),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(60.0))),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePost(),
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
          Divider(
            color: Colors.grey[320],
            thickness: 5.0,
          ),
          /* Row(
            children: [
              Container(
                width: 410.0,
                height: 10.0,
                color: Colors.black26,
              )
            ],
          ),*/*/

          StudentsPosts(
              "Harri",
              'images/Harri.jpeg',
              Color(0xffffc300),
              "Yesterday at 11:35 AM . Nablus",
              "21",
              "8 Seats",
              "15.Oct-9PM",
              "images/hr.jpeg",
              contentPost),
          StudentsPosts(
              "Harri",
              'images/Harri.jpeg',
              Color(0xff003566),
              " 2 hours ago  . Nablus",
              "20",
              "15 Seats",
              "1.Oct-11:59PM",
              "images/Sponser.png",
              "We Are HIRING!🚩 "),
          StudentsPosts(
              "Harri",
              'images/Harri.jpeg',
              Color(0xff003566),
              "10 mintes ago . Nablus",
              " - ",
              " - ",
              " - ",
              "images/harri-post22.png",
              "Breast Cancer 🎀"),
        ],
      ),
    );
  }*/
}
//proPic,
Widget StudentsPost(String cname,NetworkImage _cimg,String datep ,String Location,String requist,String seats,String lockDate,String contentPost,){
 return Card(
   child:Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     Row(
      children: [
        Container(
          height: 50,
          width: 50,
          child: CircleAvatar(
        radius: 80, // Customize the radius as needed
        backgroundColor: Colors.transparent,
        backgroundImage: _cimg
      
      ),
      ), 
        Container(
          padding: EdgeInsets.only(left: 10),
          width: 290.0,
          height: 20.0,
          // color: Colors.pink,
          child: Text(
            cname,
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
        padding: EdgeInsets.only(left: 10, top: 5),
        width: 290.0,
        height: 30.0,
        // color: Colors.purple,
        child: Text(
          datep+" "+Location,
          style: TextStyle(
              fontSize: 12.0,
              color: Colors.blueGrey[500]),
        ),
      ),
        Container(
          width: 61.0,
          height: 50.0,
          // color: Colors.brown,
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_horiz),
          ),
        )
      ],
     ),
     Text(contentPost),
    ],
   )
 );
}
Widget StudentsPosts(ProName,proPic, datep ,Location, requist,
    seats, lockDate, contentPost,) {//, imagePosts
  return Scaffold(
   // padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
    body: Row(
      children: <Widget>[
        Container(
          width: 411.0,
          //   height: 660.0,
          // color: Colors.blue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 411.0,
                height: 50.0,
                // color: Colors.amber,
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                                       image: proPic,
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              width: 290.0,
                              height: 20.0,
                              // color: Colors.pink,
                              child: Text(
                                ProName,
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
                              width: 290.0,
                              height: 30.0,
                              // color: Colors.purple,
                              child: Text(
                                datep+" "+Location,
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
                        Container(
                          width: 61.0,
                          height: 50.0,
                          // color: Colors.brown,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_horiz),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: 411.0,
                // height: 480.0,
                //  color: Colors.amber,
                child: Column(
                  children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Container(
                            //   height: 80.0,
                            width: 411.0,
                            padding: EdgeInsets.all(20),
                            //  color: Colors.blue,
                            child: ReadMoreText(
                              contentPost,
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
                 /*   Container(
                      width: 411.0,
                      height: 380.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(imagePosts),
                        fit: BoxFit.cover,
                      )),

                      //  color: Color.fromARGB(255, 243, 117, 45),
                    )
                 */
                  ],
                ),
              ),
              Container(
                width: 411.0,
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
                                  requist,
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
                width: 411.0,
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
                            icon: Icon(Icons.check),
                            color:  Color(0xffffc300),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "Request",
                              style: TextStyle(
                                  color:  Color(0xffffc300),
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
                            icon: Icon(Icons.person_add_alt),
                            color: Color(0xff003566),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              seats,
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
                              lockDate,
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
                child: Divider(
                  color: Colors.grey[320],
                  thickness: 5.0,
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

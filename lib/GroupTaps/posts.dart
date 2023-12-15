import 'package:flutter/material.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/Tabs/group.dart';
import 'package:readmore/readmore.dart';

import 'package:untitled4/HomePage.dart';
import 'package:untitled4/creategroupPost.dart';
import 'package:untitled4/login.dart';
import 'package:untitled4/postHomePage.dart';

String? name = "Flutter Fall23";
String? members;

/*class groupHomePage extends StatelessWidget {
  late String idgroup;
  late String CID;
  late String cname;
  late String cimg;
  groupHomePage(String _id,String CID ,String cname, String cimg){
    super.key;
    this.idgroup=_id;
    this.CID=CID;
    this.cname=cname;
    this.cimg=cimg;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
 debugShowCheckedModeBanner: false,
      home: Scaffold(

        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            color: const Color(0xffff003566),
            icon: const Icon(Icons.arrow_back),
            iconSize: 30,
            onPressed: () {
              Navigator.pop(context);
              // Navigator.push(context, MaterialPageRoute(builder: (context) { MyHomePageG();}));
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage(0) ));
            },
          ),
          backgroundColor: Colors.white,
          title: const Text(
            "",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: MyHomePageG( this.idgroup,this.CID,this.cname,this.cimg),
      ),
    );
  }
}*/

class groupHomePage extends StatefulWidget {
    late String idgroup;
  late String CID;
  late String cname;
  late String cimg;
  groupHomePage(String _id,String CID ,String cname, String cimg){
    super.key;
    this.idgroup=_id;
    this.CID=CID;
    this.cname=cname;
    this.cimg=cimg;
  }


  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

String? contentPost =
    "Happy HR Professional Day! 💙 \nBehind every successful organization lies an HR team dedicated to shaping company culture, fostering talent, managing compliance, and so much more. 🚀\n\n\nWe're privileged to partner with so many exceptional HR leaders across the globe, who passionately strive to make the service industry a better place - especially for frontline workers.\n We couldn't help but share some of their wisdom on this special day! 🎉⤵\n Events season is truly upon us! ⏳";

class _MyHomePageState extends State<groupHomePage> {
    Map<String, dynamic>  groupinfo={};
    List<Map<String,dynamic>> groupposts=[];
    final networkHandlerC = NetworkHandlerC();
    bool isDataReady=false;
void initState() {
  super.initState();
  fetchData().then((_) {
    setState(() {
      isDataReady = true; // Set the flag to true when data is fetched
    });
    });
}

Future<void> fetchData() async {
  try {


    groupinfo = await networkHandlerC.getGroupById(widget.idgroup);
    groupinfo.values.forEach((value) {
      print(value);
    });
    groupposts= await networkHandlerC.getGroupsposts(widget.idgroup);
    for (var map in groupposts) {
      map.forEach((key, value) {
        print('$key: $value');
      });
    }
    isDataReady=true;
  } catch (error) {
    print(error);
  }
}
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isDataReady
      ?  CustomScrollView(
        shrinkWrap: true,
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: 90.0, // Set the height you want for the flexible space
                flexibleSpace: FlexibleSpaceBar(
                 background:Column(children: [ 
               /* Stack(children: [
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
            ),*/
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
            ),*/
               /* Divider(
              thickness: 5,
            ),*/

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

                          Padding(
                            padding:
                                const EdgeInsets.only(left: 0, top: 2.0),
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
                          ),

                    ],
                  ),
                ),
                Divider(
                  thickness: 5,
                ),
                 ],
                 ),  
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GPosts(widget.cname,widget.cimg,groupposts[index]['postDate'],groupposts[index]['postImg'],groupposts[index]['content']);
                  },
                  childCount: groupposts.length,
                  ),
                  ),
              ],
              )

      /*SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: 411,
              height: 220,
              //   color: Colors.red,
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
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 17,
                      color: Colors.grey,
                    )
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
              width: 160,
              margin: EdgeInsets.only(right: 210, top: 10),
              child: MaterialButton(
                color: Colors.blue,
                textColor: Colors.white,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(Icons.group_add_sharp),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Joined",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down_sharp)
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 5,
            ),
            Column(
              children: [
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
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 5,
                ),
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
            )
          ],
        ),
      )*/
      : Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }
}

Widget GPosts(String ProName,String proPic,String dateAndLocation,String imagePosts,String contentPost) {
  return Padding(
    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
    child: Row(
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
                                        image: NetworkImage("http://localhost:5000/"+ proPic),
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
                                dateAndLocation,
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
                              contentPost!,
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
                        image: NetworkImage("http://localhost:5000/"+ imagePosts),
                        fit: BoxFit.cover,
                      )),

                      //  color: Color.fromARGB(255, 243, 117, 45),
                    )
                  ],
                ),
              ),
             /* Container(
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
                  ],
                ),
              ),*/
              Container(child: Divider()),
            /*  Container(
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
                            color: requistColor,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              "Request",
                              style: TextStyle(
                                  color: requistColor,
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
            */
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

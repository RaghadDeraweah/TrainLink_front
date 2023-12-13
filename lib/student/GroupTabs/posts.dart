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

class groupHomePage extends StatefulWidget {
  late String idgroup;
  groupHomePage(String _id){
    super.key;
    this.idgroup=_id;
    }
  @override

  _MyHomePageState createState() => _MyHomePageState();
}



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
/*              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: 90.0, // Set the height you want for the flexible space
                flexibleSpace: FlexibleSpaceBar(
                 background:Column(children: [
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
              */
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GPosts(groupinfo['cname'],groupinfo['cimg'],groupposts[index]['postDate'],groupposts[index]['postImg'],groupposts[index]['content']);
                  },
                  childCount: groupposts.length,
                  ),
                  ),
              ],
              )
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
              Container(child: Divider()),

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

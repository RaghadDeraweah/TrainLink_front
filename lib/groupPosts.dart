import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
//import 'package:read_more_text/read_more_text.dart';

class GroupScreenPosts extends StatefulWidget {
  @override
  _GroupScreenPostsState createState() => _GroupScreenPostsState();
}

String? contentPost =
    "Happy HR Professional Day! 💙 \nBehind every successful organization lies an HR team dedicated to shaping company culture, fostering talent, managing compliance, and so much more. 🚀\n\n\nWe're privileged to partner with so many exceptional HR leaders across the globe, who passionately strive to make the service industry a better place - especially for frontline workers.\n We couldn't help but share some of their wisdom on this special day! 🎉⤵\n Events season is truly upon us! ⏳";

class _GroupScreenPostsState extends State<GroupScreenPosts> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(children: <Widget>[
     // Text("dalia"),
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
    ]));
  }
}

Widget StudentsPosts(ProName, proPic, requistColor, dateAndLocation, requist,
    seats, lockDate, imagePosts, contentPost) {
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
                                        image: AssetImage(proPic),
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
                        image: AssetImage(imagePosts),
                        fit: BoxFit.cover,
                      )),

                      //  color: Color.fromARGB(255, 243, 117, 45),
                    )
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

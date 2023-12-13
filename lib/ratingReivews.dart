import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class ratingReviews extends StatefulWidget {
  var name;
  var photo;
  late List<dynamic> ratings;
  ratingReviews(this.photo, this.name,this.ratings);
  @override
  _ratingReviewsState createState() => _ratingReviewsState(this.photo, this.name,this.ratings);
}

class _ratingReviewsState extends State<ratingReviews> {
  String namee;
  String photoo;
  late List<dynamic> ratings;
  _ratingReviewsState(this.photoo, this.namee,this.ratings);
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
                "Ratings and reviews",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    /*color: Colors.teal*/
                    color: Color(0xff003566)),
              ),
            ),
            body: ListView.builder(
              itemCount: ratings.length,
              itemBuilder: (context, index) {
                return noti(ratings[index]['rate'],ratings[index]['img'],ratings[index]['name'],ratings[index]['des'],ratings[index]['framework']);
              },
              ),
            ));
  
  }
}

Widget noti(numberStar, photo33, name33, contentpost33,framework) {
  bool s1 = false, s2 = false, s3 = false, s4 = false, s5 = false;
  if (numberStar == 1) {
    s1 = true;
  } else if (numberStar == 2) {
    s2 = true;
    s1 = true;
  } else if (numberStar == 3) {
    s1 = true;
    s2 = true;
    s3 = true;
  } else if (numberStar == 4) {
    s1 = true;
    s2 = true;
    s3 = true;
    s4 = true;
  } else if (numberStar == 5) {
    s1 = true;
    s2 = true;
    s3 = true;
    s4 = true;
    s5 = true;
  }
  return MaterialButton(
    onPressed: () {},
    // padding: const EdgeInsets.all(8.0),
    child: Container(
      margin: EdgeInsets.only(top: 5),
      width: 411,
      height: 170,

      //margin: EdgeInsets.only(bottom: 2),
      //  color: Colors.transparent,
      // color: Colors.red,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                //margin: EdgeInsets.only(bottom: 60),
                decoration: BoxDecoration(
                    // color: Colors.yellow,
                    borderRadius: BorderRadius.circular(60),
                    image: DecorationImage(
                        image: NetworkImage("http://localhost:5000/"+photo33), fit: BoxFit.cover)),
              ),
              Container(
                width: 200,
                //        color: Colors.yellow,
                margin: EdgeInsets.only(left: 10),
                //color: Colors.amber,
                padding: EdgeInsets.only(top: 15, bottom: 10),
                child: Text(
                  name33,
                  // textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                // alignment: Alignment.topLeft,
              ),
            ],
          ),
          Column(
            children: [
              Container(
                width: 320,
                //  color: Colors.grey,
                margin: EdgeInsets.only(top: 5, left: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(
                            (s1) ? Icons.star : Icons.star_border,
                            color: (s1) ? Color(0xffffc300) : Colors.black,
                            size: 20,
                          ),
                          Icon(
                            (s2) ? Icons.star : Icons.star_border,
                            color: (s2) ? Color(0xffffc300) : Colors.black,
                            size: 20,
                          ),
                          Icon(
                            (s3) ? Icons.star : Icons.star_border,
                            color: (s3) ? Color(0xffffc300) : Colors.black,
                            size: 20,
                          ),
                          Icon(
                            (s4) ? Icons.star : Icons.star_border,
                            color: (s4) ? Color(0xffffc300) : Colors.black,
                            size: 20,
                          ),
                          Icon(
                            (s5) ? Icons.star : Icons.star_border,
                            color: (s5) ? Color(0xffffc300) : Colors.black,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                      Text(
                        "( "+framework+" )",
                        style: TextStyle(
                          color: Color(0xffffc300),
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      )
                    ],),
                    /*Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(
                            (s1) ? Icons.star : Icons.star_border,
                            color: (s1) ? Color(0xffffc300) : Colors.black,
                            size: 20,
                          ),
                          Icon(
                            (s2) ? Icons.star : Icons.star_border,
                            color: (s2) ? Color(0xffffc300) : Colors.black,
                            size: 20,
                          ),
                          Icon(
                            (s3) ? Icons.star : Icons.star_border,
                            color: (s3) ? Color(0xffffc300) : Colors.black,
                            size: 20,
                          ),
                          Icon(
                            (s4) ? Icons.star : Icons.star_border,
                            color: (s4) ? Color(0xffffc300) : Colors.black,
                            size: 20,
                          ),
                          Icon(
                            (s5) ? Icons.star : Icons.star_border,
                            color: (s5) ? Color(0xffffc300) : Colors.black,
                            size: 20,
                          ),
                        ],
                      ),
                    ),*/
                    Container(
                      //     color: Colors.green,
                      width: 320,
                      height: 50,
                      margin: EdgeInsets.only(top: 5, left: 5),
                      //  color: Colors.amber,
                      //padding: EdgeInsets.only(bottom: 5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ReadMoreText(
                          contentpost33!,
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
                    ),
                   /* Container(
                      //    color: Colors.red,
                      child: Text(time33),
                      margin: EdgeInsets.only(right: 210),
                    )*/
                  ],
                ),
              ),
            ],
          ),
          Divider()
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:untitled4/massegesContent.dart';

String? name = "Flutter Fall23";
String? members;

class masseges extends StatelessWidget {
  const masseges({super.key});

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
            "Masseges",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: SingleChildScrollView(
                padding: EdgeInsets.only(top: 15),
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      width: 411,
                      height: 70,
                      // color: Colors.red,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 370,
                            child: TextField(
                              enabled: true,
                              maxLines: 1,
                              minLines: 1,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  hintText: "Search",
                                  contentPadding: EdgeInsets.all(2),
                                  prefixIcon: Icon(Icons.search),
                                  iconColor: Color(0xff003566),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color: const Color(0xff003566),
                                          width: 10))),
                            ),
                          )
                        ],
                      ),
                    ),
                    msgMe("images/studentBoy.jpeg", "Ahmad Khalel",
                        "You : Good Jop 🤩👏", "1 minutes ago", context),
                    msgMe("images/studentBoy.jpeg", "Waleed Asad",
                        "Waleed Asad : Thanks 🙏", "5 minutes ago", context),
                    msgMe(
                        "images/studentGirl.jpeg",
                        "Sally Qasem",
                        "Sally Qasem : Please Bos...",
                        "10 minutes ago",
                        context),
                    msgMe("images/studentBoy.jpeg", "Basem Ahmad",
                        "Basem Ahmad : Boss yes..", "50 minutes ago", context),
                  ],
                ))));
  }
}

Widget msgMe(photo33, name33, contentpost33, time33, context) {
  return MaterialButton(
    onPressed: () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyHomePagee(
                photo33,
                name33,
              )));
    },
    // padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 411,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400, width: 1)),
      margin: EdgeInsets.only(bottom: 10),
      //color: Color.fromARGB(50, 255, 196, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                image: DecorationImage(
                    image: AssetImage(photo33), fit: BoxFit.cover)),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Column(
              children: [
                Container(
                  width: 200,

                  //color: Colors.amber,
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  child: Text(
                    name33,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  // alignment: Alignment.topLeft,
                ),
                Container(
                    width: 200,
                    // color: Colors.amber,
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      contentpost33,
                    )),
                Container(
                    width: 200,
                    //  color: Colors.amber,
                    child: Text(
                      time33,
                      style: TextStyle(color: Colors.grey.shade500),
                    ))
              ],
            ),
          ),
          Icon(Icons.more_horiz)
        ],
      ),
    ),
  );
}

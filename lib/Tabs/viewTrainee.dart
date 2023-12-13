import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/student/Tabs/menu.dart';

class trainee extends StatefulWidget {
  late List<dynamic> trainees;
  trainee(this.trainees);
  @override
  _traineeState createState() => _traineeState(this.trainees);
}

class _traineeState extends State<trainee> {
  late List<dynamic> trainees;
  final networkHandler = NetworkHandlerS();
  late Map<String,dynamic> studentinfo;
  _traineeState(this.trainees);
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
                "Trainee",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    /*color: Colors.teal*/
                    color: Color(0xff003566)),
              ),
            ),
            body: ListView.builder(
              itemCount: trainees.length,
              itemBuilder: (context, index) => ListTile(
                title: traineesview(trainees[index]['img'],trainees[index]['name']),
                onTap: () async{
                  studentinfo= await networkHandler.fetchStudentData(trainees[index]['RegNum']);
                  print(studentinfo);
                  studentinfo.values.forEach((value) {
                    print(value);
                  });
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Menu(false,studentinfo)));
                  
                },
              ),
            )));
  }
}

Widget traineesview(photo33, name33) {
  return MaterialButton(
    onPressed: () {},
    // padding: const EdgeInsets.all(8.0),
    child: Container(
      padding: EdgeInsets.only(top: 10,left: 10),
      width: 411,
      height: 80,

      margin: EdgeInsets.only(bottom: 2),
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
                // margin: EdgeInsets.only(bottom: 60),
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
          Divider()
        ],
      ),
    ),
  );
}

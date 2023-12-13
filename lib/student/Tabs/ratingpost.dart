// ignore: file_names
import 'package:flutter/material.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/student/companypage.dart';


bool s1 = false, s2 = false, s3 = false, s4 = false, s5 = false;

class RatingPost extends StatefulWidget {
  late Map<String,dynamic> stu;
  late List<String> frameworks;
    late String ID;
 /* var name;
  var photo;*/
  RatingPost(this.stu,this.ID,this.frameworks);

  @override
  // ignore: library_private_types_in_public_api
  _RatingPostState createState() => _RatingPostState(this.stu,this.ID,this.frameworks);
}

class _RatingPostState extends State<RatingPost> {
  late Map<String,dynamic> stu;
  late String ID;
  Map<String,dynamic> companyinfo={};
  final networkHandlerC = NetworkHandlerC();
  final networkHandler = NetworkHandlerS();
  TextEditingController des=TextEditingController();
  late int rate;
  String dropdownValue = "Framework";
  late List<String> frameworks;
 /* String namee;
  String photoo;*/
  _RatingPostState(this.stu,this.ID,this.frameworks);
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    frameworks.add("Framework");
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
            "Ratings and reviews",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: Container(
          height: 780,
          width: 411.0,
          //color: Colors.amber,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(children: [
                  Container(
                    width: 411,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              border: Border.all(
                                  //    color: Color(0xff003566),
                                  style: BorderStyle.solid,
                                  color: Colors.grey.shade400),
                              image: DecorationImage(
                                  image: NetworkImage("http://localhost:5000/"+stu['img']),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            stu['fname']+" "+stu['lname'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    //   color: Colors.blue,
                  ),
                  Container(
                    width: 411,
                    height: 40,
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Ratings and reviews is available for you.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Container(
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              s1 = true;
                              s2 = false;
                              s3 = false;
                              s4 = false;
                              s5 = false;
                              rate=1;
                            });
                          },
                          icon: (s1)
                              ? Icon(
                                  Icons.star,
                                  color: Color(0xffffc300),
                                )
                              : Icon(Icons.star_border),
                          iconSize: 35,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              s1 = true;
                              s2 = true;
                              s3 = false;
                              s4 = false;
                              s5 = false;
                              rate=2;
                            });
                          },
                          icon: (s2)
                              ? Icon(
                                  Icons.star,
                                  color: Color(0xffffc300),
                                )
                              : Icon(Icons.star_border),
                          iconSize: 35,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              s1 = true;
                              s2 = true;
                              s3 = true;
                              s4 = false;
                              s5 = false;
                              rate=3;
                            });
                          },
                          icon: (s3)
                              ? Icon(
                                  Icons.star,
                                  color: Color(0xffffc300),
                                )
                              : Icon(Icons.star_border),
                          iconSize: 35,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              s1 = true;
                              s2 = true;
                              s3 = true;
                              s4 = true;
                              s5 = false;
                              rate=4;
                            });
                          },
                          icon: (s4)
                              ? Icon(
                                  Icons.star,
                                  color: Color(0xffffc300),
                                )
                              : Icon(Icons.star_border),
                          iconSize: 35,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              s1 = true;
                              s2 = true;
                              s3 = true;
                              s4 = true;
                              s5 = true;
                              rate=5;
                            });
                          },
                          icon: (s5)
                              ? Icon(
                                  Icons.star,
                                  color: Color(0xffffc300),
                                )
                              : Icon(Icons.star_border),
                          iconSize: 35,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 411,
                    height: 700,

                    //  color: Colors.green,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextFormField(
                                controller: des,
                                maxLength: 500,
                                keyboardType: TextInputType.text,
                                maxLines: 5,
                                minLines: 1,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(width: 1.7)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            width: 1.7,
                                            color: Color(0xffffc300))),
                                    hintText:
                                        "Describe your experience (optional) "),
                                onChanged: (value) {
                                  des.text=value;
                                },                              
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all( width: 1.7,
                                           // color: Color.fromARGB(255, 29, 29, 29)
                                           ),
                                 borderRadius: BorderRadius.circular(10),
                              ),
                              width: 395,
                              padding: EdgeInsets.only(top:2,bottom: 2,left: 5),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                autofocus: true,
                                dropdownColor: Colors.amber,
                            menuMaxHeight: 200,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16),
                            alignment: Alignment.center,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: frameworks.map((String name){
                          return DropdownMenuItem(
                          child: Text(name),
                          value: name,
 
                          );

                         }).toList(),
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_drop_down_rounded),
                          ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 130,
                                  height: 50,
                                  margin: EdgeInsets.only(
                                      right: 20, bottom: 100, top: 20),
                                  // color: const Color.fromARGB(255, 210, 165, 218),
                                  child: MaterialButton(
                                    child: Text("POST"),
                                    color: Color(0xffffc300),
                                    textColor: Colors.black,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    onPressed: () async{
                                      for(int i=0;i<widget.stu['finishedGroups'].length;i++){
                                        if(dropdownValue==widget.stu['finishedGroups'][i]['framework']){
                                          widget.stu['finishedGroups'][i]['isRated']=true;
                                        }
                                      }
                                      Map<String,dynamic> ratingvar={
                                        'RegNum':widget.stu['RegNum'],
                                        'name':stu['fname']+" "+stu['lname'],
                                        'img':widget.stu['img'],
                                        'des':des.text,
                                        'framework':dropdownValue,
                                        'rate':rate
                                      };
                                      companyinfo = await networkHandlerC.fetchCompanyData(widget.ID);
                                      companyinfo['rating'].add(ratingvar);
                                      networkHandler.updatefinishedcourses(widget.stu['RegNum'], widget.stu['finishedGroups']);
                                      networkHandlerC.updaterating(ID,  companyinfo['rating']);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';

class Reports22 extends StatefulWidget {
  late Map<String,dynamic> stuinfo={};
  Reports22(Map<String,dynamic> stuinfo){super.key;
  this.stuinfo=stuinfo;}
  @override
  _Reports22State createState() => _Reports22State();
}



class _Reports22State extends State<Reports22> {
  bool submit=false ;
  Map<String,dynamic> currentreport={};
  Map<String,dynamic> groupinfo={};
  bool isDataReady=false;
  final networkHandlerC = NetworkHandlerC();
  final networkHandler1 = NetworkHandlerS();
  String dropdownValueWeeks = "Week";
  List<Map<String,dynamic>> reports=[];
  TextEditingController _controllerD = TextEditingController(text: "0");
  TextEditingController _controllerH = TextEditingController(text: "0");
  TextEditingController _controllerN = TextEditingController(text: "0");
  TextEditingController _controllerEX = TextEditingController();
  TextEditingController _work = TextEditingController();
  int counterAddD = 0;
  int counterAddH = 0;
  int counterAddN = 0;
  bool? AddFlagD = false;
  bool? RemoveFlagD = false;
  bool? AddFlagH = false;
  bool? RemoveFlagH = false;
  bool? AddFlagN = false;
  bool? RemoveFlagN = false;
  int minD=0;
  int maxD=6;
  int maxlenD=1;
  int minH=0;
  int maxH=48;
  int maxlenH=2;
  int minN=0;
  int maxN=48;
  int maxlenN=2;
  Future<void> fetchData() async {
  try {
    reports= await networkHandlerC.getReportsStudent(widget.stuinfo['groupid'],widget.stuinfo['RegNum']);
    print(reports);
    groupinfo= await networkHandlerC.getGroupById(widget.stuinfo['groupid']);
    print(groupinfo);
    print(widget.stuinfo);
    isDataReady=true;
  } catch (error) {
    print(error);
  }
}
void initState() {
  super.initState();
  fetchData().then((_) {
    setState(() {
      isDataReady = true; // Set the flag to true when data is fetched
    });
    });
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: isDataReady
            ?SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  Container(
                    width: 411,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Submit your reports ",
                        style: TextStyle(
                            color: Color(0xff003566),
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ),
                    //  color: Colors.amber,
                  ),
                  Divider(
                    color: Color(0xffffc300),
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                     Container(
                        margin: EdgeInsets.only(top: 10,left: 10),
                        width: 200,
                        height: 50,
                        // color: Colors.blue,
                        child: DropdownButtonFormField<String>(
                          menuMaxHeight: 200,
                          padding: EdgeInsets.only(left: 0),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16),
                          alignment: Alignment.center,
                          onChanged: (String? newValue) {
                            setState(() {
                                _controllerD = TextEditingController(text: "0");
                                _controllerH = TextEditingController(text: "0");
                               _controllerN = TextEditingController(text: "0");
                                 counterAddD = 0;
                                 counterAddH = 0;
                                 counterAddN = 0;
                                 AddFlagD = false;
                                 RemoveFlagD = false;
                                 AddFlagH = false;
                                 RemoveFlagH = false;
                                 AddFlagN = false;
                                 RemoveFlagN = false;
                                 minD=0;
                                 maxD=6;
                                 maxlenD=1;
                                 minH=0;
                                 maxH=48;
                                 maxlenH=2;
                                 minN=0;
                                 maxN=48;
                                 maxlenN=2;
                              dropdownValueWeeks = newValue!;
                              currentreport={};  
                              submit=false;
                            if(reports.length !=0){ 
                            for(int i=0;i<reports.length;i++ ){
                                  if( reports[i]['week']==newValue){
                                   // setState(() {
                                    currentreport=reports[i];
                                    submit=true;                                      
                                   // });
                                    print(currentreport) ;  
                                    print(submit) ;  
                                  }
                              } }                                                         
                            });  

                              //print(currentreport) ;                  
                          },
                          items: [
                            DropdownMenuItem(
                              child: Text(
                                "Week",
                              ),
                              value: "Week",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 1",
                              ),
                              value: "Week1",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 2",
                              ),
                              value: "Week2",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 3",
                              ),
                              value: "Week3",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 4",
                              ),
                              value: "Week4",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 5",
                              ),
                              value: "Week5",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 6",
                              ),
                              value: "Week6",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 7",
                              ),
                              value: "Week7",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 8",
                              ),
                              value: "Week8",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 9",
                              ),
                              value: "Week9",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 10",
                              ),
                              value: "Week10",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 11",
                              ),
                              value: "Week11",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 12",
                              ),
                              value: "Week12",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 13",
                              ),
                              value: "Week13",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 14",
                              ),
                              value: "Week14",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 15",
                              ),
                              value: "Week15",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 16",
                              ),
                              value: "Week16",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 17",
                              ),
                              value: "Week17",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 18",
                              ),
                              value: "Week18",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 19",
                              ),
                              value: "Week19",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 20",
                              ),
                              value: "Week20",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 21",
                              ),
                              value: "Week21",
                            ),
                          ],
                          value: dropdownValueWeeks,
                          icon: Icon(Icons.arrow_drop_down_rounded),
                        ),
                      ),
                   /*   Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 200,
                        height: 50,
                        // color: Colors.blue,+
                        child: DropdownButton<String>(
                          padding: EdgeInsets.only(left: 0),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16),
                          alignment: Alignment.center,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValueWeeks = newValue!;
                            });
                          },
                          items: [
                            DropdownMenuItem(
                              onTap: () {
                                setState(() {
                                  submit = true;
                                });
                              },
                              child: Text(
                                "Week 1",
                              ),
                              value: "Week1",
                            ),
                            DropdownMenuItem(
                              onTap: () {
                                setState(() {
                                  submit = false;
                                });
                              },
                              child: Text(
                                "Week 2",
                              ),
                              value: "Week2",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 3",
                              ),
                              value: "Week3",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Week 4",
                              ),
                              value: "Week4",
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "All Weeks",
                              ),
                              value: "AllWeeks",
                            )
                          ],
                          value: dropdownValueWeeks,
                          icon: Icon(Icons.arrow_drop_down_rounded),
                        ),
                      ),
*/                     
                     submit
                     ? Container(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14.0),
                              margin: EdgeInsets.only(left: 10),
                              child: Center(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.amber), // Change color here
                                  ),
                                  onPressed: () {
                                    // Show the dialog when the button is clicked
                                    //if(submit){}
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return MyDialog(this.submit,groupinfo['cname'],groupinfo['cimg'],currentreport['companyFeedback'],currentreport['universityFeedback']); // Your custom dialog content goes here
                                      },
                                    );
                                  },
                                  child: Text(
                                    'View comments',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                     : Container(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14.0),
                              margin: EdgeInsets.only(left: 10),
                              child: Center(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.amber), // Change color here
                                  ),
                                  onPressed: () async{
                                    String id= await networkHandlerC.addreport(widget.stuinfo['groupid'], widget.stuinfo['RegNum'], widget.stuinfo['fname']+" "+widget.stuinfo['lname'], widget.stuinfo['img'], dropdownValueWeeks, _controllerH.text, _controllerD.text, _controllerN.text, _controllerEX.text, _work.text);
                                    if(id.length>5){print("report added");}
                                  },
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 390,
                    height: 1110,
                    color: Colors.white,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Text("Status Report :"),
                              submit
                                  ? Text("Submitted",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold))
                                  : Text("Not Submitted",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Color.fromARGB(96, 255, 196, 0),
                              borderRadius: BorderRadius.circular(20)),
                          height: 100,
                          width: 400,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.baseline,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Student id : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    widget.stuinfo['RegNum'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Student name : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    widget.stuinfo['fname']+" "+widget.stuinfo['lname'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )
                                ],
                              ),
                              /*Row(
                                children: [
                                  Text(
                                    "Week : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    dropdownValueWeeks,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )
                                ],
                              ),*/
                             /* Row(
                                children: [
                                  Text(
                                    "Training place : ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    "Asal Comapny",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  )
                                ],
                              ),*/
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          padding:EdgeInsets.only(left: 10),
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(96, 255, 196, 0),
                              borderRadius: BorderRadius.circular(60)),
                          height: 50,
                          width: 410,
                          //padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Weekly working days :",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              submit
                              ? Container(
                                margin: EdgeInsets.only(left: 10),
                               /* decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey)),*/
                                child: Text(
                                  currentreport['DaysOfWeek'],
                                  style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),                                  
                                ),
                              )
                              : Container(
                                margin: EdgeInsets.fromLTRB(70, 4, 4, 4),
                               // margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _buildCounterButton(true, Icons.remove_outlined, () {
                                      RemoveFlagD = true;
                                      setState(() {
                                        if (counterAddD == minD) {
                                          counterAddD = minD;
                                          _controllerD.text = counterAddD.toString();
                                        } else {
                                          counterAddD--;
                                          _controllerD.text = counterAddD.toString();

                                          print(counterAddD);
                                        }
                                      });
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Container(
                                        alignment: Alignment.topCenter,
                                          width: 30,
                                          //       color: Colors.red,
                                          padding: EdgeInsets.only(bottom: 6),
                                          height: 50,
                                          // padding: EdgeInsets.all(10),
                                          child: TextField(
                                              // maxLength: maxlen,
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.number,
                                              controller: _controllerD,
                                              decoration: InputDecoration(
                                                //    labelText: _controller.text,
                                                labelStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Colors.black),
                                                border: InputBorder.none,
                                              ),
                                              onChanged: (value) {
                                                // Update the text value immediately
                                                setState(() {
                                                  int parsedValue = int.tryParse(value) ?? 0;
                                                  if (parsedValue <= maxD && parsedValue >= minD) {
                                                    setState(() {
                                                      _controllerD.text = value;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _controllerD.text = "0";
                                                    });
                                                  }
                                                });
                                              })),
                                    ),
                                    _buildCounterButton(false, Icons.add_outlined, () {
                                      this.AddFlagD = true;
                                      setState(() {
                                        if (this.counterAddD == maxD) {
                                          this.counterAddD = maxD;
                                          _controllerD.text = counterAddD.toString();
                                        } else {
                                          this.counterAddD++;
                                          _controllerD.text = counterAddD.toString();

                                          print(counterAddD);
                                        }
                                      });
                                    }),
                                  ],
                                ),
                              ),

                              // TextFormField()
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(96, 255, 196, 0),
                              borderRadius: BorderRadius.circular(60)),
                          height: 50,
                          width: 410,
                          padding:EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Weekly office hours :",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              submit
                              ? Container(
                                margin: EdgeInsets.only(left: 10),
                                /*decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey)),
                                */
                                child: Text(
                                  currentreport['hours'],
                                  style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),                                  
                                ),
                              )
                              : Container(
                                margin: EdgeInsets.fromLTRB(78, 4, 4, 4),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildCounterButton(true, Icons.remove_outlined, () {
                                      RemoveFlagH = true;
                                      setState(() {
                                        if (counterAddH == minH) {
                                          counterAddH = minH;
                                          _controllerH.text = counterAddH.toString();
                                        } else {
                                          counterAddH--;
                                          _controllerH.text = counterAddH.toString();

                                          print(counterAddH);
                                        }
                                      });
                                    }),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Container(
                                        alignment: Alignment.topCenter,
                                          width: 30,
                                          //       color: Colors.red,
                                          padding: EdgeInsets.only(bottom: 6),
                                          height: 50,
                                          // padding: EdgeInsets.all(10),
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                              // maxLength: maxlen,
                                              keyboardType: TextInputType.number,
                                              controller: _controllerH,
                                              decoration: InputDecoration(
                                                //    labelText: _controller.text,
                                                labelStyle: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                    color: Colors.black),
                                                border: InputBorder.none,
                                              ),
                                              onChanged: (value) {
                                                // Update the text value immediately
                                                setState(() {
                                                  int parsedValue = int.tryParse(value) ?? 0;
                                                  if (parsedValue <= maxH && parsedValue >= minH) {
                                                    setState(() {
                                                      _controllerH.text = value;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _controllerH.text = "0";
                                                    });
                                                  }
                                                });
                                              })),
                                    ),
                                    _buildCounterButton(false, Icons.add_outlined, () {
                                      this.AddFlagH = true;
                                      setState(() {
                                        if (this.counterAddH == maxH) {
                                          this.counterAddH = maxH;
                                          _controllerH.text = counterAddH.toString();
                                        } else {
                                          this.counterAddH++;
                                          _controllerH.text = counterAddH.toString();

                                          print(counterAddH);
                                        }
                                      });
                                    }),
                                  ],
                                ),
                              ),

                              // TextFormField()
                            ],
                          ),
                        ),
                      /*  Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(96, 255, 196, 0),
                              borderRadius: BorderRadius.circular(60)),
                          height: 50,
                          width: 410,
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Weekly field working hours :",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              CounterItem(0, 48, 2)

                              // TextFormField()
                            ],
                          ),
                        ),*/
                        Container(

                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(96, 255, 196, 0),
                              borderRadius: BorderRadius.circular(60)),
                          height: 50,
                          width: 410,
                          padding:EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Weekly absence hours :",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              submit
                              ? Container(
                                margin: EdgeInsets.only(left: 10),
                                /*decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey)),*/
                                child: Text(
                                  currentreport['nonattendancehours'],
                                  style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),                                  
                                ),
                              )                              
                              : Container(
                              margin: EdgeInsets.fromLTRB(60, 4, 4, 4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildCounterButton(true, Icons.remove_outlined, () {
                                    RemoveFlagN = true;
                                    setState(() {
                                      if (counterAddN == minN) {
                                        counterAddN = minN;
                                        _controllerN.text = counterAddN.toString();
                                      } else {
                                        counterAddN--;
                                        _controllerN.text = counterAddN.toString();

                                        print(counterAddN);
                                      }
                                    });
                                  }),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Container(
                                      alignment: Alignment.topCenter,
                                        width: 30,
                                        //       color: Colors.red,
                                        padding: EdgeInsets.only(bottom: 6),
                                        height: 50,
                                        // padding: EdgeInsets.all(10),
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                            // maxLength: maxlen,
                                            keyboardType: TextInputType.number,
                                            controller: _controllerN,
                                            decoration: InputDecoration(
                                              //    labelText: _controller.text,
                                              labelStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: Colors.black),
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (value) {
                                              // Update the text value immediately
                                              setState(() {
                                                int parsedValue = int.tryParse(value) ?? 0;
                                                if (parsedValue <= maxN && parsedValue >= minN) {
                                                  setState(() {
                                                    _controllerN.text = value;
                                                  });
                                                } else {
                                                  setState(() {
                                                    _controllerN.text = "0";
                                                  });
                                                }
                                              });
                                            })),
                                  ),
                                  _buildCounterButton(false, Icons.add_outlined, () {
                                    this.AddFlagN = true;
                                    setState(() {
                                      if (this.counterAddN == maxN) {
                                        this.counterAddN = maxN;
                                        _controllerN.text = counterAddN.toString();
                                      } else {
                                        this.counterAddN++;
                                        _controllerN.text = counterAddN.toString();

                                        print(counterAddN);
                                      }
                                    });
                                  }),
                                ],
                              ),
                            ),

                              // TextFormField()
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(96, 255, 196, 0),
                              borderRadius: BorderRadius.circular(20)),
                         // height: submit ? 100 : 150,
                          width: 410,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "If absent, provide reason :",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              submit
                              ? Container(
                                margin: EdgeInsets.all(4),
                                /*decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey)),*/
                                child: Text(
                                  currentreport['excuse'],
                                  style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),                                  
                                ),
                              )                              
                              : Container(
                                width: 300,
                                height: 120,
                                
                                // color: Colors.red,
                                child: TextFormField(
                                  controller: _controllerEX,
                                  maxLength: 100,
                                  maxLines: 5,
                                  minLines: 5,
                                  keyboardType: TextInputType.name,
                                  onSaved: (newValue) {
                                    setState(() {
                                      _controllerEX.text=newValue!;
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _controllerEX.text=value;
                                    });                                    
                                  },                                  
                                ),
                              ),

                              // TextFormField()
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(96, 255, 196, 0),
                              borderRadius: BorderRadius.circular(20)),
                          //height: submit? 100:300,
                          width: 410,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Weekly training summary :",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              submit
                              ? Container(
                                margin: EdgeInsets.all(4),
                                /*decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.grey)),*/
                                child: Text(
                                  currentreport['work'],
                                  style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),                                  
                                ),
                              )  
                              : Container(
                                width: 300,
                                height: 270,
                                // color: Colors.red,
                                child: TextFormField(
                                  controller: _work,
                                  maxLength: 1800,
                                  maxLines: 10,
                                  minLines: 10,
                                  keyboardType: TextInputType.name,
                                  onSaved: (newValue) {
                                    setState(() {
                                      _work.text=newValue!;
                                    });
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _work.text=value;
                                    });                                    
                                  },
                                ),
                              ),

                              // TextFormField()
                            ],
                          ),
                        ),
                       /* Container(
                          width: 130,
                          height: 50,
                          margin:
                              EdgeInsets.only(bottom: 100, top: 10, left: 250),
                          // color: const Color.fromARGB(255, 210, 165, 218),
                          child: MaterialButton(
                            child: Text("Submit"),
                            color: Colors.amber,
                            textColor: Colors.black,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            onPressed: () {},
                          ),
                        ),*/
                      ],
                    ),
                  )
                ]))
                :Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
                )
                );
 
  }
 InkWell _buildCounterButton(bool left, IconData icoon, VoidCallback onTap,
      [bool active = true]) {
    return InkWell(
      onTap: !active ? null : onTap,
      child: Container(
          decoration: BoxDecoration(
              color: active ? Colors.white : Colors.grey,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(left ? 20 : 0),
                right: Radius.circular(left ? 0 : 20),
              )),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
          child: Icon(icoon)),
    );
  }
}


/*class CounterItem extends StatefulWidget {
  int rangMin;
  int rangMax;
  int maxLengthh;
  CounterItem(this.rangMin, this.rangMax, this.maxLengthh, {Key? key})
      : super(key: key);

  @override
  State<CounterItem> createState() =>
      _CounterItemState(rangMin, rangMax, maxLengthh);
}

class _CounterItemState extends State<CounterItem> {
int counterAdd = 0;
bool? AddFlag = false;
bool? RemoveFlag = false;
  int min;
  int max;
  int maxlen;
  _CounterItemState(this.min, this.max, this.maxlen);
  final TextEditingController _controller = TextEditingController(text: "0");

 // String _textFieldValue = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCounterButton(true, Icons.remove_outlined, () {
            RemoveFlag = true;
            setState(() {
              if (counterAdd == min) {
                counterAdd = min;
                _controller.text = counterAdd.toString();
              } else {
                counterAdd--;
                _controller.text = counterAdd.toString();

                print(counterAdd);
              }
            });
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
                width: 30,
                //       color: Colors.red,
                padding: EdgeInsets.only(top: 6),
                height: 50,
                // padding: EdgeInsets.all(10),
                child: TextField(
                    // maxLength: maxlen,
                    keyboardType: TextInputType.number,
                    controller: _controller,
                    decoration: InputDecoration(
                      //    labelText: _controller.text,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      // Update the text value immediately
                      setState(() {
                        int parsedValue = int.tryParse(value) ?? 0;
                        if (parsedValue <= max && parsedValue >= min) {
                          setState(() {
                            _controller.text = value;
                          });
                        } else {
                          setState(() {
                            _controller.text = "0";
                          });
                        }
                      });
                    })),
          ),
          _buildCounterButton(false, Icons.add_outlined, () {
            this.AddFlag = true;
            setState(() {
              if (this.counterAdd == max) {
                this.counterAdd = max;
                _controller.text = counterAdd.toString();
              } else {
                this.counterAdd++;
                _controller.text = counterAdd.toString();

                print(counterAdd);
              }
            });
          }),
        ],
      ),
    )
    ;
  }

  InkWell _buildCounterButton(bool left, IconData icoon, VoidCallback onTap,
      [bool active = true]) {
    return InkWell(
      onTap: !active ? null : onTap,
      child: Container(
          decoration: BoxDecoration(
              color: active ? Colors.white : Colors.grey,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(left ? 20 : 0),
                right: Radius.circular(left ? 0 : 20),
              )),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
          child: Icon(icoon)),
    );
  }
}*/
/*
Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('name'),
        content: TextField(
          decoration: InputDecoration(hintText: 'Enter your '),
        ),
        actions: [TextButton(onPressed: () {}, child: Text('ok'))],
      ),
    );
*/

class MyDialog extends StatelessWidget {
  bool submit=false;
  late String companyFeedback;
  late String universityFeedback;
  late String CImg;
  late String name;
  MyDialog(this.submit,this.name,this.CImg,this.companyFeedback,this.universityFeedback);
  final TextEditingController _controller =TextEditingController();
  final TextEditingController _controller2 =
      TextEditingController(text: 'True information , keep going');

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Your dialog content goes here
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            submit
                ? Container(
                    width: 300,
                    height: 320,
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          color: Colors.amber.shade100,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 10,top: 10,
                                    ),
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        border: Border.all(
                                            //    color: Color(0xff003566),
                                            style: BorderStyle.solid,
                                            color: Colors.grey.shade400),
                                        image: const DecorationImage(
                                            image:
                                                AssetImage("images/najah.jpg"),
                                            fit: BoxFit.cover)),
                                  ),
                                  Container(
                                    child: Text(
                                      "NNU : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                ],
                              ),
                              Container(
                                height: 80,
                                width: 350,
                                padding: EdgeInsets.all(10),
                                //color: Colors.red,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: TextField(
                                    maxLines: 5,
                                    minLines: 5,
                                   // _controller =TextEditingController(text: universityFeedback),
                                    controller: TextEditingController(text: universityFeedback),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      // Optionally, you can customize the appearance of the text field
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                    ),
                                    enabled:
                                        false, // Set to false to disable the TextField
                                    /* decoration: InputDecoration(
                                      // Optionally, you can customize the appearance of the disabled text
                                      disabledBorder: OutlineInputBorder(
                                          // borderSide: BorderSide(color: Colors.grey),
                                          ),
                                    ),*/
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          height: 150,
                          color: Colors.amber.shade100,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 10, top: 10
                                    ),
                                    height: 50,
                                    width: 50,
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
                                          fontWeight: FontWeight.bold),
                                    ),
                                    padding: EdgeInsets.only(left: 10),
                                  ),
                                ],
                              ),
                              Container(
                                height: 80,
                                width: 350,
                                padding: EdgeInsets.all(10),
                                //color: Colors.red,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: TextField(
                                    maxLines: 5,
                                    minLines: 5,
                                    controller: TextEditingController(text: companyFeedback),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      // Optionally, you can customize the appearance of the text field
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                    ),
                                    enabled:
                                        false, // Set to false to disable the TextField
                                    /* decoration: InputDecoration(
                                      // Optionally, you can customize the appearance of the disabled text
                                      disabledBorder: OutlineInputBorder(
                                          // borderSide: BorderSide(color: Colors.grey),
                                          ),
                                    ),*/
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ))
                : Text('No comments Available'),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.amber), // Change color here
              ),
              onPressed: () {
                // Close the dialog when the button is clicked
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
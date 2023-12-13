import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class traingingg extends StatelessWidget {
  late Map<String,dynamic> stu;
   traingingg(this.stu);

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
            "Training",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
        body: MyHomePage(this.stu),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  late Map<String,dynamic> stu;
   MyHomePage(this.stu);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool containerVisible = false;
  bool containerVisible2 = false;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
       shrinkWrap: true,
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                expandedHeight: 250, // Set the height you want for the flexible space
                flexibleSpace: FlexibleSpaceBar(
                 background:Container(
                width: 360,
                height: 250,

                // color: Colors.yellow,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/training.jpeg"))),
                margin: EdgeInsets.only(top: 65),
              ) )
              ),
              widget.stu['finishedGroups'].isEmpty
              ? SliverToBoxAdapter(
                    child: Center(
                      // Display a message or an alternative widget
                      child: Text('You dont join to any traning'),
                    ),
                  )
              : SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Company(context,widget.stu['finishedGroups'][index]['cname'],widget.stu['finishedGroups'][index]['cimg'],containerVisible,widget.stu['finishedGroups'][index]['isUni'],widget.stu['finishedGroups'][index]['hours'],
                    widget.stu['finishedGroups'][index]['StartDate'],widget.stu['finishedGroups'][index]['EndDate'],
                    widget.stu['finishedGroups'][index]['mark'],              
                    () {
                      setState(() {
                        print("yes clicked");
                        containerVisible = !containerVisible;
                      });
                  },);
                  },
                  childCount: widget.stu['finishedGroups'].length ,
                  )
              )
            ]
    );
    /*return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Company(
              context,
              "Asal Technologies",
              "images/asal.jpeg",
              containerVisible,
              'University Training',
              '360',
              '4 months',
              'Pass',
              '10/10',
              '(Sep-2023)(Jan-2024)',
              () {
                setState(() {
                  print("yes clicked");
                  containerVisible = !containerVisible;
                });
              },
            ),
            Company(
                context,
                "ProGineer Technologies",
                "images/progineer.jpg",
                containerVisible2,
                'Out of university training',
                '100',
                '2 months',
                'Pass',
                '10/10',
                '(Mar-2023)(May-2023)', () {
              setState(() {
                print("yes clicked");
                containerVisible2 = !containerVisible2;
              });
            }),
            Container(
              width: 360,
              height: 360,

              // color: Colors.yellow,
              decoration: BoxDecoration(
                image: DecorationImage(
                      image: AssetImage("images/training.jpeg"))),
              margin: EdgeInsets.only(top: 125),
            )
          ],
        ),
      ),
    );*/
  }

  Widget Company(
    context,
    namecompany,
    image,
    containerVisible,
    _cTypeTrainText,
    _cnumberOfhoursText,
    start,
    end,
    mark,
    Function toggleVisibility,
  ) {
    final TextEditingController _cTypeTrain ;
    if(_cTypeTrainText==true){
       _cTypeTrain = TextEditingController(text: "University Training");
    }
    else{
      _cTypeTrain = TextEditingController(text: "Non University Training");
    }
    final TextEditingController _cnumberOfhours =
        TextEditingController(text: _cnumberOfhoursText.toString());
    final TextEditingController _cmonth =
        TextEditingController(text: "("+start+")-("+end+")");
    final TextEditingController _cstate ;
    final TextEditingController _cRange;
    if(mark>50){
      _cstate =TextEditingController(text: "Pass");
      int r=(mark/10).toInt();
      _cRange = TextEditingController(text: r.toString());
    }
    else{
      _cstate =TextEditingController(text: "Not Pass");      
      int r=mark/10;
      _cRange = TextEditingController(text: r.toString());
    }
    //_controllertimeyear
   /* final TextEditingController _ctimelevel =
        TextEditingController(text: _ctimelevelText);*/

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        // height: 600,
        color: Colors.white,
        child: Column(
          children: [
            Container(
                width: 400,
                // height: 450,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(30)),
                margin: EdgeInsets.only(top: 15, left: 5),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 50,

                      // color: Colors.yellow,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(190),
                          image: DecorationImage(
                              fit: BoxFit.cover, image: NetworkImage("http://localhost:5000/"+image))),
                      margin: EdgeInsets.all(10),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            namecompany,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 15, top: 5),
                            child: MaterialButton(
                              child: Text("Details"),
                              color: Color(0xff003566),
                              textColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              onPressed: () {
                                toggleVisibility();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: containerVisible,

                      //  padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "Kinds of training : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                width: 200,
                                child: TextField(
                                  //      enabled: StartYearState,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .black, // Set the text color to green
                                  ),
                                  controller: _cTypeTrain,
                                  // Optional: Style the text field
                                  decoration: InputDecoration(
                                    //   labelText: 'Field Label', // Change the label text if needed
                                    border: InputBorder
                                        .none, // Remove the default underline
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: containerVisible,
                      child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "Number of Hours : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                width: 200,
                                child: TextField(
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .black, // Set the text color to green
                                  ),
                                  controller: _cnumberOfhours,
                                  // Optional: Style the text field
                                  decoration: InputDecoration(
                                    //   labelText: 'Field Label', // Change the label text if needed
                                    border: InputBorder
                                        .none, // Remove the default underline
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    /*Visibility(
                      visible: containerVisible,
                      child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "Timeframe : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                width: 250,
                                //color: Colors.red,
                                child: TextField(
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .black, // Set the text color to green
                                  ),
                                  controller: _ctimelevel,
                                  // Optional: Style the text field
                                  decoration: InputDecoration(
                                    //   labelText: 'Field Label', // Change the label text if needed
                                    border: InputBorder
                                        .none, // Remove the default underline
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),*/
                    Visibility(
                      visible: containerVisible,
                      child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "Training Frame : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                width: 200,
                                child: TextField(
                                  //   enabled: GYState,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .black, // Set the text color to green
                                  ),
                                  controller: _cmonth,
                                  // Optional: Style the text field
                                  decoration: InputDecoration(
                                    //   labelText: 'Field Label', // Change the label text if needed
                                    border: InputBorder
                                        .none, // Remove the default underline
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: containerVisible,
                      child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "State :",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                width: 200,
                                child: TextField(
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .black, // Set the text color to green
                                  ),
                                  controller: _cstate,
                                  // Optional: Style the text field
                                  decoration: InputDecoration(
                                    //   labelText: 'Field Label', // Change the label text if needed
                                    border: InputBorder
                                        .none, // Remove the default underline
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: containerVisible,
                      child: Container(
                        margin: EdgeInsets.only(left: 15, top: 10),
                        child: Row(
                          children: [
                            Text(
                              "Range : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                                width: 200,
                                child: TextField(
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .black, // Set the text color to green
                                  ),
                                  controller: _cRange,
                                  // Optional: Style the text field
                                  decoration: InputDecoration(
                                    //   labelText: 'Field Label', // Change the label text if needed
                                    border: InputBorder
                                        .none, // Remove the default underline
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
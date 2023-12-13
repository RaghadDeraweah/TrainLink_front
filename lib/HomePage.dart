import 'package:flutter/material.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/Tabs/group.dart';
import 'package:untitled4/Tabs/home.dart';
import 'package:untitled4/Tabs/menu.dart';
import 'package:untitled4/Tabs/notifications.dart';
import 'package:untitled4/Tabs/reports.dart';
import 'package:untitled4/SearchStudent.dart';
import 'package:untitled4/home.dart';
import 'package:untitled4/masseges.dart';
import 'package:untitled4/welcome.dart';

class MyHomePage extends StatefulWidget {
  int selectedPage;
  MyHomePage(this.selectedPage);
  @override
  _MyHomePageState createState() => _MyHomePageState(selectedPage);
}

class _MyHomePageState extends State<MyHomePage> {
  final networkHandler = NetworkHandlerC();
  Map<String,dynamic> companyinfo={};
  int selectedPage;
  late String IDCompany;
  bool isDataReady=false;
  
  _MyHomePageState(this.selectedPage);
  @override
  void initState() {
  super.initState();
      fetchData().then((_) {
      setState(() {
        isDataReady=true;
         print("from Home"+IDCompany);
      });
      },);
}
Future<void> fetchData() async {
  try {
    IDCompany = await networkHandler.getidddd();
    print(IDCompany);
    companyinfo = await networkHandler.fetchCompanyData(IDCompany!);
    companyinfo.values.forEach((value) {
      print(value);
    });

    isDataReady=true;
  } catch (error) {
    print(error);
  }
}
  void logoutcompany() async {
    networkHandler.logout();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => welcome()),
        (route) => false);
    print("Log Out");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: selectedPage,
      length: 5,
      child: isDataReady
      ? Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "TrainLink",
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
          actions: <Widget>[
           /* IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChatListScreen(userId: IDCompany,)));
              },
              icon: Icon(Icons.search),
              color: Colors.black,
            ),*/

            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Home(this.companyinfo))); //masseges() ChScreen(userId:IDCompany,chatId: "Xngm883YAN4oEg7e0wwe")
              },
              icon: Icon(Icons.message),
              color: Colors.black,
            ),
            IconButton(
              onPressed: () {
                logoutcompany(); //masseges() ChScreen(userId:IDCompany,chatId: "Xngm883YAN4oEg7e0wwe")
              },
              icon: Icon(Icons.exit_to_app_rounded),
              color: Colors.black,
            ),
          ],
          //Tab Bar
          bottom: const TabBar(
            //isScrollable: true,
            unselectedLabelColor: Color(0xff003566),
            indicatorColor: Color(0xffffc300),
            labelColor: Color(0xffffc300),
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                  size: 28,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.groups,
                  size: 28,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.notifications_none,
                  size: 28,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.task_outlined,
                  size: 28,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.format_align_justify,
                  size: 28,
                ),
              ),
            ],
          ),
        ),

        //Tab Bar View
        body: TabBarView(
          children: <Widget>[
            HomeScreen(),
            GroupScreen(IDCompany,companyinfo['Name'],companyinfo['img']),
            Notification22(),
            Reports22( CID: IDCompany,),
            Forms(CID: IDCompany,),
          ],
        ),

      )
      :Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }
}

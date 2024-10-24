import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/student/Tabs/chatpage.dart';


class Home extends StatefulWidget {
  late Map<String,dynamic> stuinfo={};
   Home(Map<String,dynamic> stuinfo){
    super.key;
    this.stuinfo=stuinfo;
    }


  @override
  State<Home> createState() => _HomeState();
}

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }
class _HomeState extends State<Home> {
  String NNU="NNU";
  final networkHandler = NetworkHandlerS();
  final networkHandlerc = NetworkHandlerC();
  List<Map<String,dynamic>> companies=[];
  var companiesnames=[];
  bool search = false;
  String? myName, myProfilePic, myUserName, myEmail;
  Stream? chatRoomsStream;
  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String? myUsername =  widget.stuinfo['RegNum'];
    print(myUsername);
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("time", descending: true)
        .where("users", arrayContains: myUsername!)
        .snapshots();
  }
  getthesharedpref()  {
    myName =  widget.stuinfo['fname']+" "+widget.stuinfo['lname'];
    myProfilePic = widget.stuinfo['img'];
    myUserName = widget.stuinfo['RegNum'];
    myEmail = widget.stuinfo['SEmail'];
    setState(() {});
  }
  ontheload() async {
    await getthesharedpref();
    chatRoomsStream = await getChatRooms();
    companies= await networkHandlerc.fetchCompanies();
    print(companies);
    for(var map in companies){
      map.forEach((key, value) {
        if(key=="Name"){
          companiesnames.add(value);
        }
      });
    }
    print(companiesnames);
    setState(() {});
  }
  Widget ChatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    print(ds.id);
                    return ChatRoomListTile(
                        chatRoomId: ds.id,
                        lastMessage: ds["lastMessage"],
                        myUsername: myUserName!,
                        time: ds["lastMessageSendTs"],
                        sinfo:widget.stuinfo);
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  @override
  void initState() {
    super.initState();
    ontheload();
  }

  getChatRoomIdbyUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(String values) {
    if (values.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });
    //var capitalizedValue = values.substring(0, 1).toUpperCase() + values.substring(1);
    //print("capitalizedValue=$capitalizedValue");
    if (queryResultSet.isEmpty && values.length == 1) {
      for(var map in companies){
        map.forEach((key, value) {
          if(key=="Name"&& value.substring(0,1)==values){
              Map<String,dynamic> tempc={
              "type":"c",
              "Name":map['Name'],
              "ID":map['ID'],
              "Email":map['CEmail'],
              "img":map['img'],
            };
            queryResultSet.add(tempc);
           // queryResultSet.add(map);
          }
        });
      }
      if(NNU.substring(0,1)==values){
              Map<String,dynamic> tempc={
              "type":"c",
              "Name":"NNU Admin",
              "ID":"000",
              "Email":"Najah@gmail.com",
              "img":"uploads\\000.jpg",
            };
            queryResultSet.add(tempc);        
      }
      
      print("queryResultSet=$queryResultSet");
     /* DatabaseMethods().Search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });*/
     // queryResultSet.add(studentsnames.where((item) => item.toLowerCase().contains(value.toLowerCase()))
       //   .toList());      

    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        String temp=element['Name'];
        if (temp.startsWith(values)) {
          setState(() {
            tempSearchStore.add(element);
          });
          print("tempSearchStore=$tempSearchStore");
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff003566),
          onPressed: () {
           //Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage(0)));
           Navigator.of(context).pop();
            // print("yes");
          },
          child: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 156, 153, 205),
          ),
        ),
       resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff003566),
        body: Container(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 50.0, bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                search
                    ? Expanded(
                        child: TextField(
                        onChanged: (value) {
                          initiateSearch(value);
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search User',
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500)),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ))
                    : Text(
                        "ChatUp",
                        style: TextStyle(
                            color: Color.fromARGB(255, 156, 153, 205),
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
                GestureDetector(
                  onTap: () {
                    search = true;
                   setState(() {});
                  },
                  child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 1, 45, 87),
                          borderRadius: BorderRadius.circular(20)),
                      child: search
                          ? GestureDetector(
                              onTap: () {
                                search = false;
                                setState(() {});
                              },
                              child: Icon(
                                Icons.close,
                                color: Color.fromARGB(255, 154, 153, 205),
                              ),
                            )
                          : Icon(
                              Icons.search,
                              color: Color.fromARGB(255, 154, 153, 205),
                            )),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            width: MediaQuery.of(context).size.width,
            height: search
                ? MediaQuery.of(context).size.height / 1.19
                : MediaQuery.of(context).size.height / 1.15,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            //child: Column(
             // children: [
                child: search
                    ? ListView(
                        padding: EdgeInsets.only(left: 10.0, right: 5.0),
                        primary: false,
                        shrinkWrap: true,
                        children: tempSearchStore.map((element) {
                          return buildResultCard(element);
                        }).toList())
                    :    ChatRoomList(),
             // ],
           // ),
          ),
        ])));
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () async {
        search = false;

        var chatRoomId = getChatRoomIdbyUsername(myUserName!, data["ID"]);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUserName, data["ID"]],
        };
        await createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    name: data["Name"],
                    profileurl: data["img"],
                    username: data["ID"],
                    sinfo: widget.stuinfo,
                    chatid: chatRoomId,)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      "http://localhost:5000/"+data["img"],
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    )),
                SizedBox(
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["Name"],
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      data["Email"],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUsername, time;
  final Map<String,dynamic> sinfo;
  ChatRoomListTile(
      {required this.chatRoomId,
      required this.lastMessage,
      required this.myUsername,
      required this.time,
      required this.sinfo
      });

  @override
  State<ChatRoomListTile> createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
   final networkHandler = NetworkHandlerC();
   Map<String,dynamic>companyinfo={}; 
  String profilePicUrl = "", name = "", username = "", id = "";

  getthisUserInfo() async {
    username = widget.chatRoomId.replaceAll("_", "").replaceAll(widget.myUsername, "");
    print(username);
    if(username.length==5){
    companyinfo = await networkHandler.fetchCompanyData(username!);
    print(companyinfo);
    companyinfo.values.forEach((value) {
      print(value);
    });
    name=companyinfo['Name'];
    profilePicUrl=companyinfo['img'];
    id=companyinfo['ID'];
       setState(() {});
    }else if(username.length==3){
    name="NNU Admin";
    profilePicUrl="uploads\\000.jpg";
    id="000";
           setState(() {});
    }
   /* QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username.toUpperCase());
    name = "${querySnapshot.docs[0]["Name"]}";
    profilePicUrl = "${querySnapshot.docs[0]["Photo"]}";
    id = "${querySnapshot.docs[0]["Id"]}";*/
 
  }

  @override
  void initState() {
    getthisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                    name: name,
                    profileurl: profilePicUrl,
                    username: id,
                    sinfo: widget.sinfo,
                    chatid: widget.chatRoomId,)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profilePicUrl == ""
                ? CircularProgressIndicator()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      "http://localhost:5000/"+profilePicUrl,
                      height: 60,
                      width: 60,
                      fit: BoxFit.cover,
                    )),
            SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  child: Text(
                    widget.lastMessage,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
             /*   Text(
              
              widget.time,
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500),
            ),*/
              ],
            ),
            Spacer(),
           Text(
              
              widget.time,
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
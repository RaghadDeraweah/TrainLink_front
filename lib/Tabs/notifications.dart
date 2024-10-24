import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Notification22 extends StatefulWidget {
  late String cid="";
  Notification22(this.cid);
  @override
  _Notification22State createState() => _Notification22State();
}

class _Notification22State extends State<Notification22> {
    Stream? chatRoomsStream;
  Future<Stream<QuerySnapshot>> getChatRooms() async {
    return FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(widget.cid)
        .collection("notifications")
        .orderBy("time", descending: true)
        .snapshots();
  }
    ontheload() async {
    chatRoomsStream = await getChatRooms();
    setState(() {});
  }
    @override
  void initState() {
    super.initState();
    ontheload();
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
                   // print(ds.id);
                    return noti(ds['img'], ds['name'], ds['body'], ds['time'].toString());
                    /*ChatRoomListTile(
                        chatRoomId: ds.id,
                        lastMessage: ds["lastMessage"],
                        myUsername: myUserName!,
                        time: ds["lastMessageSendTs"],
                        sinfo:widget.stuinfo);*/
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }
  @override
  Widget build(BuildContext context) {
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
                   // print(ds.id);
                    return noti(ds['img'], ds['name'], ds['body'], ds['time'].toString());
                    /*ChatRoomListTile(
                        chatRoomId: ds.id,
                        lastMessage: ds["lastMessage"],
                        myUsername: myUserName!,
                        time: ds["lastMessageSendTs"],
                        sinfo:widget.stuinfo);*/
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
   /* return Scaffold(
            body: ListView.builder(
              itemCount: ,
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              noti("images/studentBoy.jpeg", "Ahmad Khalel",
                  "Requisted your announced..", "1 minutes ago"),
              noti("images/studentBoy.jpeg", "Waleed Asad",
                  "Requisted your announced..", "5 minutes ago"),
              noti("images/studentGirl.jpeg", "Sally Qasem",
                  "Requisted your announced..", "10 minutes ago"),
              noti("images/studentBoy.jpeg", "Basem Ahmad",
                  "Submitted a report..", "50 minutes ago"),
              noti("images/studentGirl.jpeg", "Jana Belal",
                  "Requisted your announced..", "1 hour ago"),
              noti("images/studentGirl.jpeg", "Amal Hassan",
                  "Submitted a report..", "2 hours ago"),
              noti("images/studentGirl.jpeg", "Jana Belal",
                  "Requisted your announced..", "1 hour ago"),
              noti("images/studentGirl.jpeg", "Amal Hassan",
                  "Submitted a report..", "2 hours ago"),
              noti("images/studentGirl.jpeg", "Jana Belal",
                  "Requisted your announced..", "1 hour ago"),
              noti("images/studentGirl.jpeg", "Amal Hassan",
                  "Submitted a report..", "2 hours ago"),
              noti("images/studentGirl.jpeg", "Jana Belal",
                  "Requisted your announced..", "1 hour ago"),
              noti("images/studentGirl.jpeg", "Amal Hassan",
                  "Submitted a report..", "2 hours ago"),
            ],
          ),
        )
        );*/
  }
}

Widget noti(photo33, name33, contentpost33, time33) {
  return MaterialButton(
    onPressed: () {},
    // padding: const EdgeInsets.all(8.0),
    child: Container(
      width: 411,
      height: 130,
      margin: EdgeInsets.only(bottom: 2),
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
           // flex: 2,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                image: DecorationImage(
                    image: NetworkImage("http://localhost:5000/"+photo33,), fit: BoxFit.cover)),
          ),),
          //Expanded(
            //flex: 1,
            //child: 
          Container(width: 5,),
          //),
         Expanded(
          flex: 4,
          child:
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
                   // padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      contentpost33,
                    )),
                /*Container(
                    width: 200,
                    //  color: Colors.amber,
                    child: Text(
                      time33,
                      style: TextStyle(color: Colors.grey.shade500),
                    ))*/
              ],
            ),
          ),
      ),
          Expanded(
            flex: 1,
            child:
          Icon(Icons.more_horiz),),
        ],
      ),
      
      Divider(),
      ],),

    ),
  );
}

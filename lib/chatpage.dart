//import 'dart:html';
//import 'dart:ui';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled4/home.dart';
//import 'package:messagingapp/pages/home.dart';
//import 'package:messagingapp/service/database.dart';
//import 'package:messagingapp/service/shared_pref.dart';
//import 'package:random_string/random_string.dart';


  Future AddMessage(String chatRoomId, String messageId,Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend( String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }
//done
  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }
    


class ChatPage extends StatefulWidget {
  String name, profileurl, username,chatid;
  Map<String,dynamic> cinfo;
  ChatPage(
      {required this.name, required this.profileurl, required this.username, required this.cinfo,required this.chatid});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  TextEditingController messagecontroller = new TextEditingController();
  String? myUserName, myProfilePic, myName, myEmail, messageId, chatRoomId;
  Stream? messageStream;

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
  length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

//done
  getthesharedpref() async {
    myUserName = widget.cinfo['ID'];
    myProfilePic = widget.cinfo['img'];
    myName = widget.cinfo['Name'];
    myEmail = widget.cinfo['CEmail'];

    chatRoomId = widget.chatid;//getChatRoomIdbyUsername(widget.username, myUserName!);
    print("chatRoomId==$chatRoomId");
    setState(() {});
  }
//done
  ontheload() async {
    await getthesharedpref();
    await getAndSetMessages();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ontheload();
    print(messageStream);
  }
//done
  getChatRoomIdbyUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      print("inside getChatRoomIdbyUsername");
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
//done
  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight:
                      sendByMe ? Radius.circular(0) : Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft:
                      sendByMe ? Radius.circular(24) : Radius.circular(0)),
              color: sendByMe
                  ? Color.fromARGB(255, 234, 236, 240)
                  : Color.fromARGB(255, 211, 228, 243)),
          child: Text(
            message,
            style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.w500),
          ),
        )),
      ],
    );
  }
//done
  Widget chatMessage() {
    return StreamBuilder(
        stream: messageStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.only(bottom: 90.0, top: 130),
                  itemCount: snapshot.data.docs.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return chatMessageTile(
                        ds["message"], myUserName == ds["sendBy"]);
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  addMessage(bool sendClicked) {
    if (messagecontroller.text != "") {
      String message = messagecontroller.text;
      messagecontroller.text = "";

      DateTime now = DateTime.now();
      String formattedDate = DateFormat('h:mma').format(now);
      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": formattedDate,
        "time": FieldValue.serverTimestamp(),
       // "imgUrl": myProfilePic,
      };
      messageId ??= getRandomString(10) ;
      //randomAlphaNumeric(10);

        AddMessage(chatRoomId!, messageId!, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": formattedDate,
          "time": FieldValue.serverTimestamp(),
          "lastMessageSendBy": myUserName,
        };
        updateLastMessageSend(chatRoomId!, lastMessageInfoMap);
        if (sendClicked) {
          messageId = null;
        }
      });
    }
  }
//done
  getAndSetMessages() async {
    messageStream = await getChatRoomMessages(chatRoomId);
    print("messageStream=$messageStream");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff003566),
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 50.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.12,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: chatMessage()
                ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home(widget.cinfo)));
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Color.fromARGB(255, 156, 153, 205),
                    ),
                  ),
                  SizedBox(
                    width: 90.0,
                  ),
                  Text(
                    widget.name,
                    style: TextStyle(
                        color: Color.fromARGB(255, 156, 153, 205),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
                margin:
                      EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              alignment: Alignment.bottomCenter,
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: TextField(
                    controller: messagecontroller,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type a message",
                        hintStyle: TextStyle(color: Colors.black45),
                        suffixIcon: GestureDetector(
                          onTap: (){
                            addMessage(true);
                          },
                          child: Icon(Icons.send_rounded))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/src/material/dropdown.dart';
import 'package:untitled4/createNewGroup.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;
  const Message({
    required this.text,
    required this.date,
    required this.isSentByMe,
  });
}

class MyHomePagee extends StatefulWidget {
  var name;
  var photo;
  MyHomePagee(this.photo, this.name);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageeState createState() => _MyHomePageeState(photo, name);
}

class _MyHomePageeState extends State<MyHomePagee> {
  String name;
  String photo;
  _MyHomePageeState(this.photo, this.name);
  List<Message> messages = [
    Message(
        text: 'Ok Boss, Do not worry , and thanks again 🤜🤛',
        date: DateTime.now().subtract(const Duration(days: 2, minutes: 8)),
        isSentByMe: false),
    Message(
        text:
            'And please resend to me tommorow to remember me to add a new task !',
        date: DateTime.now().subtract(Duration(days: 2, minutes: 7)),
        isSentByMe: true),
    Message(
        text: 'Ahmad ! notice that today is last day to submit soo',
        date: DateTime.now().subtract(Duration(days: 2, minutes: 6)),
        isSentByMe: true),
    Message(
        text: 'Ok , Thanks A lot🤝',
        date: DateTime.now().subtract(const Duration(days: 2, minutes: 5)),
        isSentByMe: false),
    Message(
        text:
            'Yes sure!,but notice that you have only one try to resend your another solution ',
        date: DateTime.now().subtract(Duration(days: 2, minutes: 4)),
        isSentByMe: true),
    Message(
        text:
            'Can I resend my task , beacause I noticed that i have some error points in my code?',
        date: DateTime.now().subtract(const Duration(days: 2, minutes: 3)),
        isSentByMe: false),
    Message(
        text: 'Yas Ahmad , go Ahead!',
        date: DateTime.now().subtract(const Duration(days: 2, minutes: 2)),
        isSentByMe: true),
    Message(
        text: 'Hello Boss , Can i ask a question?',
        date: DateTime.now().subtract(Duration(days: 2, minutes: 1)),
        isSentByMe: false),
    Message(
        text: 'Ok  , thanks Ahmad',
        date: DateTime.now().subtract(const Duration(days: 2, minutes: 3)),
        isSentByMe: true),
    Message(
        text: 'I wanna remeber you to add our new task !',
        date: DateTime.now().subtract(const Duration(days: 2, minutes: 3)),
        isSentByMe: false),
    Message(
        text: 'Hi Ahmad',
        date: DateTime.now().subtract(const Duration(days: 2, minutes: 2)),
        isSentByMe: true),
    Message(
        text: 'Hello Boss!',
        date: DateTime.now().subtract(const Duration(days: 2, minutes: 1)),
        isSentByMe: false),
    Message(
        text: 'Ok Boss, Do not worry , and thanks again 🤜🤛',
        date: DateTime.now().subtract(const Duration(days: 1, minutes: 8)),
        isSentByMe: false),
    Message(
        text:
            'And please resend to me tommorow to remember me to add a new task !',
        date: DateTime.now().subtract(Duration(days: 1, minutes: 7)),
        isSentByMe: true),
    Message(
        text: 'Ahmad ! notice that today is last day to submit soo',
        date: DateTime.now().subtract(Duration(days: 1, minutes: 6)),
        isSentByMe: true),
    Message(
        text: 'Ok , Thanks A lot🤝',
        date: DateTime.now().subtract(const Duration(days: 1, minutes: 5)),
        isSentByMe: false),
    Message(
        text:
            'Yes sure!,but notice that you have only one try to resend your another solution ',
        date: DateTime.now().subtract(Duration(days: 1, minutes: 4)),
        isSentByMe: true),
    Message(
        text:
            'Can I resend my task , beacause I noticed that i have some error points in my code?',
        date: DateTime.now().subtract(const Duration(days: 1, minutes: 3)),
        isSentByMe: false),
    Message(
        text: 'Yas Ahmad , go Ahead!',
        date: DateTime.now().subtract(const Duration(days: 1, minutes: 2)),
        isSentByMe: true),
    Message(
        text: 'Hello Boss , Can i ask a question?',
        date: DateTime.now().subtract(Duration(days: 1, minutes: 1)),
        isSentByMe: false),
    Message(
        text: 'Ok  , thanks Ahmad',
        date: DateTime.now().subtract(const Duration(days: 0, minutes: 3)),
        isSentByMe: true),
    Message(
        text: 'I wanna remeber you to add our new task !',
        date: DateTime.now().subtract(const Duration(days: 0, minutes: 3)),
        isSentByMe: false),
    Message(
        text: 'Hi Ahmad',
        date: DateTime.now().subtract(const Duration(days: 0, minutes: 2)),
        isSentByMe: true),
    Message(
        text: 'Hello Boss!',
        date: DateTime.now().subtract(const Duration(days: 0, minutes: 1)),
        isSentByMe: false),
  ].reversed.toList();

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
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                width: 45,
                height: 45,
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    image: DecorationImage(
                        image: AssetImage(photo), fit: BoxFit.cover)),
              ),
              Container(
                margin: EdgeInsets.only(right: 82),
                child: Text(
                  name,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      /*color: Colors.teal*/
                      color: Color(0xff003566)),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 30,
                ),
              )
            ]),
          ),
          body: Column(
            children: [
              Expanded(
                  child: GroupedListView<Message, DateTime>(
                padding: const EdgeInsets.all(8),
                reverse: true,
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                floatingHeader: true,
                elements: messages,
                groupBy: (message) => DateTime(
                    message.date.year, message.date.month, message.date.day),
                groupHeaderBuilder: (Message message) => SizedBox(
                  height: 40,
                  child: Center(
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          DateFormat.yMMMd().format(message.date),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                itemBuilder: (context, Message message) => Align(
                  alignment: message.isSentByMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: message.isSentByMe
                            ? Colors.blue
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    //  elevation: 8,

                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              message.isSentByMe ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 330,
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.blue),
                        borderRadius: BorderRadius.circular(30)),
                    child: TextFormField(
                      style: TextStyle(fontSize: 17),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(20),
                        border: InputBorder.none,
                        hintText: 'Type your message here...',
                      ),
                      onFieldSubmitted: (text) {
                        final message = Message(
                            text: text, date: DateTime.now(), isSentByMe: true);
                        setState(() => messages.add(message));
                      },
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        // color: Colors.red,
                        border: Border.all(width: 1, color: Colors.blue),
                        borderRadius: BorderRadius.circular(60)),
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.send,
                          color: Colors.blue,
                        )),
                  )
                ],
              )
            ],
          ),
        ));
  }
}

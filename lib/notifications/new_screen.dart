import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  final String info ;
  const NewPage({super.key, required this.info});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Messaging "),

      ),
      body: Center(
        child: Text(
          info
        ),
      ),
    );
  }
}

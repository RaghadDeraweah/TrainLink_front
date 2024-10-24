import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Linkrep extends StatelessWidget {

   String link;
  
  Linkrep(this.link);
  @override
  Widget build(BuildContext context) {
    return LinkWidget(this.link);
  }
}

class LinkWidget extends StatelessWidget {
    String Linnk="";

  LinkWidget(this.Linnk);
  //  String url = Linnk;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Link tapped'); // Add this debug statement
        _launchURL(Linnk);
      },
      child: Container(
        margin: EdgeInsets.only(top: 5,bottom: 5, left: 0),
        child: Text(
          'Click me to visit my project',
          style: TextStyle(
            color: const Color(0xffff003566),
            fontSize: 17,
            fontWeight: FontWeight.bold,
            //decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    print('Launching URL: $url');

    try {
      await launch(url);
      print('URL launched successfully');
    } catch (e) {
      print('Error launching URL: $e');
    }
  }
}
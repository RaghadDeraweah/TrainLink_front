import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
//import '../controllers/navigator_controllers.dart';
import 'package:untitled4/controllers//navigator_controllers.dart';
//import 'package:untitled4/signup.dart';

import '../utils/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

/////////////////////////////////////
//@CodeWithFlexz on Instagram
//
//AmirBayat0 on Github
//Programming with Flexz on Youtube
/////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: mainDrawer(0),
        appBar: AppBar(
          
          backgroundColor:Color.fromARGB(255, 14, 31, 182),
          actions : [
            
              IconButton(onPressed: (){
                showSearch(context: context, delegate: CustomSearch());
              }, icon: Icon(Icons.search)),
              IconButton(onPressed: (){}, icon: Icon(Icons.notifications))
          ]
          

        ),
        body: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Column(
            children: [


            ],
          ),
        ),
      ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: (){}, icon: Icon(Icons.close))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      close(context, null);
    }, icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text("context");
  }

}

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: SizedBox(
        width: w,
        height: h /7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Text("Hello"),
              color: Colors.amber,
            ),
            Text(
              "Delicious Salads",
              style: GoogleFonts.oxygen(
                fontSize: 35,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              " We made fresh and Healthy food",
              style: GoogleFonts.oxygen(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }



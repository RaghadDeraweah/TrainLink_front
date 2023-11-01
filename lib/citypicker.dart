import 'package:flutter/material.dart';


class MyDropdown extends StatefulWidget {
  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  String? selectedCity;
    List<String> cities = [
  "Nablus",
  "Ramallah",
  "Tulkarm",
  "Salfit",
  "Hebron",
  "Jericho",
  "Qalqeileh",
  "Tubas",
  "Jenin",
  "48",
  "Jerusalem",
  "BethLahem"
  // Add more cities here
];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            showCityPicker(context);
          },
          child: Container(
            padding: EdgeInsets.all(15),
             width: 412,
                  height: 57,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: Color.fromARGB(134, 0, 0, 0),
                  width: 1,
                ),),
            child: Text(selectedCity ?? "Select a City",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Color.fromARGB(255, 134, 134, 134)),),
          ),
        ),
      ],
    );
  }

  void showCityPicker(BuildContext context) {
    showDialog(
      
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 200,
            width: double.minPositive,
            child: ListView(
              clipBehavior: Clip.antiAlias,
              scrollDirection: Axis.vertical,
              //addRepaintBoundaries: true,
              shrinkWrap: true,
              children: cities.map((String city) {
                return ListTile(
                  
                   shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      
                   ),
                   
                 // style: ListTileStyle(lis),
                  //tileColor: Colors.amber,
                  focusColor: Colors.red,
                  hoverColor: Colors.blueAccent,
                  //selectedTileColor: Colors.deepOrange,
                  selectedColor: const Color.fromARGB(255, 5, 16, 77),
                  splashColor: Color.fromARGB(255, 28, 49, 240),
                  title: Text(city),
                  onTap: () {
                    setState(() {
                      selectedCity = city;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:untitled4/BStudent.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class personal extends StatefulWidget {
  late Map<String,dynamic> stuinfo={};
  personal(Map<String,dynamic> stuinfo){super.key;
  this.stuinfo=stuinfo;}

  @override
  _personalState createState() => _personalState();
}
    final List<String> cities = [
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
class _personalState extends State<personal> {
  Map<String,dynamic> unistu={};
   File? _image;
   bool edit=false;
  bool isDataReady=false;
  bool majorState = false;
  File? cv;
  //bool edit=false;
  final networkHandler = NetworkHandlerS();
  TextEditingController city = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController phonec = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController newpwd = TextEditingController();
  FocusNode focusNode = FocusNode();
  int calculateAge(DateTime birthdate, DateTime currentDate) {
  int age = currentDate.year - birthdate.year;

  // Check if the birthday has occurred this year
  if (currentDate.month < birthdate.month ||
      (currentDate.month == birthdate.month && currentDate.day < birthdate.day)) {
    age--;
  }

  return age;
}
  //TextEditingController _controllerGPA = TextEditingController(text: '-');
  Future<void> fetchData() async {
  try {
    unistu = await networkHandler.fetchUniStudentData( widget.stuinfo['RegNum']);
    city =TextEditingController(text: widget.stuinfo['city']);
     DateTime birthdate = DateTime.parse(widget.stuinfo['BD']);
    int agee = calculateAge(birthdate, DateTime.now());
    age = TextEditingController(text: agee.toString());
    gender = TextEditingController(text: widget.stuinfo['gender']);
    phonec = TextEditingController(text: widget.stuinfo['SPhone']);
    pwd = TextEditingController(text: widget.stuinfo['Password']);
    isDataReady=true;
  } catch (error) {
    print(error);
  }
}
  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        cv = File(result.files.single.path!);
      });
    }
  }
void initState() {
  super.initState();
  fetchData().then((_) {
    setState(() {
      isDataReady = true; // Set the flag to true when data is fetched
      print(widget.stuinfo);
    });
    });
}
Future<void> _getImage() async {

  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    setState(() {
      _image = File(pickedFile.path);
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset :false,
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
            "Personal",
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                /*color: Colors.teal*/
                color: Color(0xff003566)),
          ),
        ),
      body:isDataReady
      ?Container(
        child:Stack(
        children: [
         
          Positioned(
            top: 0,
            child:Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 5,left: 5),
            child: //widget.fromstu
            //? 
            Container( color: Color(0xff0F2C59),width: 1,) ,            
            width: 411,
            height: 200,
            decoration: BoxDecoration(
              color: Color(0xff0F2C59),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40)),
                    ),
          ),),

         Positioned(
            bottom: 0,
            child:Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 5,left: 5),
            child: //widget.fromstu
            //? 
            Container( color: Color(0xff0F2C59),width: 1,) ,            
            width: 411,
            height: 200,
            decoration: BoxDecoration(
              color: Color(0xff0F2C59),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40)),
                    ),
          ),),
          Positioned(
            right: 50,
            left: 50,
            top: 120,
            bottom: 100,
            child:Container(
              //padding: EdgeInsets.all(10),
              padding:EdgeInsets.only(top: 110,bottom: 10,right: 10,left: 10),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 202, 202, 202),
                borderRadius: BorderRadius.circular(10),
               // border: Border.all()
              ),
             child:Card(
              elevation: 0,
              color: Color.fromARGB(255, 202, 202, 202),
            child: Column(
              children: [
              edit 
              ? Container(
                  width: 413,
                  child : DropdownButtonHideUnderline(                      
                    child: DropdownButton2<String>(
                                          
                    isExpanded: true,
                    hint: const Row(
                      children: [
                        
                        Expanded(
                          child: Text(
                            'Select a City',
                            style: TextStyle(
                              fontSize: 17,
                              //fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 107, 106, 106),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: cities.map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 17,
                                  //fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 80, 80, 80),
                                ),
                                overflow: TextOverflow.ellipsis,
                                selectionColor: Colors.amberAccent,
                              ),
                            ))
                        .toList(),
                    value: city.text,
                    onChanged: (String? value) {
                      setState(() {
                        //cityValue = value;
                        city.text=value!;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 45,
                      width: 160,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Color.fromARGB(255, 133, 133, 133),
                        ),
                        //fo
                       // color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      elevation: 0,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 17,
                      iconEnabledColor: Colors.grey,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      
                      direction: DropdownDirection.right,
                      maxHeight: 180,
                      width: 200,
                      decoration: BoxDecoration(
                        
                        borderRadius: BorderRadius.circular(14),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      offset: const Offset(155, 0),
                      scrollbarTheme: ScrollbarThemeData(                       
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all<double>(6),
                        thumbVisibility: MaterialStateProperty.all<bool>(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                  ),
                ),
                )
              : Container(
                 padding: EdgeInsets.all(10),               
                width: 350,
                decoration: BoxDecoration(color: const Color.fromARGB(255, 202, 202, 202),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xff0F2C59))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_outlined,color:  Color(0xff0F2C59),size: 25,),
                  Container(width: 10,),
                  
                  Text(city.text, style: TextStyle(color: Color.fromARGB(255, 100, 100, 100),fontWeight: FontWeight.w500),)
                ],
              ),
              ),
              Container(height: 10,),
              edit
              ? Container(height: 1,)
              :Container(
                padding: EdgeInsets.all(10),                
                width: 350,
                decoration: BoxDecoration(color: const Color.fromARGB(255, 202, 202, 202),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xff0F2C59))),
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.person,color:  Color(0xff0F2C59),size: 25,),
                  Container(width: 10,),
                  Text(gender.text, style: TextStyle(color: Color.fromARGB(255, 100, 100, 100),fontWeight: FontWeight.w500),)
                ],
              ),
              ),
              Container(height: 10,),
              edit
              ?Container(height: 1,)
              :Container(
                padding: EdgeInsets.all(10),                
                width: 350,
                decoration: BoxDecoration(color: const Color.fromARGB(255, 202, 202, 202),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xff0F2C59))),
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.edit_calendar_outlined ,color:  Color(0xff0F2C59),size: 25,),
                  Container(width: 10,),
                  Text(age.text, style: TextStyle(color: Color.fromARGB(255, 100, 100, 100),fontWeight: FontWeight.w500),)
                ],
              ),
              ),
              Container(height: 10,),
              edit 
              ? Container(
                height: 70,
              child:IntlPhoneField(
                    focusNode: focusNode,
                    cursorHeight: 20,
                    decoration: InputDecoration(
                      filled: true,
                      //fillColor: Colors.white,
                     // hintText: 'Company Phone',
                      border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(15), ),
                      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                        width: 1,
                        color:  Color(0xff0F2C59),    ),
                        borderRadius: BorderRadius.circular(15), 
                        ),
                    ),
                    
                    languageCode: "en",
                    onChanged: (phone) {
                      setState(() {
                       phonec.text=phone.completeNumber;
                      print(phone.completeNumber);
                      });
                    },
                    onSaved: (newValue) {
                      phonec.text=newValue!.completeNumber;
                    },
                    
                  ))
              : Container(
                padding: EdgeInsets.all(10),
                width: 350,
                decoration: BoxDecoration(color: const Color.fromARGB(255, 202, 202, 202),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xff0F2C59))),
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.add_call,color:  Color(0xff0F2C59),),
                  Container(width: 10,),

                  Text(phonec.text, style: TextStyle(color: Color.fromARGB(255, 100, 100, 100),fontWeight: FontWeight.w500),)
                ],
              ),
              ), 
              Container(height: 10,),                                         
             edit 
             ?Container( 
              height: 45,
             child: TextFormField(
                      controller: pwd,
                      style: TextStyle(fontSize: 17),
                     // obscureText: true,
                      decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(15), ),                    
                     // fillColor: Color.fromARGB(255, 199, 31, 31),
                      //hintText:"Password" ,
                      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                        width :1,
                        color:  Color(0xff0F2C59),    ),
                        borderRadius: BorderRadius.circular(15), 
                        ),
                      ),
                       
                      onChanged: (value) {
                        setState(() {
                        pwd.text=value ;   
                        });
                       
                      },
                      onSaved: (newValue) {
                        setState(() {
                         pwd.text=newValue! ; 
                        });
                         
                      },
                      validator: (value) {
                      //if(value != Null){
                      if(value!.isEmpty){ return "Required Feild";}
                      // Check the length (at least 8 characters)
                      if (value.length < 8) {
                        return "Password must be at least 8 characters long";
                      }

                    // Check for lowercase, uppercase, digit, and special character
                    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])').hasMatch(value)) {
                      return "Password must contain at least one lowercase letter,\n one uppercase letter, one digit, and one special character";
                    }
                    
                    //if(value.length<8){return"";}
                  //}
                  },
                    ))
              :Container(
                padding: EdgeInsets.all(10),
                width: 350,
               // height: 80,
                decoration: BoxDecoration(color: const Color.fromARGB(255, 202, 202, 202),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xff0F2C59))),
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.lock_reset,color:  Color(0xff0F2C59),),
                  Container(width: 10,),
                  Text(pwd.text, style: TextStyle(color: Color.fromARGB(255, 100, 100, 100),fontWeight: FontWeight.w500),),
                ],
              ),
              ),
              edit 
              ?  Container(
                margin: EdgeInsets.fromLTRB(5, 20, 5, 0),
                    alignment: Alignment.bottomCenter,
                    child :ButtonTheme(                      
                    height: 45,
                    minWidth: 400,
                    shape: RoundedRectangleBorder(side: BorderSide(color: Color.fromARGB(255, 10, 1, 71)), borderRadius: BorderRadius.circular(20.0)),
                    child: MaterialButton(
                    onPressed: () => pickPDF(),
                    child: Text(
                      cv != null
                      ? "CV Uploaded"
                      :'Pick PDF',
                      style: TextStyle(fontSize: 18),),
                    //textColor: Colors.white,
                    textColor: Color.fromARGB(255, 10, 1, 71),
                    //color:Colors.white,
                   // color:Color.fromARGB(255, 10, 1, 71),
                   ),),)

              : Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    alignment: Alignment.bottomCenter,
                    child :ButtonTheme(                      
                    height: 40,
                    minWidth: 400,
                    shape: RoundedRectangleBorder(side: BorderSide(color: Color.fromARGB(255, 10, 1, 71)), borderRadius: BorderRadius.circular(20.0)),
                    child: MaterialButton(
                    onPressed: () {
                      networkHandler.downloadFile("http://localhost:5000/"+widget.stuinfo['cv'], '${widget.stuinfo['RegNum']}.pdf');
                    },
                    child: Text('Veiw PDF',style: TextStyle(fontSize: 18),),
                    //textColor: Colors.white,
                    textColor: Color.fromARGB(255, 10, 1, 71),
                   // color:Colors.white,
                   // color:Color.fromARGB(255, 10, 1, 71),
                   ),),),
               edit 
               ?  Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0,0),
                      alignment: Alignment.bottomCenter,
                      child :ButtonTheme(                      
                        height: 50,
                        minWidth: 200,
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
                          child :MaterialButton (
                           // highlightColor: Colors.amber,
                           // splashColor:  Colors.amber,
                            child: Text("Save",style: TextStyle(fontSize: 25,),),
                            textColor: Colors.white,
                            color:Color(0xff0F2C59),
                              onPressed:(){
                                setState(() {
                                  edit=false;
                                });

                            },
                            /*onPressed: () {
                              print("pressed");
                        },*/),
                  ),
                   )   
               :   Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0,0),
                      alignment: Alignment.bottomCenter,
                      child :ButtonTheme(                      
                        height: 50,
                        minWidth: 200,
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
                          child :MaterialButton (
                           // highlightColor: Colors.amber,
                           // splashColor:  Colors.amber,
                            child: Text("Edit",style: TextStyle(fontSize: 25,),),
                            textColor: Colors.white,
                            color:Color(0xff0F2C59),
                              onPressed:(){
                                  setState(() {
                                    edit=true;
                                  });
                            },
                            /*onPressed: () {
                              print("pressed");
                        },*/),
                  ),
                   ),                                   
             /* Container(
                padding: EdgeInsets.all(10),
                width: 350,
                decoration: BoxDecoration(color: const Color.fromARGB(255, 202, 202, 202),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xff0F2C59))),
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.percent_rounded,color:  Color(0xff0F2C59),),
                  Container(width: 10,),
                  Text(_controllerGPA.text, style: TextStyle(color: Color.fromARGB(255, 100, 100, 100),fontWeight: FontWeight.w500),)
                ],
              ),
              ),*/
            ]),
          )
          ),
        ),
          Positioned(
            top: 50,
            left: 50 ,
            right: 50,
            child: Column(children: [
              imageProfile(),
              Container(height: 8,),
              Text(widget.stuinfo['fname']+" "+widget.stuinfo['lname'],style: TextStyle(color: Color(0xff0F2C59),fontSize: 20,fontWeight: FontWeight.w700),)
            ],)
            
            ),
         /* Positioned(
            top: 120,
            left: 300 ,
            right: 50,           
            child: IconButton(icon: Icon(Icons.edit_sharp,color: Color(0xff0F2C59),) ,
            onPressed:() {
            setState(() {
              edit=true;
            });
          }, ))*/
      ]),
      )
      :Center(
            child: CircularProgressIndicator(), // Loading indicator
          ),
    );
  }
  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        Container(
          
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:Border.all(color:Color.fromARGB(97, 15, 45, 89) ,width: 5,style: BorderStyle.solid),
            color: Color.fromARGB(97, 15, 45, 89) ,
          ),
          height: 140,
          width: 150,
          child: CircleAvatar(
        radius: 80, // Customize the radius as needed
        foregroundColor: Color.fromARGB(253, 15, 45, 89),
        backgroundImage: _image != null 
        ? FileImage(_image!) 
        : NetworkImage("http://localhost:5000/" + widget.stuinfo['img']) as ImageProvider,
      
      ),
      ),


      ]),
    );
  }

}
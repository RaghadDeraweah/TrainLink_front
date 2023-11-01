import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:untitled4/login.dart';
import 'package:untitled4/BCompany.dart';



//import 'package:csc_picker/csc_picker.dart';

class signupCOM extends StatefulWidget {
   signupCOM({super.key});
  State<signupCOM> createState() => _signupStateCOM(); 
}

class _signupStateCOM extends State<signupCOM>{
  //Keys
    GlobalKey<FormState>  signupCform= GlobalKey();
    final networkHandler = NetworkHandlerC();
    final storage = new FlutterSecureStorage();
  // controllers 
   TextEditingController _CID = TextEditingController();
   TextEditingController _CName = TextEditingController();
   TextEditingController _CFeild = TextEditingController();
   TextEditingController _CBD = TextEditingController();
   TextEditingController _CCity = TextEditingController();
   TextEditingController _CEmail= TextEditingController();
   TextEditingController _CPhone = TextEditingController();
   TextEditingController _Cwebsite = TextEditingController();
   TextEditingController _Password = TextEditingController();
   TextEditingController _ConfirmPassword = TextEditingController();
   TextEditingController _Work = TextEditingController();
   PageController _pageController = PageController();

   //For Packeges
  FocusNode focusNode = FocusNode();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final _phoneFormatter = FilteringTextInputFormatter.digitsOnly;
  

  //Vars
  String? cityValue ;
  String? id;
  String email="";
  String? pwd;
  String? gender;
  RegExp gmail = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
  RegExp yahoo = RegExp(r'^[a-zA-Z0-9._%+-]+@yahoo\.com$');
  RegExp outlook = RegExp(r'^[a-zA-Z0-9._%+-]+@outlook\.com$');

  //lists
    //Cities
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
    //majors
    final List<String> Majors = [
    'Computer Engineering',
    'Computer science',
    'IT',
    'MIS',
    'CAP',
  ];

  

  //functions
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Return the AlertDialog widget
        return AlertDialog(
          icon: Icon(Icons.error,color: Colors.red,size: 30,),
          //title: Text('Dialog Title'),
          content: Text('You already have Accout , Go to Login '),
          actions: [
            TextButton(
              onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text('GO'),
            ),
          ],
        );
      },
    );
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
  void _navigateToPage(int pageIndex) {
  _pageController.animateToPage(
    pageIndex,
    duration: Duration(milliseconds: 500), // Animation duration
    curve: Curves.ease, // Animation curve
  );
  }
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
  bool containsNumbersOrSymbols(String value) {
    // Define a regular expression pattern to match any numbers or symbols.
    RegExp pattern = RegExp(r'[0-9!@#\$%^&*()]');

    // Use the `hasMatch` method to check if the pattern matches any part of the input string.
    return pattern.hasMatch(value);
  }
  //end functins
 
  @override
  void initState() {
    _CBD.text = ""; //set the initial value of text field
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:Stack(
        children: [ 
          Container( child:Image.asset("images/signuppic.png", fit: BoxFit.cover, width: 500, height: 1080,), ),        
          Positioned(
          bottom: 0, 
          child: Container( 
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color:Color.fromARGB(255, 223, 217, 217),
              borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
              ),
            padding: EdgeInsets.all(20),
            width: 412,
            height: 500,           
            child :Form(
              
              key:  signupCform,
              child: PageView(//Column(
                controller: _pageController,
                children: [
                
                Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Container(height: 40,),
                TextFormField( 
                        controller: _CName,
                    style: TextStyle(fontSize: 17),
                    decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15), ),                    
                    fillColor: Colors.white,
                    hintText:"Company Name" ,
                    focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 30, 51, 236),    ),
                      borderRadius: BorderRadius.circular(15), 
                      ),
                ),
                        onSaved: (val){
                        _CName.text =val!;
                      },
                      onChanged: (value) {
                        setState(() {
                           _CName.text =value;
                        });
                      },

                      validator: (value) {
                        //if(value != Null){
                        if(value!.isEmpty){ return "Required Feild";}
                        if (value != null && !containsNumbersOrSymbols(value!)) {
                        // Value does not contain numbers or symbols
                        print("Valid input: $value");
                      } else {
                        // Value contains numbers or symbols
                        return"Invalid Name";
                      }
                        //if(value.length<8){return"";}
                      //}
                      },
                    ),               
                Container(height: 10,),
                Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15)),),
                child :TextField(
                  controller: _CBD,
                  decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: "Date of establishment", 
                  border: OutlineInputBorder(
                    //borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15), 
                    ),    
                  /*focusedBorder:  OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 14, 31, 182),   
                       ),
                      borderRadius: BorderRadius.circular(15), 
                      ),*/
                  ),
                  readOnly: true,
                  onTap: () async {
                  DateTime? pickedDate = await showDatePicker(    
                    context: context,
                    
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1950),
                    //DateTime.now() - not to allow to choose before today.
                    lastDate: DateTime(2100));
 
                 if (pickedDate != null) {
                  //print( pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  //print( formattedDate); //formatted date output using intl package =>  2021-03-16
                  setState(() {
                    _CBD.text = formattedDate; //set output date to TextField value.
                  });
                } 
              },
            ),
            ),               
                Container(height: 10,),
                Container(
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
                    value: cityValue,
                    onChanged: (String? value) {
                      setState(() {
                        cityValue = value;
                        _CCity.text=cityValue!;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 57,
                      width: 160,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Color.fromARGB(255, 133, 133, 133),
                        ),
                        //fo
                        color: const Color.fromARGB(255, 255, 255, 255),
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
                ), 
                Container(height: 10,),
                TextFormField( 
                    controller: _CFeild,
                    style: TextStyle(fontSize: 17),
                    decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15), ),                    
                    fillColor: Colors.white,
                    hintText:"Work" ,
                    focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 30, 51, 236),    ),
                      borderRadius: BorderRadius.circular(15), 
                      ),
                ),
                        onSaved: (val){
                        _CFeild.text =val!;
                      },
                      onChanged: (value) {
                        setState(() {
                           _CFeild.text =value;
                        });
                      },

                      validator: (value) {
                        //if(value != Null){
                        if(value!.isEmpty){ return "Required Feild";}
                       
                        //if(value.length<8){return"";}
                      //}
                      },
                    ),                               
                Container(height: 10,),
                Container(
                alignment: Alignment.bottomCenter,
                child :ButtonTheme(                  
                  height: 50,
                  minWidth: 200,
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
                    child :MaterialButton (
                       highlightColor: Colors.amber,
                       splashColor:  Colors.amber,
                      child: Text("Save",style: TextStyle(fontSize: 25,),),
                      textColor: Colors.white,
                      color: Color.fromARGB(255, 14, 31, 182),
                      onPressed:(){
                          
                       if( signupCform.currentState!.validate()){
                           signupCform.currentState!.save();
                          print("************valid**************");
                          print(_CName.text);
                          print(_CBD.text);
                          print(_CCity.text);
                          print(_CFeild.text);
                        }else{
                          print("***************************invalid*******************************");
                        }
                      },
                      /*onPressed: () {
                        print("pressed");
                  },*/),
                  ),
                   ), 
                ],
                ),
                SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child :Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 40,), 
                    TextFormField( 
                    controller: _CEmail,
                    style: TextStyle(fontSize: 17),
                    decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15), ),                    
                    fillColor: Colors.white,
                    hintText:"Company Email" ,
                    focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 30, 51, 236),    ),
                      borderRadius: BorderRadius.circular(15), 
                      ),
                ),
                  onSaved: (val){
                    _CEmail.text =val!;
                  },

                  validator: (value) {
                    //if(value != Null){
                    if(value!.isEmpty){ return "Required Feild";}
                    if(!gmail.hasMatch(value) && !yahoo.hasMatch(value) && !outlook.hasMatch(value)){
                        return "Sign Up with valid email";                      
                      }
                    
                   
                    //if(value.length<8){return"";}
                  //}
                  },
                ),
                    Container(height: 10,),
                    TextFormField( 
                      controller: _CID,
                    style: TextStyle(fontSize: 17),
                    decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15), ),                    
                    fillColor: Colors.white,
                    hintText:"Registrion ID" ,
                    focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 30, 51, 236),    ),
                      borderRadius: BorderRadius.circular(15), 
                      ),
                ),
                  onSaved: (val){
                    _CID.text =val!;
                  },

                  validator: (value) {
                    //if(value != Null){
                    if(value!.isEmpty){ return "Required Feild";}
                    if(value.length!=5){
                      return"Id must be 5 numbers";
                    }
                    else if( !isNumeric(value)){
                        return "ID its just numbers";                      
                    }
  
                    },

                ), 
                    Container(height: 10,),
                    IntlPhoneField(
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Company Phone',
                      border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(15), ),
                      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                        width: 1,
                        color:  Color.fromARGB(255, 30, 51, 236),    ),
                        borderRadius: BorderRadius.circular(15), 
                        ),
                    ),
                    
                    languageCode: "en",
                    onChanged: (phone) {
                      setState(() {
                       _CPhone.text=phone.completeNumber;
                      print(phone.completeNumber);
                      });
                    },
                    onSaved: (newValue) {
                      _CPhone.text=newValue!.completeNumber;
                    },
                    
                  ),
                    Container(height: 10,),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0,20),
                      alignment: Alignment.bottomCenter,
                      child :ButtonTheme(                      
                        height: 50,
                        minWidth: 200,
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
                          child :MaterialButton (
                            highlightColor: Colors.amber,
                            splashColor:  Colors.amber,
                            child: Text("Save",style: TextStyle(fontSize: 25,),),
                            textColor: Colors.white,
                            color: Color.fromARGB(255, 14, 31, 182),
                              onPressed:(){
                                
                              if( signupCform.currentState!.validate()){
                                 signupCform.currentState!.save();
                                print("*******valid***********");
                                print(_CID.text);
                                print(_CPhone.text);
                                print(_CEmail.text);
                                
                              }else{
                                print("***********invalid**********");
                              }
                            },
                            /*onPressed: () {
                              print("pressed");
                        },*/),
                  ),
                   ), 
               ],
                ),
                ),
                SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child :Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 40,),  
                    TextFormField( 
                    controller: _Cwebsite,
                    style: TextStyle(fontSize: 17),
                    decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15), ),                    
                    fillColor: Colors.white,
                    hintText:"Company Website" ,
                    focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 30, 51, 236),    ),
                      borderRadius: BorderRadius.circular(15), 
                      ),
                ),
                  onSaved: (val){
                    _Cwebsite.text =val!;
                  },

                  validator: (value) {
                    //if(value != Null){
                    if(value!.isEmpty){ return "Required Feild";}

                   
                    //if(value.length<8){return"";}
                  //}
                  },
                ),
                    Container(height: 10,),
                    TextFormField(
                      controller: _Password,
                      style: TextStyle(fontSize: 17),
                      obscureText: true,
                      decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(15), ),                    
                      fillColor: Colors.white,
                      hintText:"Password" ,
                      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                        width :1,
                        color:  Color.fromARGB(255, 30, 51, 236),    ),
                        borderRadius: BorderRadius.circular(15), 
                        ),
                      ), 
                      onChanged: (value) {
                        _Password.text=value ;
                      },
                      onSaved: (newValue) {
                         _Password.text=newValue! ;
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
                    ), 
                    Container(height: 10,),
                    TextFormField(
                      controller: _ConfirmPassword,
                      style: TextStyle(fontSize: 17),
                      obscureText: true,
                      decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.circular(15), ),                    
                      fillColor: Colors.white,
                      hintText:"Confirm Password" ,
                      focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                        width: 1,
                        color:  Color.fromARGB(255, 30, 51, 236),    ),
                        borderRadius: BorderRadius.circular(15), 
                        ),
                  ), 
                  validator: (value) {
                    if(!(_Password.text==_ConfirmPassword.text)){
                    return"not match with password";
                    }
                  },                     
                    ) ,
                    Container(height: 10,),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0,20),
                      alignment: Alignment.bottomCenter,
                      child :ButtonTheme(                      
                        height: 50,
                        minWidth: 200,
                          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
                          child :MaterialButton (
                            highlightColor: Colors.amber,
                            splashColor:  Colors.amber,
                            child: Text("Sign Up",style: TextStyle(fontSize: 25,),),
                            textColor: Colors.white,
                            color: Color.fromARGB(255, 14, 31, 182),
                              onPressed:() async {
                                
                              if( signupCform.currentState!.validate()){
                                 signupCform.currentState!.save();
                                print("*******valid***********");
                                print(_CName.text);
                                print(_CID.text);
                                print(_CCity.text);
                                print(_CPhone.text);
                                print(_CFeild.text);
                                print(_CBD.text);
                                print(_CEmail.text);
                                print(_Cwebsite.text);
                                print(_Password.text);
                                print(_ConfirmPassword.text);

                                bool result = await networkHandler.registerUser(_CID.text,_CName.text,_CEmail.text,_CFeild.text,_CBD.text ,_CCity.text, _CPhone.text,_Password.text,_Cwebsite.text);
                                print(result);
                                if(result == true){
                                  print("Inside True");
                                    _showDialog(context);                                
                                }else{
                                networkHandler.patchImage(_image!.path,_CID.text);
                                print("Inside False");
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));}
                                //networkHandler.patchImage(_image!.path,_CID.text);
                              }else{
                                print("***********invalid**********");
                              }
                            },
                            /*onPressed: () {
                              print("pressed");
                        },*/),
                  ),
                   ), 
               ],
                ),
                ),
   
                ],
                ),
              ),
           ),
          ),
          Positioned(bottom: 450, left: 125, child: imageProfile(),),
        ],
      )
           
     
    );
  }
  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        Container(
          height: 140,
          width: 150,
          child: CircleAvatar(
        radius: 80, // Customize the radius as needed
        backgroundColor: Colors.transparent,
        backgroundImage: _image != null 
        ? FileImage(_image!) 
        : AssetImage("images/blankimg.PNG") as ImageProvider,
      
      ),
      ),

       Positioned(
          bottom: 0.0,
          right: 0.0,
          child: IconButton(
            icon: Icon(
              Icons.camera_alt,
              color: Color.fromARGB(255, 14, 31, 182),
              size: 28.0,
            ),
            onPressed:  _getImage,

            /*onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },*/
           
          ),
        ),
      ]),
    );
  }

}
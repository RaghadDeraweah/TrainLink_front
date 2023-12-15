import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:untitled4/login.dart';
import 'package:untitled4/BStudent.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

Future<void> uploadFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    print(file.path);

  }else{
    print("failddddddddddddd");
  }
}
class FileUploadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Text('UPLOAD FILE'),
      onPressed: () async {
        var picked = await FilePicker.platform.pickFiles();

        if (picked != null) {
          print(picked.files.first.name);
        }
      },
    );
  }
}

class signupSTU extends StatefulWidget {
   signupSTU({super.key});
  State<signupSTU> createState() => _signupStateSTU(); 
}
class Interests {
   int Iid;
   String Iname;

  Interests({ required this.Iid, required this.Iname,});
}
class _signupStateSTU extends State<signupSTU>{
  //Keys
    GlobalKey<FormState>  signupSform= GlobalKey();
    final networkHandler = NetworkHandlerS();

  // controllers 
   TextEditingController _FName = TextEditingController();
   TextEditingController _LName = TextEditingController();
   TextEditingController _SBD = TextEditingController();
   TextEditingController _SCity = TextEditingController();
   TextEditingController _gender = TextEditingController();
   TextEditingController _SEmail= TextEditingController();
   TextEditingController _SID = TextEditingController();
   TextEditingController _SPhone = TextEditingController();
   TextEditingController _Password = TextEditingController();
   TextEditingController _ConfirmPassword = TextEditingController();
   TextEditingController _Major = TextEditingController();
   TextEditingController _GPA = TextEditingController();
  //TextEditingController _G = TextEditingController();
   TextEditingController _gpaController = TextEditingController();
   PageController _pageController = PageController();
   List<String> ss=[];
   //For Packeges
  FocusNode focusNode = FocusNode();
  File? _image;
    File? cv;
  final ImagePicker _picker = ImagePicker();
  final _phoneFormatter = FilteringTextInputFormatter.digitsOnly;
  

  //Vars
  String? fn;
  String? ln;
  String? cityValue ;
  String? id;
  String email="";
  String? pwd;
  String? gender;
  RegExp regex = RegExp(r'^s\d{8}@stu\.najah\.edu$');
  String? Major;
  


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
    //Interests
   static List<Interests> interests = [
   Interests(Iid:1,Iname:'Flutter'),
    Interests(Iid:2,Iname:'React'),
    Interests(Iid:3,Iname:'Angular'),
    Interests(Iid:4,Iname:'Vue.js'),
    Interests(Iid:5,Iname:'Svelte'),
    Interests(Iid:6,Iname:'jQuery'),
    Interests(Iid:7,Iname:'Backbone.js'),
    Interests(Iid:8,Iname:'JavaScript'),
    Interests(Iid:9,Iname:' Django'),
    Interests(Iid:10,Iname:'ExpressJS '),
    Interests(Iid:11,Iname:'Laravel'),
    Interests(Iid:12,Iname:'ASP .NET Core'),
    Interests(Iid:13,Iname:'Spring Boot'),
    //Interests(Iid:1,Iname:' '),
];
  final _feilds = interests.map((interest) => MultiSelectItem<Interests>(interest, interest.Iname)).toList();
  List<Interests> _selectedInterests = [];

  

  //functions

  void _showDialog(BuildContext context , String msg , bool go) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Return the AlertDialog widget
        return AlertDialog(
          icon: Icon(Icons.error,color: Colors.red,size: 40,),
          //title: Text('Dialog Title'),
          content: Text(msg,style: TextStyle(fontSize: 25),),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog
                //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
               if(go){
               Navigator.of(context).popUntil((route) => route.isFirst);
               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
               }
               else{
                Navigator.of(context).pop();
               }
              },
              child: go 
              ?Text('GO')
              :Text('OK')
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
  String? filePath;
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
 
  @override
  void initState() {
     // networkHandler.isExist=false;
    _SBD.text = ""; //set the initial value of text field
    super.initState();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:Stack(
        children: [ Container( child:Image.asset("images/signimg.png", fit: BoxFit.cover, width: 500, height: 1080,), ),        
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
              
              key:  signupSform,
              child: PageView(//Column(
                controller: _pageController,
                children: [
                SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child :Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Container(height: 40,), 
                Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 4,
                        child: TextFormField( 
                        controller: _FName,
                        style: TextStyle(fontSize: 17, ),
                        decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                        //borderSide: BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.circular(15), 
                        ),                    
                        fillColor: Colors.white,
                        hintText:"First Name" ,
                        /*focusedBorder:  OutlineInputBorder(
                        borderSide: BorderSide(
                        color:Color.fromARGB(255, 10, 1, 71),    ),
                        borderRadius: BorderRadius.circular(15), 
                          ),*/
                    ),
                        onSaved: (val){
                        fn =val;
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
                  ),
                    Expanded(flex :1,child: Container()),
                    Expanded(
                      flex: 4,
                      child:TextFormField( 
                        controller: _LName,
                        style: TextStyle(fontSize: 17, ),
                        decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.circular(15), ),                    
                        fillColor: Colors.white,
                        hintText:"Last Name" ,
                        focusedBorder:  OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 4, 6, 129),),borderRadius: BorderRadius.circular(15),),
                        ),
                        onSaved: (val){
                          ln =val;
                        },
                        validator: (value) {  
                          if(value!.isEmpty){ return "Required Feild";}
                          if (value != null && !containsNumbersOrSymbols(value!)) {
                          // Value does not contain numbers or symbols
                          print("Valid LName: $value");
                        } else {
                          return "Invalid Name ";
                        }
                          //if(value.length<8){return"";}
                        //}
                        },
                  ),                  
                    ),
                  ],
                ),
                Container(height: 10,),
                //datofbirth
                Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15)),),
                child :TextField(
                  controller: _SBD,
                  decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: "Date of Birth", 
                  border: OutlineInputBorder(
                    //borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15), 
                    ),    
                  /*focusedBorder:  OutlineInputBorder(
                    borderSide: BorderSide(
                      color:Color.fromARGB(255, 10, 1, 71),   
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
                    _SBD.text = formattedDate; //set output date to TextField value.
                  });
                } 
              },
            ),
            ),
               //city
               /* Container(height: 20,),
                //MyDropdown(),
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
                     
                    onChanged: ( value) {
                      setState(() {
                        cityValue =  value;
                        _SCity.text =cityValue!;
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
                ),*/ 
                Container(height: 10,),
                Text("Your Gender ",style :TextStyle(fontSize: 16),textAlign: TextAlign.start,),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child:RadioListTile(
  
                        title:Text("Male",style: TextStyle(fontSize: 18),),
                        value: "Male", 
                        groupValue:gender,
                        activeColor:Color.fromARGB(255, 10, 1, 71),
                        onChanged:(val){setState(() {
                         gender=val;
                        _gender.text=val!;
                    });},
                     ),
                    ),
                    Expanded(
                      flex: 1,
                      child:RadioListTile(title:Text("Female",style: TextStyle(fontSize: 18),),
                      value: "Female",
                      activeColor:Color.fromARGB(255, 10, 1, 71),
                      groupValue: gender, 
                       onChanged:(val){setState(() {
                        gender=val;
                       _gender.text=val!;
                    });} ),
                    ),
                  ],
                ),
                Container(height: 10,),
                Container(height: 10,),
                    MultiSelectDialogField(
                      dialogHeight: 160,
                      items: _feilds,
                      
                      title: Text("Interests",style: TextStyle(color:Color.fromARGB(255, 10, 1, 71)),),
                      selectedColor:Color.fromARGB(255, 10, 1, 71),
                      decoration: BoxDecoration(                       
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                          color:  Color.fromARGB(255, 133, 133, 133),
                          //width: ,
                        ),
                      ),
                      buttonIcon: Icon(
                        
                        Icons.keyboard_double_arrow_down_outlined,
                        color: Color.fromARGB(255, 95, 95, 95),
                      ),
                      
                      buttonText: Text(
                        "Interests",
                        style: TextStyle(
                          color: Color.fromARGB(255, 107, 106, 106),
                          fontSize: 17,
                        ),
                      ),
                      onConfirm: (results) {
                        _selectedInterests = results;
                      },
                      onSelectionChanged: (p0) {
                        setState(() {
                         _selectedInterests = p0;
                      });
                       
                      },
                      onSaved: (newValue) {
                        _selectedInterests = newValue!;
                      },
              ),
                Container(height: 30,),                
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
                      color:Color.fromARGB(255, 10, 1, 71),
                      onPressed:(){
                          
                       if( signupSform.currentState!.validate()){
                           signupSform.currentState!.save();
                          print("************valid**************");
                          print(_FName.text);
                          print("\n");
                          print(_LName.text);
                          print("\n");
                          print(_SBD.text);
                          //print("\n");
                         // print(cityValue);
                          //print("\n");
                          print(_gender.text);

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
              ),
                SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child :Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 40,), 
                    //Email
                    /*TextFormField( 
                    controller: _SEmail,
                    style: TextStyle(fontSize: 17),
                    decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15), ),                    
                    fillColor: Colors.white,
                    hintText:"Univerity Email" ,
                    focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 30, 51, 236),    ),
                      borderRadius: BorderRadius.circular(15), 
                      ),
                ),
                  onSaved: (val){
                    _SEmail.text =val!;
                  },

                  validator: (value) {
                    //if(value != Null){
                    if(value!.isEmpty){ return "Required Feild";}
                    if(value.contains('@')){
                      if(!regex.hasMatch(value)){
                        //print("not match");
                        return "Sign Up with university email";                      
                      }
                    }
                   
                    //if(value.length<8){return"";}
                  //}
                  },
                ),
                    Container(height: 10,),*/
                    TextFormField( 
                    controller: _SID,
                    style: TextStyle(fontSize: 17),
                    decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15), ),                    
                    fillColor: Colors.white,
                    hintText:"Registrion ID" ,
                    //icon: Icon(Icons.email,color: Color.fromARGB(255, 23, 34, 189),),
                    //hintStyle: TextStyle(color: Colors.blueAccent,fontSize: 70),
                    focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 30, 51, 236),    ),
                      borderRadius: BorderRadius.circular(15), 
                      ),
                ),
                  onSaved: (val){
                    _SID.text =val!;
                  },

                  validator: (value) {
                    //if(value != Null){
                    if(value!.isEmpty){ return "Required Feild";}
                    if(value.length!=8){
                      return"Id must be 8 numbers";
                    }
                    else if( !isNumeric(value)){
                        return "ID its just numbers";                      
                    }
  
                    },
                   
                    //if(value.length<8){return"";}
                  //}
                
                ), 
                    Container(height: 10,), 
                    IntlPhoneField(
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Phone Number',
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
                      _SPhone.text=phone.completeNumber;
                      print(phone.completeNumber);
                    },
                    onSaved: (newValue) {
                      _SPhone.text=newValue!.completeNumber;
                    },
                    
                  ),
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
                    /*TextFormField(
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
                    ) ,*/
                    Container(
                    alignment: Alignment.bottomCenter,
                    child :ButtonTheme(                      
                    height: 60,
                    minWidth: 400,
                    shape: RoundedRectangleBorder(side: BorderSide(color: Color.fromARGB(255, 10, 1, 71)), borderRadius: BorderRadius.circular(20.0)),
                    child: MaterialButton(
                    onPressed: () => pickPDF(),
                    child: Text('Pick PDF',style: TextStyle(fontSize: 18),),
                    //textColor: Colors.white,
                    textColor: Color.fromARGB(255, 10, 1, 71),
                    color:Colors.white,
                   // color:Color.fromARGB(255, 10, 1, 71),
                   ),),),
                   cv != null
                   ? Container(margin: EdgeInsets.only(bottom: 10),width: 400, height: 20,alignment: Alignment.center,child: Text("CV Uploaded",style: TextStyle(color:Color.fromARGB(255, 10, 1, 71) ),),) 
                   : Container(height: 10,)    ,
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
                            color:Color.fromARGB(255, 10, 1, 71),
                              onPressed:() async {
                               // _SCity.text =cityValue!;
                              if( signupSform.currentState!.validate()){
                                 signupSform.currentState!.save();
                                print("*******valid***********");
                                print(_FName.text);
                                print(_LName.text);
                                print(_SBD.text);
                                //print(_SCity.text);
                                print(_gender.text);
                                //(_SEmail.text);
                                print(_SID.text);
                                print(_SPhone.text);
                                print(_Password.text);
                                //print(_ConfirmPassword.text);
                                //print(_GPA.text);
                                //print(_Major.text);
                                for(int i=0;i<_selectedInterests.length;i++)
                                ss.add(_selectedInterests[i].Iname);
                               // print(_image!.path);
                                //print( );
                                bool found= await networkHandler.checkinunistudents(_SID.text);
                                if(found){
                                  Map<String,dynamic> temp= await networkHandler.fetchUniStudentData(_SID.text);
                                  bool result=await networkHandler.registerUser(_SID.text,_FName.text,_LName.text,_SBD.text,temp['city'],_gender.text,
                                  temp['SEmail'],_SPhone.text,_Password.text,temp['Major'],temp['GPa'],ss,temp['stustatus'],temp['startyear'],temp['graduationyear'],temp['universityTraining']);
                                  if(result == true){
                                  _showDialog(context,'You already have Accout , Go to Login ',true);                                
                                  }else{
                                    networkHandler.patchImage(_image!.path,_SID.text);
                                    networkHandler.uploadFile(cv!.path,_SID.text);
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
                                  }
                                  }else{
                                    _showDialog(context,"Your ID incorrect",false);
                                  }

                                }else{
                                  _showDialog(context,"Failed Registeration",false);
                                }


                             /* bool result=await networkHandler.registerUser(_SID.text,_FName.text,_LName.text,_SBD.text,_SCity.text,_gender.text,
                              _SEmail.text,_SPhone.text,_Password.text,_Major.text,_GPA.text,ss);
                               if(result == true){
                               _showDialog(context);                                
                               }else{
                                networkHandler.patchImage(_image!.path,_SID.text);
                                networkHandler.uploadFile(cv!.path,_SID.text);
                               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
                               }
                              }else{
                                print("***********invalid**********");
                              }*/
                            },
                            /*onPressed: () {
                              print("pressed");
                        },*/),
                  ),
                   ),                      
                  ],
                ),
                ),
                /*SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child :Column(
                  children: [
                    Container(height: 40,),
                    Container(
                    width: 413,
                    child : DropdownButtonHideUnderline(                      
                    child: DropdownButton2<String>(                                            
                    isExpanded: true,
                    hint: const Row(
                      children: [                        
                        Expanded(
                          child: Text(
                            'Select Major',
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
                    items: Majors.map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 17,
                                  //fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 80, 80, 80),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: Major,
                    onChanged: (String? value) {
                      setState(() {
                        Major =value;
                        _Major.text = Major!;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 47,
                      width: 160,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Color.fromARGB(255, 133, 133, 133),
                        ),
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
                      maxHeight: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                      offset: const Offset(120, 0),
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
                    Container(
                     height: 44,
                    child :TextFormField(
                    
                    controller: _GPA,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(14, 0, 70, 0),
                    filled: true,
                    border: OutlineInputBorder(
                   // borderSide: BorderSide(color: Color.fromARGB(195, 184, 183, 183)),
                    borderRadius: BorderRadius.circular(15), 
                    borderSide: BorderSide(color: Color.fromARGB(255, 133, 133, 133),)),                    
                    fillColor: Colors.white,
                    hintText:"Enter GPA" ,
                    focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                      color:Color.fromARGB(255, 10, 1, 71),    ),
                      borderRadius: BorderRadius.circular(15), 
                      ),
                ),
                  onSaved: (val){
                    _GPA.text =val!;
                  },
                  onChanged: (val){
                     setState(() {
                        _GPA.text = val;
                      });
                  },
                  validator: (value) {
                    //if(value != Null){
                    //if(value!.isEmpty){ return "Required Feild";}
                    if(!(isNumeric(value!))){
                     return "e.g., 3.5";
                    }
                   
                    //if(value.length<8){return"";}
                  //}
                  },
                        ),
                    ),
                    Container(height: 10,),
                    MultiSelectDialogField(
                      dialogHeight: 160,
                      items: _feilds,
                      
                      title: Text("Interests",style: TextStyle(color:Color.fromARGB(255, 10, 1, 71)),),
                      selectedColor:Color.fromARGB(255, 10, 1, 71),
                      decoration: BoxDecoration(                       
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                          color:  Color.fromARGB(255, 133, 133, 133),
                          //width: ,
                        ),
                      ),
                      buttonIcon: Icon(
                        
                        Icons.keyboard_double_arrow_down_outlined,
                        color: Color.fromARGB(255, 95, 95, 95),
                      ),
                      
                      buttonText: Text(
                        "Interests",
                        style: TextStyle(
                          color: Color.fromARGB(255, 107, 106, 106),
                          fontSize: 17,
                        ),
                      ),
                      onConfirm: (results) {
                        _selectedInterests = results;
                      },
                      onSelectionChanged: (p0) {
                        setState(() {
                         _selectedInterests = p0;
                      });
                       
                      },
                      onSaved: (newValue) {
                        _selectedInterests = newValue!;
                      },
              ),
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
                            color:Color.fromARGB(255, 10, 1, 71),
                              onPressed:() async {
                                _SCity.text =cityValue!;
                              if( signupSform.currentState!.validate()){
                                 signupSform.currentState!.save();
                                print("*******valid***********");
                                print(_FName.text);
                                print(_LName.text);
                                print(_SBD.text);
                                print(_SCity.text);
                                print(_gender.text);
                                print(_SEmail.text);
                                print(_SID.text);
                                print(_SPhone.text);
                                print(_Password.text);
                                print(_ConfirmPassword.text);
                                print(_GPA.text);
                                print(_Major.text);
                                for(int i=0;i<_selectedInterests.length;i++)
                                ss.add(_selectedInterests[i].Iname);
                               // print(_image!.path);
                                //print( );

                              bool result=await networkHandler.registerUser(_SID.text,_FName.text,_LName.text,_SBD.text,_SCity.text,_gender.text,
                              _SEmail.text,_SPhone.text,_Password.text,_Major.text,_GPA.text,ss);
                               if(result == true){
                               _showDialog(context);                                
                               }else{
                                networkHandler.patchImage(_image!.path,_SID.text);
                                networkHandler.uploadFile(cv!.path,_SID.text);
                               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
                               }
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
                ),*/
               /* SingleChildScrollView(
                child: ElevatedButton(
                 // style: ButtonStyle(),
              onPressed: () => pickPDF(),
              child: Text('Pick PDF'),
            ),
                ),*/
                ],
                ),
              ),
           ),
          ),
           Positioned(
            
            bottom: 450,
            left: 125,
            child: imageProfile(),
            ),
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
              color:Color.fromARGB(255, 10, 1, 71),
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
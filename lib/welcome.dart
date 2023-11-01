//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:untitled4/login.dart';
import 'package:untitled4/signup.dart';
import 'package:untitled4/NNavigator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
//import 'package:untitled4/signup1.dart';
//String RegNum, String fname, String lname, String BD , String city, String gender, String SEmail,String SPhone, String Password,String Major,String GPa,List Interestss 

class welcome extends StatefulWidget{
  welcome({super.key});
  State<welcome> createState() => _MyAppState(); 
}
 class _MyAppState extends State<welcome>  {
 /* int i=0;
  bool status=true;
  String? groupValue;
  int? groupValue1;
  String hobby="";
  bool? basketball=false;
   bool? fotball=false;
   GlobalKey<FormState> formState= GlobalKey();
   String? emadd;*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Container( 
          height:MediaQuery.of(context).size.height,
          width:MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                child:Image.asset("images/WelcomeP.png",
                fit: BoxFit.cover,
                width: 500,
                ), 
              ),
              
              Positioned( 
                bottom: 100,
                left: 35,
                width: 340,
                height: 50,             
                child: ButtonTheme(
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),),
                  child :MaterialButton (
                    child: Text("Login",style: TextStyle(fontSize: 22,),),
                      textColor: Colors.white,
                      color: Color.fromARGB(255 ,248, 154, 0),
                      onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
                      print("pressed");
                      },), 
                  ),
                ),


                Positioned(
                bottom: 40,
                left: 35,
                width: 340,
                height: 50,  
                child: ButtonTheme(
                  shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
                  child :MaterialButton (
                    child: Text("Sign Up",style: TextStyle(fontSize: 22,),),
                    textColor: Colors.white,
                    color: Color.fromARGB(255 ,248, 154, 0),
                    onPressed: () {
                      //registerUser();
                     
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => signup() ));
                      print("pressed");
                },),
                ),
                ),
              
            ],
          ),
                  ),
      );

  }

}
         
/*child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
          child: Column(
           
            children: [
              IconButton(icon: Icon(Icons.add),
               onPressed: (){
                setState(() {
                  i++;
                });
               },),
              Text("Counter  $i"),
              IconButton(icon: Icon(Icons.remove),
               onPressed: (){
                setState(() {
                  i--;
                });
               },),
            SwitchListTile(
              title: Text("low battery mode"),
              activeTrackColor: const Color.fromARGB(255, 107, 180, 110),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color.fromARGB(255, 206, 206, 206),
              activeColor: const Color.fromARGB(255, 38, 156, 42),
              value: status,
              onChanged:(val){
                setState(() {
                  status =val;
                });
                
              } ,),
              Text("Select your country"),
            RadioListTile(title:Text("Egypt"),value: "Egypt", groupValue: groupValue, onChanged:(val){setState(() {
              groupValue=val;
            });} ),
            RadioListTile(title:Text("Palsetine"),value: "Palsetine", groupValue: groupValue, onChanged:(val){setState(() {
              groupValue=val;
            });} ),
            RadioListTile(title:Text("Lebanon"),value: "Lebanon", groupValue: groupValue, onChanged:(val){setState(() {
              groupValue=val;
            });} ),
              Text("Select your age"),
            RadioListTile(title: Text("18"),value:18, groupValue: groupValue1, onChanged:(val){setState(() {
              groupValue1=val;
            });} ),
            RadioListTile(title: Text("20"),value:20, groupValue: groupValue1, onChanged:(val){setState(() {
              groupValue1=val;
            });} ),
            RadioListTile(title: Text("22"),value:22, groupValue: groupValue1, onChanged:(val){setState(() {
              groupValue1=val;
            });} ),
           Text("Select your hobby"),
            CheckboxListTile(title:Text("basketball"),value:basketball, onChanged:(val){
              setState(() {
                if(val == true) hobby="basketball";
                basketball=val;
              });
            }),
            CheckboxListTile(title:Text("fotball"),value:fotball, onChanged:(val){
              setState(() {
                if(val == true) hobby="fotball";
                fotball=val;
              });
            }),
            Text("your Country : $groupValue"),
            Text("your age : $groupValue1"),
            Text("your hoopy : $hobby"),
            TextField( 
              maxLength: 10,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "email",
                icon: Icon(Icons.email),
                hintStyle: TextStyle(color: Colors.blueAccent,fontSize: 40),
                focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                  color: Colors.green,
                  
                ),),
              ),
            ),
            Form(key: formState,
            child: Column(children: [
               TextFormField(
                autovalidateMode: AutovalidateMode.always,//يتم الفحص من بداية ظهور الصفحة وليس عند الضغط على البوتون
                obscureText: true,//تستخدم مع كلمات السر لاظهار النص كنجوم 
                readOnly: true,//لا يمكن التعديل عليه
                onSaved: (val){
                  emadd=val;
                },
                validator: (value) {
                  //if(value != Null){
                  if(value!.isEmpty){ return "الحقل فارغ";}
                  if(value.length<10){return"لا يمكن ان يكون الايميل اقل من 10";}
                //}
                }
              ),
              MaterialButton(
                color: Color.fromARGB(255, 0, 41, 110),
                textColor: Colors.white,
                
                onPressed:(){
                  if(formState.currentState!.validate()){
                    formState.currentState!.save();
                    print("valid");
                    print("$emadd");

                  }else{
                    print("invalid");
                  }
                },
                child:  Text("valid"),
                ),
               
            ],)
              )
            ],),
           )
*/














/*class MyApp extends StatelessWidget{
  MyApp ({super.key}) ;
  final List info =[
    { "name" : "Asmaa" , "age" : "19"},
    { "name" : "Hiba" , "age" : "18"},
    { "name" : "Ghada" , "age" : "17"}
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("title" )),
        body: Container( child: IconButton(iconSize:100 ,icon: Icon(Icons.person),
        onPressed: (){
          print("pressed");
        },)
        /* child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0.0,           
              child: ListTile(
              onTap: (){
                print("on tap");
              },
              title: Text("subjects"),
              subtitle: Text("sub"),
              trailing: Text("2023"),
              leading: Text("1"),
            ),
            ),
              Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0.0,           
              child: ListTile(
              onTap: (){
                print("on tap");
              },
              title: Text("subjects"),
              subtitle: Text("sub"),
              trailing: Text("2022"),
              leading: Text("2"),
            ),

            ),
              Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              //elevation: 0.0,           
              child: ListTile(
              onTap: (){
                print("on tap");
              },
              title: Text("subjects"),
              subtitle: Text("sub"),
              trailing: Text("2021"),
              leading: Text("3"),
            ),

            )
            ],
         ),*/
          )
          ),
        ) 
        
    ;
  }

}*/


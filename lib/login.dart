import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/HomePage.dart';
import 'package:untitled4/changePWD/ForgotPassworD.dart';
import 'package:untitled4/newSignUp.dart';
import 'package:untitled4/student/HomeStu.dart';

class Login extends StatefulWidget{
  Login({super.key});
  State<Login> createState() => _MyAppState(); 
}
 class _MyAppState extends State<Login>  {
  String? id;
  String email="";
  String? pwd;
  bool offsecure=true;
  RegExp regex = RegExp(r'^s\d{8}@stu\.najah\.edu$');
  RegExp gmail = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
  RegExp yahoo = RegExp(r'^[a-zA-Z0-9._%+-]+@yahoo\.com$');
  RegExp outlook = RegExp(r'^[a-zA-Z0-9._%+-]+@outlook\.com$');


  TextEditingController _Email = TextEditingController();
  TextEditingController _Password = TextEditingController();
  GlobalKey<FormState> loginform= GlobalKey();
  final networkHandler = NetworkHandlerS();
  final networkHandlerC = NetworkHandlerC();
  void _togglePasswordVisibility() {
    setState(() {
      offsecure = !offsecure;
    });
  }

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:Stack(
        children: [
          Container(
              child:Image.asset("images/newlog.jpg",
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
             ), 
             //child: Text("login"),
              ),
          Positioned(
          bottom: 70, 
          child: Container( 
            margin :EdgeInsets.fromLTRB(5, 0, 5, 5),
            //margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color:Color.fromARGB(255, 253, 243, 243),
              borderRadius: BorderRadius.only(topRight: Radius.circular(40),topLeft: Radius.circular(40),bottomLeft: Radius.circular(40),bottomRight:Radius.circular(40)),
              ),
            padding: EdgeInsets.fromLTRB(20,40,20,20),
            width:402,
            height: 500,           
            child :Form(
              
              key: loginform,
              child:// PageView(//Column(
               // children: [
                Column(children: [
                
                Container(
                  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                    "Let's sign you in ",
                  style:TextStyle(
                    color: const Color.fromARGB(193, 0, 0, 0),
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                    

                  ),),
                    Container(height: 10,),
                  Text(
                    "Welcome back , you've been missed",
                  style:TextStyle(
                    color: Color.fromARGB(141, 77, 76, 76),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,

                  ),
                  ),
                  ],)

                ),
                Container(height: 40,), 
                TextFormField( 
                  controller: _Email,
                    enableSuggestions: true,
                    onFieldSubmitted: (value) {
                      print("sumbited");
                    },
                  // padding: EdgeInsets.all(20),                 
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15), ),                    
                    fillColor: Colors.white,
                    hintText:"Email or ID" ,
                    icon: Icon(Icons.email,color: Color.fromARGB(255, 10, 1, 71),),
                    focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 10, 1, 71),    ),
                      borderRadius: BorderRadius.circular(15), 
                      ),
                ),
                  onSaved: (val){
                    id =val;
                    //email.text= id!;
                    _Email.text=val!;
                  },
                  
                  validator: (value) {
                    //if(value != Null){
                    if(value!.isEmpty){ return "Empty Feild";}
                    /*if(value.length<8 || (!value.contains('@')) ){
                      return "Empty Feild";
                    }*/

                    if(value.contains('@')){
                      if(!regex.hasMatch(value) && !gmail.hasMatch(value) && !yahoo.hasMatch(value) && !outlook.hasMatch(value)){
                        print("not match");
                        return "invalid email";                      
                      }
                      

                      else{
                        print("Match");
                      }
                    }
                    //if(value.length<8){return"";}
                  //}
                  },
                ),
                Container(height: 20,),
                TextFormField( 
                    
                    controller: _Password,
                    obscureText: offsecure ,
                    decoration: InputDecoration(
                    suffixIcon: IconButton(
                    icon: Icon(Icons.remove_red_eye_outlined,color:  Color.fromARGB(255, 10, 1, 71),),
                    onPressed: () {
                          setState(() {
                            _togglePasswordVisibility();
                           });
                    },
                    ),
                    filled: true,
                    border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15), ),                    
                    fillColor: Colors.white,
                    hintText:"Password" ,
                    icon: Icon(Icons.key,color: Color.fromARGB(255, 10, 1, 71),),
                    focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 10, 1, 71),    ),
                      borderRadius: BorderRadius.circular(15), 
                      ),
                ),                  
                    onSaved: (val){
                    pwd =val;
                    _Password.text=val!;
                  },
                  validator: (value) {
                    //if(value != Null){
                    if(value!.isEmpty){ return "Empty Feild";}
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
                 Container(
                  width: 200,
                  height: 50,
                  margin:EdgeInsets.fromLTRB(185, 0, 1, 20),
                  child: MaterialButton (
                      child: Text("Forgot password?",style: TextStyle(fontSize: 15,),),
                      textColor: Color.fromARGB(255, 107, 107, 107),
                      
                    // color: Color.fromARGB(255 ,248, 154, 0),
                        onPressed:(){
                              Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ForgotPassworD()));
                        /*if(loginform.currentState!.validate()){
                          loginform.currentState!.save();
                          print("valid");
                          print("$id");


                        }else{
                          print("invalid");
                        }*/
                      },

                    ),
                  ),
                Container(
                  width: 433,
                  height: 50,
                  margin:EdgeInsets.fromLTRB(10, 20, 1, 0),
                  child: ButtonTheme(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
                    child :MaterialButton (
                      child: Text("Sign in",style: TextStyle(fontSize: 28,),),
                      textColor: Colors.white,
                      color: Color.fromARGB(255 ,248, 154, 0),
                        onPressed:() async{
                        if(loginform.currentState!.validate()){
                          loginform.currentState!.save();
                          print("valid");
                          print(_Email.text);
                          print(_Password.text);
                          if(_Email.text.length==5){

                            bool result =await networkHandlerC.LoginID(_Email.text, _Password.text);
                            if(result==true){ 
                              Map<String, dynamic>  companyinfo={};
                              companyinfo = await networkHandlerC.fetchCompanyData(_Email.text);
                              if(!companyinfo['deleted']){
                              print("success Login.....");
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage(0) ));
                              }else{
                                _showDialog(context, "Your Account Deleted", false);
                              }
                              }

                            else{print("Failed Login.....");}  
                          }
                          else if(_Email.text.length==8){
                            bool result =await networkHandler.LoginStudentID(_Email.text, _Password.text);
                            if(result==true){ 
                              print("success Login.....");
                               Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomeStu(0) ));}

                            else{print("Failed Login.....");}
                          }
                          else if(regex.hasMatch(_Email.text)){
                            bool result =await networkHandler.LoginStudentFmail(_Email.text, _Password.text);
                            if(result==true){ 
                              print("success Login.....");
                               Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage(0) ));
                              }

                            else{
                              setState(() {
                                loginform.printInfo(info:"invalid email");
                               // return "invalid email";
                              }); }
                          }
                          if(gmail.hasMatch(_Email.text) || yahoo.hasMatch(_Email.text) || outlook.hasMatch(_Email.text)){
                            bool result =await networkHandlerC.LoginEmail(_Email.text, _Password.text);
                            if(result==true){ 
                              print("success Login.....");
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage(0) ));}

                            else{print("Failed Login.....");
                             /*setState(() {
                                loginform.printInfo(info:"invalid email",printFunction: GetUtils.);
                               // return "invalid email";
                              });*/
                            }  
                    
                          }
                          
                        }else{
                          print("invalid");
                        }
                      },
                      /*onPressed: () {
                        print("pressed");
                  },*/),
                  ),
                ),
                /*Container(
                  width: 200,
                  height: 50,
                  margin:EdgeInsets.fromLTRB(185, 0, 1, 20),
                  child: MaterialButton (
                      child: Text("Forgot password?",style: TextStyle(fontSize: 15,),),
                      textColor: Color.fromARGB(255, 107, 107, 107),
                      
                    // color: Color.fromARGB(255 ,248, 154, 0),
                        onPressed:(){
                              Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ForgotPassworD()));
                        /*if(loginform.currentState!.validate()){
                          loginform.currentState!.save();
                          print("valid");
                          print("$id");


                        }else{
                          print("invalid");
                        }*/
                      },

                    ),
                  )
                */
                ],),
                
                //],
                //),
              ),
           ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
                  width: 400,
                  height: 20,
                  margin:EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: MaterialButton (
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text("Don't have an account ?",style: TextStyle(fontSize: 15,color: Colors.white),),
                        Text("  Register now",style: TextStyle(fontSize: 15,color: Colors.amber),),
                      ],),
                      
                      //textColor: Color.fromARGB(255, 107, 107, 107),
                      
                    // color: Color.fromARGB(255 ,248, 154, 0),
                        onPressed:(){
                              
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => signup()));
                        /*if(loginform.currentState!.validate()){
                          loginform.currentState!.save();
                          print("valid");
                          print("$id");


                        }else{
                          print("invalid");
                        }*/
                      },

                    ),
                  )
          ),
        ],
      )
           
     
    );
  }

}
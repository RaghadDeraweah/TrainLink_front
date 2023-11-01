import 'package:flutter/material.dart';
import 'package:untitled4/BStudent.dart';
import 'package:untitled4/BCompany.dart';
import 'package:untitled4/NNavigator.dart';
class Login extends StatelessWidget{
  String? id;
  String email="";
  String? pwd;
  RegExp regex = RegExp(r'^s\d{8}@stu\.najah\.edu$');

  TextEditingController _Email = TextEditingController();
   TextEditingController _Password = TextEditingController();
  GlobalKey<FormState> loginform= GlobalKey();
  final networkHandler = NetworkHandlerS();
  final networkHandlerC = NetworkHandlerC();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:Stack(
        children: [
          Container(
              child:Image.asset("images/loginpic.png",
              fit: BoxFit.cover,
              width: 500,
              height: 1080,
             ), 
             //child: Text("login"),
              ),
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
              
              key: loginform,
              child: PageView(//Column(
                children: [
                Column(children: [
                Container(height: 20,), 
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
                    icon: Icon(Icons.email,color: Color.fromARGB(255, 23, 34, 189),),
                    focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 30, 51, 236),    ),
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
                      if(!regex.hasMatch(value)){
                        print("not match");
                        return "Login with university email";                      
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
                    decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                    borderRadius: BorderRadius.circular(15), ),                    
                    fillColor: Colors.white,
                    hintText:"Password" ,
                    icon: Icon(Icons.email,color: Color.fromARGB(255, 23, 34, 189),),
                    focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 30, 51, 236),    ),
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
                  width: 433,
                  height: 50,
                  margin:EdgeInsets.fromLTRB(38, 20, 1, 10),
                  child: ButtonTheme(
                    shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
                    child :MaterialButton (
                      child: Text("LOGIN",style: TextStyle(fontSize: 28,),),
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
                            print("success Login.....");
                             Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainNavigator() ));}

                          else{print("Failed Login.....");}  
                          }
                          else{bool result =await networkHandler.LoginStudentID(_Email.text, _Password.text);
                          if(result==true){ 
                            print("success Login.....");}

                          else{print("Failed Login.....");}}
                        }else{
                          print("invalid");
                        }
                      },
                      /*onPressed: () {
                        print("pressed");
                  },*/),
                  ),
                ),
                Container(
                  width: 433,
                  height: 50,
                  margin:EdgeInsets.fromLTRB(38, 20, 1, 20),
                  child: MaterialButton (
                      child: Text("Forgot password?",style: TextStyle(fontSize: 15,decoration:TextDecoration.underline),),
                      textColor: Color.fromARGB(255, 107, 107, 107),
                      
                    // color: Color.fromARGB(255 ,248, 154, 0),
                        onPressed:(){
                        if(loginform.currentState!.validate()){
                          loginform.currentState!.save();
                          print("valid");
                          print("$id");


                        }else{
                          print("invalid");
                        }
                      },
                    ),
                  )
                ],),
                
                ],
                ),
              ),
           ),
          ),
        ],
      )
           
     
    );
  }

}
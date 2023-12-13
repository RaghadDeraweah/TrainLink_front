import 'dart:convert' as convert;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';


 
class NetworkHandlerC {
String  baseurl="http://localhost:5000/company" ;
var log = Logger();
FlutterSecureStorage storage = FlutterSecureStorage();
String formater(String url) {
    return baseurl + url;
  }
Future get(String url) async {
    String? token = await storage.read(key: "token");
    url = formater(url);
    // /user/register
    var response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);

      return convert.jsonDecode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

Future<bool> registerUser(String ID, String Name, String CEmail, String Work , String BD, 
 String city, String CPhone, String Password,String Cwebsite ) async {
//  String? token = await storage.read(key: "token");
  bool isExist=false;
    //url = formater(url);
  Map<String, dynamic> data ={
    "ID" : ID,
    "Name" :Name,
    "CEmail" :CEmail,
    "Work" :Work,
    "BD" :BD ,
    "city":city,
    "CPhone":CPhone,
    "Password": Password,
    "Cwebsite":Cwebsite,
  };
  log.d(data);
  final response = await http.post(
    Uri.parse('http://localhost:5000/company/register'),
    headers: {
      'Content-Type': 'application/json', // Set the content type to JSON
//      "Authorization": "Bearer $token"
    },
    body:  convert.jsonEncode(<String, dynamic>
    {
      "ID" : ID,
      "Name" :Name,
      "CEmail" :CEmail,
      "Work" :Work,
      "BD" :BD ,
      "city":city,
      "CPhone":CPhone,
      "Password": Password,
      "Cwebsite":Cwebsite,
}),
  );
  if (response.statusCode == 200) {
     isExist =false;
    // Successful registration
    print('User registered successfully');

   // return response.statusCode;
  }else if(response.statusCode == 409){
    isExist =true;
    print('User already registered ');
  }else {
    // Handle registration error
    print('Registration failed: ${response.body}');
  }
  return isExist;
}
Future<bool> LoginID(String ID, String Password ) async {
    bool isSuccess=false;
    String? token = await storage.read(key: "token");
    final response = await http.post(
      Uri.parse('http://localhost:5000/company/loginID'),
      
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token", // Set the content type to JSON
      },
      body:  convert.jsonEncode(<String, String>
      {
        "ID" : ID,
        "Password": Password,
  }),
    );
    if (response.statusCode == 200) {
      isSuccess=true;
      // Successful registration
      print('Login success !');
      Map<String, dynamic> output =
      convert.jsonDecode(response.body);
      print(output["token"]);
      await storage.write(
       key: "token", value: output["token"]);
    }else if(response.statusCode == 403){
      isSuccess =false;
      print('ID is incorrect');
    }else {
      // Handle registration error
      print('Login failed: ${response.body}');
    }
    return isSuccess;
  }
Future<bool> LoginEmail(String CEmail, String Password ) async {
    bool isSuccess=false;
    String? token = await storage.read(key: "token");
    final response = await http.post(
      Uri.parse('http://localhost:5000/company/loginEmail'),
      
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $token", // Set the content type to JSON
      },
      body:  convert.jsonEncode(<String, String>
      {
        "CEmail" : CEmail,
        "Password": Password,
  }),
    );
    if (response.statusCode == 200) {
      isSuccess=true;
      // Successful registration
      print('Login success !');
      Map<String, dynamic> output =
      convert.jsonDecode(response.body);
      print(output["token"]);
      await storage.write(
       key: "token", value: output["token"]);
    }else if(response.statusCode == 403){
      isSuccess =false;
      print('CEmail is incorrect');
    }else {
      // Handle registration error
      print('Login failed: ${response.body}');
    }
    return isSuccess;
  }


Future<http.StreamedResponse> patchImage( String filepath ,String ID) async {
    var request = http.MultipartRequest('PATCH', Uri.parse('http://localhost:5000/company/add/image'));
    request.fields['ID']=ID;
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
     // "Authorization": "Bearer $token"
    });
    //var response = request.send();
    //return response;
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print(response.statusCode);
      print('Image upload failed: ${response.reasonPhrase}');
  }
  return response;
  }
 Future<http.Response> post(String url, Map<String, dynamic> body) async {
    //String token = await storage.read(key: "token");
    //url = formater(url);
    //log.d(body);
    var response = await http.post(
      Uri.parse('http://localhost:5000/company/register'),
      headers: {
        "Content-type": "application/json",
       // "Authorization": "Bearer $token"
      },
      body: convert.jsonEncode(body),
    );
    return response;
  }

}
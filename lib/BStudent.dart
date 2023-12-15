
import 'dart:convert' as convert;
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
class NetworkHandlerS {
String  baseurl="http://localhost:5000/student" ;
var log = Logger();
FlutterSecureStorage storage = FlutterSecureStorage();
Future<bool> checkinunistudents(String RegNum) async {
  bool isSuccess=false;
  final response = await http.post(
      Uri.parse('http://localhost:5000/unistudents/checkRegNum'),
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
      },
      body:  convert.jsonEncode(<String, String>
      {
        "RegNum" : RegNum,
  }),
    );
    if (response.statusCode == 200) {
       isSuccess=true;
      print('found!');
    }else if(response.statusCode == 403){
      isSuccess =false;
      print('not found');
    }else {
      print('Login failed: ${response.body}');
    }
    return isSuccess;
  }
Future<Map<String, dynamic>> fetchUniStudentData(String RegNum) async {
  final response = await http.get(Uri.parse("http://localhost:5000/unistudents/students/$RegNum"),);

  if (response.statusCode == 200) {
    Map<String, dynamic> studentData = convert.jsonDecode(response.body);
    return studentData;
  } else {
    // Handle errors here
    throw Exception("Failed to load student data");
  }
}
Future<List<Map<String, dynamic>>> fetchStudents() async {
  print("Inside get students ");
    final response = await http.get(Uri.parse('http://localhost:5000/student/all/students'));

    if (response.statusCode == 200) {
      final List<dynamic> data = convert.jsonDecode(response.body);
      final List<Map<String, dynamic>> companies = data.map((company) {
      return {


              'RegNum': company['RegNum'],
              'fname': company['fname'],
              'lname': company['lname'],
              'Work': company['Work'],
              'BD': DateTime.parse(company['BD']),
              'city': company['city'],
              'gender': company['gender'],
              'SEmail': company['SEmail'],
              'SPhone': company['SPhone'],
              'Password': company['Password'],
              'Major': company['Major'],
              'GPa': company['GPa'],
              'Interests': company['Interests'],
              'stustatus': company['stustatus'],
              'startyear': company['startyear'],
              'graduationyear': company['graduationyear'],
              'finishedGroups': company['finishedGroups'],
              'available': company['available'],
              'request': company['request'],
              'img': company['img'],
      };
    }).toList();

    return companies;

    } else {
      throw Exception('Failed to load students');
    }
  }
Future<String> getid() async{
String? token = await storage.read(key: "token");
final parts = token!.split('.');
 if (parts.length != 3) {
    throw FormatException('Invalid token');
  }

  final payload = parts[1];
  String normalized =convert.base64Url.normalize(payload);
  String padding = '=' * ((4 - normalized.length % 4) % 4);
  final decoded = convert.jsonDecode(String.fromCharCodes(convert.base64Url.decode('$normalized$padding')));
  
  // Ensure the payload contains an 'ID' key
  if (decoded is Map<String, dynamic> && decoded.containsKey('RegNum')) {
    print(decoded['RegNum']);
    return decoded['RegNum'].toString() ;
  } else {
    throw FormatException('Token payload does not contain ID');
  }
}
Future<Map<String, dynamic>> fetchStudentData(String RegNum) async {
      String? token = await storage.read(key: "token");
  final response = await http.get(Uri.parse("http://localhost:5000/student/students/$RegNum"),headers: {"Authorization": "Bearer $token"},);

  if (response.statusCode == 200) {
    // Parse the JSON response into a map
    Map<String, dynamic> studentData = convert.jsonDecode(response.body);
    return studentData;
  } else {
    // Handle errors here
    throw Exception("Failed to load student data");
  }
}
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
Future<bool> registerUser(String RegNum, String fname, String lname, String BD , String city, String gender, String SEmail,String SPhone, String Password,String Major,String GPa,List<String> Interestss,
    String stustatus,String startyear,String graduationyear,bool universityTraining) async {
  bool isExist=false;
  final response = await http.post(
      Uri.parse('http://localhost:5000/student/register'),
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
      },
      body:  convert.jsonEncode(<String, dynamic>
      {
        "RegNum" : RegNum,
        "fname" :fname,
        "lname" :lname,
        "BD" :BD ,
        "city":city,
        "gender" :gender,
        "SEmail" :SEmail,
        "SPhone":SPhone,
        "Password": Password,
        "Major":Major,
        "GPa":GPa,
        "Interests":Interestss,
        "stustatus":stustatus,
        "startyear":startyear,
        "graduationyear":graduationyear,
        "universityTraining" :universityTraining
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

Future<bool> LoginStudentID(String RegNum, String Password ) async {
  bool isSuccess=false;
  String? token = await storage.read(key: "token");
  final response = await http.post(
      Uri.parse('http://localhost:5000/student/loginRegNum'),
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
        "Authorization": "Bearer $token", // Set the content type to JSON
      },
      body:  convert.jsonEncode(<String, String>
      {
        "RegNum" : RegNum,
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
      print('Login failed: ${response.body}');
    }
    return isSuccess;
  }
Future<bool> LoginStudentFmail(String SEmail, String Password ) async {
  bool isSuccess=false;
  String? token = await storage.read(key: "token");
  final response = await http.post(
      Uri.parse('http://localhost:5000/student/loginEmail'),
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
        "Authorization": "Bearer $token", // Set the content type to JSON
      },
      body:  convert.jsonEncode(<String, String>
      {
        "SEmail" : SEmail,
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
      print('ID is SEmail');
    }else {
      print('Login failed: ${response.body}');
    }
    return isSuccess;
  }
Future<http.StreamedResponse> patchImage( String filepath ,String RegNum) async {
      var request = http.MultipartRequest('PATCH', Uri.parse('http://localhost:5000/student/add/image'));
      request.fields['RegNum']=RegNum;
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
 /*Future<http.Response> post(String url, Map<String, dynamic> body) async {
    //String token = await storage.read(key: "token");
    //url = formater(url);
    //log.d(body);
    var response = await http.post(
      Uri.parse('http://localhost:5000/student/register'),
      headers: {
        "Content-type": "application/json",
       // "Authorization": "Bearer $token"
      },
      body: convert.jsonEncode(body),
    );
    return response;
  }
    String formater(String url) {
    return baseurl + url;
  }*/
Future<Map<String, dynamic>> fetchStudent(String regNum) async {
  //final response = await http.get(Uri.parse("http://localhost:5000/student/$regNum"));
   Map<String, dynamic> jsonData={};


      final response = await http.get(Uri.parse("http://localhost:5000/student/$regNum"));

    if (response.statusCode == 200) {
      // Parse the JSON response
      jsonData = convert.jsonDecode(response.body);
      String fname = jsonData['fname'];
      String lname = jsonData['lname'];
      // Add other properties as needed

      // Now you can use the retrieved data in your Flutter app
      print('Student Name: $fname $lname');
      return jsonData;
      // Access the student data from the JSON

    } else if (response.statusCode == 404) {
      print('Student not found');
      return jsonData;
    } else {
      print('Failed to load student. Status Code: ${response.statusCode}');
      return jsonData;
    }

}
void updateapllidStuId(String postId, List<dynamic> appliedStuId) async {
  final String apiUrl = 'http://localhost:5000/post/updateReqstu/$postId';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({'appliedStuId': appliedStuId}),
    );

    if (response.statusCode == 200) {
      print('Post updated successfully');
    } else {
      print('Failed to update post. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
Future<void> uploadFile( String filepath,String RegNum) async {
  var request = http.MultipartRequest(
    'PATCH',
    Uri.parse('http://localhost:5000/student/add/cv'),
  );
    // Include the student ID as a field in the request
  request.fields['RegNum'] = RegNum;
  request.files.add(await http.MultipartFile.fromPath('file', filepath));
  request.headers.addAll({
        "Content-Type": 'application/pdf',
      // "Authorization": "Bearer $token" ,,       // "Content-type": "multipart/form-data",
      });

  var response = await request.send();
  if (response.statusCode == 200) {
    print('File uploaded successfully');
  } else {
    print('Failed to upload file');
  }
}
Future<void> downloadFile(String fileUrl, String fileName) async {
  try {
    var response = await http.get(Uri.parse(fileUrl));

    if (response.statusCode == 200) {
      var dir = await getExternalStorageDirectory();
      var file = File('${dir!.path}/$fileName');

      await file.writeAsBytes(response.bodyBytes);
      OpenFile.open(file.path);
      print('File downloaded successfully');
    } else {
      print('Failed to download file');
    }
  } catch (error) {
    print('Error downloading file: $error');
  }
}
Future<List<Map<String, dynamic>>> fetchPosts() async {
    final response = await http.get(Uri.parse("http://localhost:5000/post/posts"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = convert.jsonDecode(response.body);
      List<Map<String, dynamic>> posts = [];

      for (var item in jsonData) {
        posts.add(item);
      }

      return posts;
    } else {
      //print("faild : ${response.body}");
      throw Exception("faild : ${response.body}");
    }
}
void updateunitrain(String RegNum, bool universityTraining) async {
  final String apiUrl = 'http://localhost:5000/student/unitrain/$RegNum';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({'universityTraining': universityTraining}),
    );

    if (response.statusCode == 200) {
      print('student updated successfully');
    } else {
      print('Failed to update student. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
void updategroupidstud(String RegNum, String groupid ,bool available) async {
  final String apiUrl = 'http://localhost:5000/student/ingroup/$RegNum/$available';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({'groupid': groupid}),
    );

    if (response.statusCode == 200) {
      print('student updated successfully');
    } else {
      print('Failed to update student. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
void updatepostidstud(String RegNum, String postid ,bool request) async {
  final String apiUrl = 'http://localhost:5000/student/inpost/$RegNum/$request';

 try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({'postid': postid}),
    );

    if (response.statusCode == 200) {
      print('student updated successfully');
    } else {
      print('Failed to update student. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
//student post
Future<String> addstudentpost(String  RegNum,
        String  sname,
        String simg,
        String content,
        String projectlink, 
        )async {
  String idd="";

  final response = await http.post(
    Uri.parse('http://localhost:5000/student-post/add'),
    headers: {
      'Content-Type': 'application/json', // Set the content type to JSON
    },
    body:  convert.jsonEncode(<String, dynamic>
    {
        "RegNum":RegNum,
        "sname": sname,
        "simg": simg,
        "content": content,
        "projectlink": projectlink, 

}),
  );
  if (response.statusCode == 200) {

     idd=convert.jsonDecode(response.body);
    print(idd);
    print('post added successfully');
  }else if(response.statusCode == 409){
    idd="false";
    print('group already posted ');
  }else {
    idd="false";
    print('add post failed: ${response.body}');
  }
return idd;
}
Future<List<Map<String, dynamic>>> fetchStuPosts(String RegNum) async {
    final response = await http.get(Uri.parse("http://localhost:5000/student-post/posts/$RegNum"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = convert.jsonDecode(response.body);
      List<Map<String, dynamic>> posts = [];

      for (var item in jsonData) {
        posts.add(item);
      }

      return posts;
    } else {
      //print("faild : ${response.body}");
      throw Exception("faild : ${response.body}");
    }
}
Future<String> addstupost(String  RegNum,
        String  sname,
        String simg,
        String content,
        String projectlink, 
        )async {
  String idd="";

  final response = await http.post(
    Uri.parse('http://localhost:5000/student-post/add'),
    headers: {
      'Content-Type': 'application/json', // Set the content type to JSON
    },
    body:  convert.jsonEncode(<String, dynamic>
    {
        "RegNum":RegNum,
        "sname": sname,
        "simg": simg,
        "content": content,
        "projectlink": projectlink, 

}),
  );
  if (response.statusCode == 200) {

     idd=convert.jsonDecode(response.body);
    print(idd);
    print('post added successfully');
  }else if(response.statusCode == 409){
    idd="false";
    print('post already posted ');
  }else {
    idd="false";
    print('add post failed: ${response.body}');
  }
return idd;
}
Future<List<Map<String, dynamic>>> getStuposts(String RegNum) async {
  final response = await http.get(Uri.parse('http://localhost:5000/student-post/posts/$RegNum'));

  if (response.statusCode == 200) {
    // Parse the response JSON
    final List<dynamic> responseData = convert.jsonDecode(response.body);
    
    // Convert the data to the desired format
    final List<Map<String, dynamic>> groupposts = responseData.map((grouppost) {
      return {
        'RegNum': grouppost['RegNum'],
        'sname': grouppost['sname'],
        'simg': grouppost['simg'],
        'content': grouppost['content'],
        'projectlink': grouppost['projectlink'],
      };
    }).toList();

    return groupposts;
  } else {
    // Handle errors
    throw Exception('Failed to load student posts');
  }
}
void logout() async {
    await storage.delete(key: "token");
  }
void updatefinishedcourses(String RegNum, List<dynamic> finishedGroups) async {
  final String apiUrl = 'http://localhost:5000/student/updateFinishedgroups/$RegNum';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({'finishedGroups': finishedGroups}),
    );

    if (response.statusCode == 200) {
      print('student updated successfully');
    } else {
      print('Failed to update post. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

}
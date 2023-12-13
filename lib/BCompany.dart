import 'dart:convert' as convert;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';

 
class NetworkHandlerC {
String  baseurl="http://localhost:5000/company" ;
var log = Logger();
//String IDSend="";
FlutterSecureStorage storage = FlutterSecureStorage();
Future<String> getidddd() async{
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
  if (decoded is Map<String, dynamic> && decoded.containsKey('ID')) {
    print(decoded['ID']);
    return decoded['ID'].toString() ;
  } else {
    throw FormatException('Token payload does not contain ID');
  }
}

String formater(String url) {
    return baseurl + url;
  }
Future get(String url) async {
    String? token = await storage.read(key: "token");
    url = formater(url);
    print(url);
    // /user/register
    var response = await http.get(
      Uri.parse(url),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("passed");
      log.i(response.body);

      return convert.jsonDecode(response.body);
    }
    else{
      print("not passed");
    }
    log.i(response.body);
    log.i(response.statusCode);
  }
Future<Map<String, dynamic>> fetchCompanyData(String companyId) async {
      String? token = await storage.read(key: "token");
  final response = await http.get(Uri.parse("http://localhost:5000/company/companies/$companyId"),headers: {"Authorization": "Bearer $token"},);

  if (response.statusCode == 200) {
    // Parse the JSON response into a map
    Map<String, dynamic> companyData = convert.jsonDecode(response.body);
    return companyData;
  } else {
    // Handle errors here
    throw Exception("Failed to load company data");
  }
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
      Map<String, dynamic> output = convert.jsonDecode(response.body);
      print(output["token"]);
      await storage.write(key: "token", value: output["token"]);
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

Future<List<Map<String, dynamic>>> fetchCompanies() async {
  print("Inside get companies //////////////////////////////////////////");
    final response = await http.get(Uri.parse('http://localhost:5000/company/all/companies'));

    if (response.statusCode == 200) {
      final List<dynamic> data = convert.jsonDecode(response.body);
      final List<Map<String, dynamic>> companies = data.map((company) {
      return {
              'ID': company['ID'],
              'Name': company['Name'],
              'CEmail': company['CEmail'],
              'Work': company['Work'],
              'BD': DateTime.parse(company['BD']),
              'city': company['city'],
              'CPhone': company['CPhone'],
              'Password': company['Password'],
              'website': company['website'],
              'img': company['img'],

      };
    }).toList();

    return companies;

    } else {
      throw Exception('Failed to load companies');
    }
  }
void updatetrainee(String ID, List<dynamic> trainee) async {
  final String apiUrl = 'http://localhost:5000/company/updatetrainee/$ID';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({'trainee': trainee}),
    );

    if (response.statusCode == 200) {
      print('company trainee updated successfully');
    } else {
      print('Failed to update company trainee. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
void updaterating(String ID, List<dynamic> rating) async {
  final String apiUrl = 'http://localhost:5000/company/updaterating/$ID';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({'rating': rating}),
    );

    if (response.statusCode == 200) {
      print('company rating updated successfully');
    } else {
      print('Failed to update company rating. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}

Future<String> addpost(String  cid,
        String cname,
        String cimg,
        List appliedStuId, // or specify any applied student IDs
        String lockDate, // Set your lock date
        String postContent,
        String location,
        int seats, // Number of available seats
        String field,
        bool isRemotly,
        bool isUni,
        int hours,
        String semester
        ,)async {
  String idd="";

  final response = await http.post(
    Uri.parse('http://localhost:5000/post/add'),
    headers: {
      'Content-Type': 'application/json', // Set the content type to JSON
//      "Authorization": "Bearer $token"
    },
    body:  convert.jsonEncode(<String, dynamic>
    {
        "cid": cid,
        "cname": cname,
        "cimg": cimg,
        "lockDate": lockDate, // Set your lock date
        "postContent": postContent,
        "location": location,
        "seats": seats, // Number of available seats
        "field": field,
        "isRemotly":isRemotly,
        "isUni":isUni,
        "hours": hours,
        "semester" : semester, 
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
//post img
Future<http.StreamedResponse> patchImagepost( String filepath ,String _id) async {
    var request = http.MultipartRequest('PATCH', Uri.parse('http://localhost:5000/post/add/image'));
    request.fields['_id']=_id;
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
void updateIsFreezed(String postId, bool isFreezed) async {
  final String apiUrl = 'http://localhost:5000/post/lock/$postId';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({'isFreezed': isFreezed}),
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
void updatehasgroup(String postId, bool hasgroup) async {
  final String apiUrl = 'http://localhost:5000/post/hasgroup/$postId';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({'hasgroup': hasgroup}),
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
Future<String> addgroup(String  postid,
        String  cid,
        String cname,
        String cimg,
        String groupname, // or specify any applied student IDs
        String about, // Set your lock date
        String des,
        List membersStudent,
        List membersStudentId,
            )async {
  String idd="";

  final response = await http.post(
    Uri.parse('http://localhost:5000/group/add'),
    headers: {
      'Content-Type': 'application/json', // Set the content type to JSON
    },
    body:  convert.jsonEncode(<String, dynamic>
    {
        "postid":postid,
        "cid": cid,
        "cname": cname,
        "cimg": cimg,
        "groupname": groupname, 
        "about": about,
        "des": des,
        "membersStudent": membersStudent, 
        "membersStudentId":membersStudentId,
       // "phase":phase,
}),
  );
  if (response.statusCode == 200) {

     idd=convert.jsonDecode(response.body);
    print(idd);
    print('group added successfully');
  }else if(response.statusCode == 409){
    idd="false";
    print('group already posted ');
  }else {
    idd="false";
    print('add group failed: ${response.body}');
  }
return idd;
}
//group img
Future<http.StreamedResponse> patchImagegroup( String filepath ,String _id) async {
    var request = http.MultipartRequest('PATCH', Uri.parse('http://localhost:5000/group/add/image'));
    request.fields['_id']=_id;
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
Future<List<Map<String, dynamic>>> getGroups(String cid) async {
  final response = await http.get(Uri.parse('http://localhost:5000/group/gruops/$cid'));

  if (response.statusCode == 200) {
    // Parse the response JSON
    final List<dynamic> responseData = convert.jsonDecode(response.body);
    
    // Convert the data to the desired format
    final List<Map<String, dynamic>> groups = responseData.map((group) {
      return {
        '_id': group['_id'],
        'postid':group['postid'],
        'cid': group['cid'],
        'cname': group['cname'],
        'cimg': group['cimg'],
        'groupname': group['groupname'],
        'about': group['about'],
        'des': group['des'],
        'groupImg': group['groupImg'],
        'membersStudent': group['membersStudent'],
        'membersStudentId': group['membersStudentId'],
        'islocked': group['islocked'],
        'phase': group['phase'],
        'StartDate': group['StartDate'],
        'EndDate': group['EndDate'],
      };
    }).toList();

    return groups;
  } else {
    // Handle errors
    throw Exception('Failed to load groups');
  }
}
void updateislocked(String groupId, bool islocked) async {
  final String apiUrl = 'http://localhost:5000/group/lock/$groupId';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({'islocked': islocked}),
    );

    if (response.statusCode == 200) {
      print('group updated successfully');
    } else {
      print('Failed to update group. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
Future<Map<String, dynamic>> getGroupById(String groupId) async {
  final response = await http.get(Uri.parse('http://localhost:5000/group/groupid/$groupId'));

  if (response.statusCode == 200) {
    // Parse the response JSON
    final Map<String, dynamic> group = convert.jsonDecode(response.body);
    return group;
  } else {
    // Handle errors
    throw Exception('Failed to load group');
  }
}
Future<List<Map<String, dynamic>>> fetchPosts(String companyId) async {
    final response = await http.get(Uri.parse("http://localhost:5000/post/posts/$companyId"));

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
//group posts
Future<String> addgrouppost(String  groupid,
        String  cid,
        String cname,
        String cimg,
        String content, 
        )async {
  String idd="";

  final response = await http.post(
    Uri.parse('http://localhost:5000/group-post/add'),
    headers: {
      'Content-Type': 'application/json', // Set the content type to JSON
    },
    body:  convert.jsonEncode(<String, dynamic>
    {
        "groupid":groupid,
        "cid": cid,
        "cname": cname,
        "cimg": cimg,
        "content": content, 

}),
  );
  if (response.statusCode == 200) {

     idd=convert.jsonDecode(response.body);
    print(idd);
    print('group added successfully');
  }else if(response.statusCode == 409){
    idd="false";
    print('group already posted ');
  }else {
    idd="false";
    print('add group failed: ${response.body}');
  }
return idd;
}
Future<http.StreamedResponse> patchImagegrouppost( String filepath ,String _id) async {
    var request = http.MultipartRequest('PATCH', Uri.parse('http://localhost:5000/group-post/add/image'));
    request.fields['_id']=_id;
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
Future<List<Map<String, dynamic>>> getGroupsposts(String groupid) async {
  final response = await http.get(Uri.parse('http://localhost:5000/group-post/posts/$groupid'));

  if (response.statusCode == 200) {
    // Parse the response JSON
    final List<dynamic> responseData = convert.jsonDecode(response.body);
    
    // Convert the data to the desired format
    final List<Map<String, dynamic>> groupposts = responseData.map((grouppost) {
      return {
        '_id': grouppost['_id'],
        'groupid': grouppost['groupid'],
        'cid': grouppost['cid'],
        'cname': grouppost['cname'],
        'cimg': grouppost['cimg'],
        'content': grouppost['content'],
        'postDate': grouppost['postDate'],
        'postImg': grouppost['postImg'],
      };
    }).toList();

    return groupposts;
  } else {
    // Handle errors
    throw Exception('Failed to load groupposts');
  }
}
Future<List<Map<String, dynamic>>> getGroupspostsid(String cid) async {
  final response = await http.get(Uri.parse('http://localhost:5000/group-post/postsid/$cid'));

  if (response.statusCode == 200) {
    // Parse the response JSON
    final List<dynamic> responseData = convert.jsonDecode(response.body);
    
    // Convert the data to the desired format
    final List<Map<String, dynamic>> groupposts = responseData.map((grouppost) {
      return {
        '_id': grouppost['_id'],
        'groupid': grouppost['groupid'],
        'cid': grouppost['cid'],
        'cname': grouppost['cname'],
        'cimg': grouppost['cimg'],
        'content': grouppost['content'],
        'postDate': grouppost['postDate'],
        'postImg': grouppost['postImg'],
      };
    }).toList();

    return groupposts;
  } else {
    // Handle errors
    throw Exception('Failed to load groupposts');
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
void updatesubmitedStuId(String _id, List<dynamic> submitedStuId) async {
  final String apiUrl = 'http://localhost:5000/group-task/updateSubstu/$_id';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({'submitedStuId': submitedStuId}),
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
//tasks
Future<String> addgrouptask(String  groupid,
        String  cid,
        String cname,
        String cimg,
        String TaskName,
        String lockDate,
        String TaskDes,

        )async {
  String idd="";
 print("*******************************"+lockDate);
  final response = await http.post(
    Uri.parse('http://localhost:5000/group-task/add'),
    headers: {
      'Content-Type': 'application/json', // Set the content type to JSON
    },
    body:  convert.jsonEncode(<String, dynamic>
    {
        "groupid":groupid,
        "cid": cid,
        "cname": cname,
        "cimg": cimg,
        "TaskName": TaskName,
        "lockDate":lockDate,
        "TaskDes": TaskDes,

}),
  );
  if (response.statusCode == 200) {

     idd=convert.jsonDecode(response.body);
    print(idd);
    print('task added successfully');
  }else if(response.statusCode == 409){
    idd="false";
    print('task already exist ');
  }else {
    idd="false";
    print('add task failed: ${response.body}');
  }
return idd;
}
Future<void> uploadtask( String filepath,String _id) async {
  var request = http.MultipartRequest(
    'PATCH',
    Uri.parse('http://localhost:5000/group-task/add/taskpdf'),
  );
    // Include the student ID as a field in the request
  request.fields['_id'] = _id;
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
Future<List<Map<String, dynamic>>> getGrouptasks(String groupid) async {
  final response = await http.get(Uri.parse('http://localhost:5000/group-task/tasks/$groupid'));

  if (response.statusCode == 200) {
    // Parse the response JSON
    final List<dynamic> responseData = convert.jsonDecode(response.body);
    
    // Convert the data to the desired format
    final List<Map<String, dynamic>> grouptasks = responseData.map((grouptask) {
      return {
        '_id': grouptask['_id'],
        'groupid': grouptask['groupid'],
        'cid': grouptask['cid'],
        'cname': grouptask['cname'],
        'cimg': grouptask['cimg'],
        "TaskName": grouptask['TaskName'],
        "lockDate":grouptask['lockDate'],
        "TaskDes": grouptask['TaskDes'],
        "postDate":grouptask['postDate'],
        "TaskStatus":grouptask['TaskStatus'],
        "taskpdf":grouptask['taskpdf'],
        "submitedStuId": grouptask['submitedStuId'],
               
      };
    }).toList();

    return grouptasks;
  } else {
    // Handle errors
    throw Exception('Failed to load grouptasks');
  }
}
Future<Map<String, dynamic>> fetchTaskData(String groupid,String _id) async {
  print("from ooooooooooooooooooooooooo $_id");
  final response = await http.get(Uri.parse("http://localhost:5000/group-task/tasks/$groupid/$_id"));

  if (response.statusCode == 200) {
    // Parse the JSON response into a map
    Map<String, dynamic> taskData = convert.jsonDecode(response.body);
    return taskData;
  } else {
    // Handle errors here
    throw Exception("Failed to load task data");
  }
}
Future<String> addaskSub(String  groupid,
        String  TaskId,
        String StuId,
        String taskLink,
        String notes,
        )async {
  String idd="";
  final response = await http.post(
    Uri.parse('http://localhost:5000/task-submit/add'),
    headers: {
      'Content-Type': 'application/json', // Set the content type to JSON
    },
    body:  convert.jsonEncode(<String, dynamic>
    {
        "groupid":groupid,
        "TaskId": TaskId,
        "StuId": StuId,
        "taskLink": taskLink,
        "notes": notes,
}),
  );
  if (response.statusCode == 200) {

     idd=convert.jsonDecode(response.body);
    print(idd);
    print('task submission added successfully');
  }else if(response.statusCode == 409){
    idd="false";
    print('task submission already exist ');
  }else {
    idd="false";
    print('add task failed: ${response.body}');
  }
return idd;
}
Future<List<Map<String, dynamic>>> gettasksubmissionsStu(String groupid,String StuId) async {
  final response = await http.get(Uri.parse('http://localhost:5000/task-submit/tasksforStu/$groupid/$StuId'));

  if (response.statusCode == 200) {
    // Parse the response JSON
    final List<dynamic> responseData = convert.jsonDecode(response.body);
    
    // Convert the data to the desired format
    final List<Map<String, dynamic>> grouptasks = responseData.map((grouptask) {
      return {

        '_id': grouptask['_id'],
        'groupid': grouptask['groupid'],
        'TaskId': grouptask['TaskId'],
        'StuId': grouptask['StuId'],
        "postDate":grouptask['postDate'],
        "taskLink":grouptask['taskLink'],
        "notes":grouptask['notes'],
               
      };
    }).toList();

    return grouptasks;
  } else {
    // Handle errors
    throw Exception('Failed to load grouptasks');
  }
}
Future<List<Map<String, dynamic>>> gettasksubmission(String groupid,String TaskId) async {
    print("hellllllo"+groupid);
  print("Hiiiiiiiiiiiiiiiiiiiiii"+TaskId);
  final response = await http.get(Uri.parse('http://localhost:5000/task-submit/tasks/$groupid/$TaskId'));

  if (response.statusCode == 200) {
    // Parse the response JSON
    final List<dynamic> responseData = convert.jsonDecode(response.body);
    
    // Convert the data to the desired format
    final List<Map<String, dynamic>> grouptasks = responseData.map((grouptask) {
      return {

        '_id': grouptask['_id'],
        'groupid': grouptask['groupid'],
        'TaskId': grouptask['TaskId'],
        'StuId': grouptask['StuId'],
        "postDate":grouptask['postDate'],
        "taskLink":grouptask['taskLink'],
        "notes":grouptask['notes'],
               
      };
    }).toList();

    return grouptasks;
  } else {
    // Handle errors
    throw Exception('Failed to load grouptasks');
  }
}
void updatemembersStudentGroup(String groupid, List<dynamic> membersStudentId) async {
  final String apiUrl = 'http://localhost:5000/group/updateReqstu/$groupid';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({'membersStudentId': membersStudentId}),
    );

    if (response.statusCode == 200) {
      print('group updated successfully');
    } else {
      print('Failed to update group. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
void updatemembersStudentGroupmaps(String groupid, List<dynamic> membersStudent) async {
  final String apiUrl = 'http://localhost:5000/group/updateReqstuMaps/$groupid';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({'membersStudent': membersStudent}),
    );

    if (response.statusCode == 200) {
      print('group updated successfully');
    } else {
      print('Failed to update group. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
void updateGroupphase(String groupid, String phase) async {
  final String apiUrl = 'http://localhost:5000/group/phase/$groupid';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({'phase': phase}),
    );

    if (response.statusCode == 200) {
      print('group updated successfully');
    } else {
      print('Failed to update group. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
void updateStartDate(String groupid) async {
  final String apiUrl = 'http://localhost:5000/group/start/$groupid';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('group start date updated successfully');
    } else {
      print('Failed to update group. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
void updateEndDate(String groupid) async {
  final String apiUrl = 'http://localhost:5000/group/end/$groupid';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('group end date updated successfully');
    } else {
      print('Failed to update group. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
void deleteGroup(String groupid) async {
  final String apiUrl = 'http://localhost:5000/group/delete/$groupid';

  try {
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      print('group deleted successfully');
    } else {
      print('Failed to delete group. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
//reports
Future<String> addreport(String  groupid,
        String  StuId,
        String StuName,
        String StuImg,
        String week,
        String hours,
        String DaysOfWeek,
        String nonattendancehours,        
        String excuse,
        String work,        
        )async {
  String idd="";
  final response = await http.post(
    Uri.parse('http://localhost:5000/report/add'),
    headers: {
      'Content-Type': 'application/json', // Set the content type to JSON
    },
    body:  convert.jsonEncode(<String, dynamic>
    {
        "groupid":groupid,
        "StuId": StuId,
        "StuName": StuName,
        "StuImg": StuImg,
        "week": week,
        "hours":hours,
        "DaysOfWeek": DaysOfWeek,
        "nonattendancehours": nonattendancehours,
        "excuse": excuse,
        "work": work,
}),
  );
  if (response.statusCode == 200) {

     idd=convert.jsonDecode(response.body);
    print(idd);
    print('report added successfully');
  }else if(response.statusCode == 409){
    idd="false";
    print('report already exist ');
  }else {
    idd="false";
    print('add report failed: ${response.body}');
  }
return idd;
}
Future<List<Map<String, dynamic>>> getReports(String groupid) async {
  final response = await http.get(Uri.parse('http://localhost:5000/report/reports/$groupid'));

  if (response.statusCode == 200) {
    // Parse the response JSON
    final List<dynamic> responseData = convert.jsonDecode(response.body);
    
    // Convert the data to the desired format
    final List<Map<String, dynamic>> groups = responseData.map((group) {
      return {

        '_id': group['_id'],
        'groupid':group['groupid'],
        'StuId': group['StuId'],
        'StuName': group['StuName'],
        'StuImg': group['StuImg'],
        'week': group['week'],
        'postDate': group['postDate'],
        'hours': group['hours'],
        'actualhours': group['actualhours'],
        'companyFeedback': group['companyFeedback'],
        'universityFeedback': group['universityFeedback'],
        'companyApproval': group['companyApproval'],
        'universityApproval': group['universityApproval'],
        'DaysOfWeek': group['DaysOfWeek'] ,
        'nonattendancehours': group['nonattendancehours'] ,
        'excuse': group['excuse'] ,
        'work': group['work'] ,

      };
    }).toList();

    return groups;
  } else {
    // Handle errors
    throw Exception('Failed to load groups');
  }
}
Future<List<Map<String, dynamic>>> getReportsweek(String groupid,String week) async {
  final response = await http.get(Uri.parse('http://localhost:5000/report/reportsweek/$groupid/$week'));

  if (response.statusCode == 200) {
    // Parse the response JSON
    final List<dynamic> responseData = convert.jsonDecode(response.body);
    
    // Convert the data to the desired format
    final List<Map<String, dynamic>> groups = responseData.map((group) {
      return {

        '_id': group['_id'],
        'groupid':group['groupid'],
        'StuId': group['StuId'],
        'StuName': group['StuName'],
        'StuImg': group['StuImg'],
        'week': group['week'],
        'postDate': group['postDate'],
                'hours': group['hours'],
        'actualhours': group['actualhours'],
        'companyFeedback': group['companyFeedback'],
        'universityFeedback': group['universityFeedback'],
        'companyApproval': group['companyApproval'],
        'universityApproval': group['universityApproval'],
        'DaysOfWeek': group['DaysOfWeek'] ,
        'nonattendancehours': group['nonattendancehours'] ,
        'excuse': group['excuse'] ,
        'work': group['work'] ,
      };
    }).toList();

    return groups;
  } else {
    // Handle errors
    throw Exception('Failed to load groups');
  }
}
Future<List<Map<String, dynamic>>> getReportsweekStudent(String groupid,String week,String StuId) async {
  final response = await http.get(Uri.parse('http://localhost:5000/report/reportstudent/$groupid/$week/$StuId'));

  if (response.statusCode == 200) {
    // Parse the response JSON
    final List<dynamic> responseData = convert.jsonDecode(response.body);
    
    // Convert the data to the desired format
    final List<Map<String, dynamic>> groups = responseData.map((group) {
      return {

        '_id': group['_id'],
        'groupid':group['groupid'],
        'StuId': group['StuId'],
        'StuName': group['StuName'],
        'StuImg': group['StuImg'],
        'week': group['week'],
        'postDate': group['postDate'],
                'hours': group['hours'],
        'actualhours': group['actualhours'],
        'companyFeedback': group['companyFeedback'],
        'universityFeedback': group['universityFeedback'],
        'companyApproval': group['companyApproval'],
        'universityApproval': group['universityApproval'],
        'DaysOfWeek': group['DaysOfWeek'] ,
        'nonattendancehours': group['nonattendancehours'] ,
        'excuse': group['excuse'] ,
        'work': group['work'] ,
      };
    }).toList();

    return groups;
  } else {
    // Handle errors
    throw Exception('Failed to load groups');
  }
}
Future<List<Map<String, dynamic>>> getReportsStudent(String groupid,String StuId) async {
  final response = await http.get(Uri.parse('http://localhost:5000/report/reports/$groupid/$StuId'));

  if (response.statusCode == 200) {
    // Parse the response JSON
    final List<dynamic> responseData = convert.jsonDecode(response.body);
    
    // Convert the data to the desired format
    final List<Map<String, dynamic>> groups = responseData.map((group) {
      return {

        '_id': group['_id'],
        'groupid':group['groupid'],
        'StuId': group['StuId'],
        'StuName': group['StuName'],
        'StuImg': group['StuImg'],
        'week': group['week'],
        'postDate': group['postDate'],
        'hours': group['hours'],
        'actualhours': group['actualhours'],
        'companyFeedback': group['companyFeedback'],
        'universityFeedback': group['universityFeedback'],
        'companyApproval': group['companyApproval'],
        'universityApproval': group['universityApproval'],
        'DaysOfWeek': group['DaysOfWeek'] ,
        'nonattendancehours': group['nonattendancehours'] ,
        'excuse': group['excuse'] ,
        'work': group['work'] ,
      };
    }).toList();

    return groups;
  } else {
    // Handle errors
    throw Exception('Failed to load groups');
  }
}
/*Future<Map<String, dynamic>> getReportsweekStudent(String groupid,String week,String StuId) async {
  final response = await http.get(Uri.parse('http://localhost:5000/report/reportstudent/$groupid/$week/$StuId'));

  if (response.statusCode == 200) {
    // Parse the response JSON
    final Map<String, dynamic> report = convert.jsonDecode(response.body);
    return report;
  } else {
    // Handle errors
    throw Exception('Failed to load report');
  }

  if (response.statusCode == 200) {
    // Parse the response JSON
    final List<dynamic> responseData = convert.jsonDecode(response.body);
    
    // Convert the data to the desired format
    final List<Map<String, dynamic>> groups = responseData.map((group) {
      return {

        '_id': group['_id'],
        'groupid':group['groupid'],
        'StuId': group['StuId'],
        'StuName': group['StuName'],
        'StuImg': group['StuImg'],
        'week': group['week'],
        'postDate': group['postDate'],
        'companyFeedback': group['companyFeedback'],
        'universityFeedback': group['universityFeedback'],
        'companyApproval': group['companyApproval'],
        'universityApproval': group['universityApproval'],
        'reportpdf': group['reportpdf'],
      };
    }).toList();

    return groups;
  } else {
    // Handle errors
    throw Exception('Failed to load groups');
  }
}*/
void updateCompanyFeedback(String _id, String companyFeedback,String actualhours) async {
  final String apiUrl = 'http://localhost:5000/report/companyfeedback/$actualhours/$_id';

  try {
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: convert.jsonEncode({'companyFeedback': companyFeedback}),
    );

    if (response.statusCode == 200) {
      print('report updated successfully');
    } else {
      print('Failed to update report. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error: $error');
  }
}
/*Future<void> downloadFile(String fileUrl, String fileName) async {
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
}*/
//forms
Future<String> addcompanyform(String  groupid,
        String  cid,
        String StuId,
        String StuName,
        String StuImg,
        String hours,
        String q1,
        String q2,
        String q3,
        String q4,
        int mark,
        int submitedReports


        )async {
  String idd="";
  final response = await http.post(
    Uri.parse('http://localhost:5000/companyform/add'),
    headers: {
      'Content-Type': 'application/json', // Set the content type to JSON
    },
    body:  convert.jsonEncode(<String, dynamic>
    {
         "CID": cid,
        "groupid":groupid,
        "StuId": StuId,
        "StuName": StuName,
        "StuImg": StuImg,
        "hours": hours,
        "q1":q1,
        "q2": q2,
        "q3": q3,
        "q4": q4,
        "mark":mark,
        "submitedReports":submitedReports
}),
  );
  if (response.statusCode == 200) {

     idd=convert.jsonDecode(response.body);
    print(idd);
    print('task added successfully');
  }else if(response.statusCode == 409){
    idd="false";
    print('task already exist ');
  }else {
    idd="false";
    print('add task failed: ${response.body}');
  }
return idd;
}
Future<List<Map<String, dynamic>>> getForms(String groupid) async {
  final response = await http.get(Uri.parse('http://localhost:5000/companyform/forms/$groupid'));

  if (response.statusCode == 200) {
    // Parse the response JSON
    final List<dynamic> responseData = convert.jsonDecode(response.body);
    
    // Convert the data to the desired format
    final List<Map<String, dynamic>> groups = responseData.map((group) {
      return {

        '_id': group['_id'],
        'CID': group['CID'],
        'groupid':group['groupid'],
        'StuId': group['StuId'],
        'StuName': group['StuName'],
        'StuImg': group['StuImg'],
        'postDate': group['postDate'],
        'hours': group['hours'],
        'q1': group['q1'],
        'q2': group['q2'],
        'q3': group['q3'],
        'q4': group['q4'],
        'universityApproval': group['universityApproval'],
      };
    }).toList();

    return groups;
  } else {
    // Handle errors
    throw Exception('Failed to load forms');
  }
}
  void logout() async {
    await storage.delete(key: "token");
  }
}

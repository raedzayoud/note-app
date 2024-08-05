import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

String _basicAuth = 'Basic ' +
    base64Encode(utf8.encode(
        'raed:raed12'));
  
    Map<String, String> myheaders = {
          'authorization': _basicAuth
    };
class Crud {
   
     



  GetRequest(String url) async {
    try {
      var reponse = await http.get(Uri.parse(url));
      if (reponse.statusCode == 200) {
        return jsonEncode(reponse.body);
      } else {
        print("Error ${reponse.statusCode}");
      }
    } catch (e) {
      print("Error catch ");
    }
  }

   Future<Map<String, dynamic>> PostRequest(String url, Map<String, String> data) async {
    var response = await http.post(Uri.parse(url), body: data,headers: myheaders);
    
    // Print the response body for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    // Check if the response is JSON
    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        print('Error decoding JSON: $e');
        return {'status': 'error', 'message': 'Invalid JSON response'};
      }
    } else {
      return {'status': 'error', 'message': 'Server error'};
    }
  }

  postRequestwithFile(String url, Map data, File file) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));
    var length = await file.length();
    var stream = http.ByteStream(file.openRead());
    var multipartFile = http.MultipartFile("file", stream, length,
        filename: basename(file.path));
    request.files.add(multipartFile);
    request.headers.addAll(myheaders);
    data.forEach((key, value) {
      request.fields[key] = value;
    });
    var myrequest = await request.send();
    var response = await http.Response.fromStream(myrequest);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error");
    }
  }
}

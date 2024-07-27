import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<Map<String, dynamic>> PostRequest(
      String url, Map<String, String> data) async {
    final response = await http.post(Uri.parse(url), body: data);
    if (response.statusCode == 200) {
      // Parse the JSON response
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

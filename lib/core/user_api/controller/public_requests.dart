import 'dart:convert';
import 'package:cord_2/core/user_api/model/user.dart';
import 'package:http/http.dart' as http;

class PublicRequests {

  static String baseUrl = 'https://cord0.me/api';
  static late User currentUser ;
  static List<User> allUsers = [];

  static List<User> getCustomUser (List<String> phones) {
    List<User> users = [] ;
    allUsers.forEach((element) {
      if(phones.contains(element.phone)){
        users.add(element);
      }
    });
    return users ;
  }


  static Future<void> getAllUsers({required String token}) async {
    http.Response response = await http.get(Uri.parse('$baseUrl/users',),headers: {
      'Authorization':'Bearer $token',
    });
    List hold = json.decode(response.body);
    for(var item in hold){
      allUsers.add(User.fromJson(item));
    }
  }
  static Future<void> getCurrentUser({required String token})async {
    http.Response response = await http.get(Uri.parse('$baseUrl/users/current-user',),headers: {
      'Authorization':'Bearer $token',
    });
    currentUser = User.fromJson(json.decode(response.body));

  }

}

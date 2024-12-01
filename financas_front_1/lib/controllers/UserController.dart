import 'dart:convert';

import 'package:financas_front_1/models/user.dart';
import 'package:financas_front_1/network/network.dart';
import 'package:financas_front_1/repositories/template_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  static Future<Map<String,dynamic>> login(String username, String password) async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var user;
      if (!localStorage.containsKey('token') || !localStorage.containsKey('user')) {
        user = await Network().getAcess(username, password);
      } else {
        user = jsonDecode(localStorage.getString('user')!);
      }
      
      return user;
    } on Exception catch (e) {
      print(e);
      return {'user':User(),'message':e.toString()};
    }
  }

  static Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
  ) async {
    var fullUrl = Uri.http(
      dotenv.env['host']!,
      '/signup',
    );
    late Map<String, dynamic> data;
    late Response response;

    try {
      var response = await http.post(fullUrl,
          body:
              jsonEncode({"email": email, "password": password, 'name': name}),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          });
      data = jsonDecode(response.body);
    } on Exception catch (e) {
      print(e);
    }
    return data;
  }
}

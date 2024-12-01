import 'dart:convert';
import 'package:financas_front_1/models/user.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Network {
  //if you are using android studio emulator, change localhost to 10.0.2.2
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token')!)['token'];
  }

  getAcess(String username, String password) async {
    var fullUrl = Uri.http(
      dotenv.env['host']!,
      '/login',
    );

    var response = await http.post(fullUrl,
        body: jsonEncode({
          "email": username,
          "password": password,
        }),
        headers: setHeaders());
    var responseToken = jsonDecode(response.body);

    if (responseToken['message'] == 'login') {
      User user = User.fromJson({
        'id': responseToken['data']['id'],
        'name': responseToken['data']['name']
      });
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('user', jsonEncode(user));
      localStorage.setString('access_token', responseToken['data']['token']);
      localStorage.setString(
          'valid_until',
          DateTime.now()
              .add(Duration(seconds: responseToken['data']['expiresIn']))
              .toString());
      return {'user':user,'message':responseToken['message']};
    }else{
       return {'user':User(),'message':responseToken['message']};
    }
    
  }

  refreshToken() async {
    var fullUrl = Uri.http(
      dotenv.env['host']!,
      '/oauth/token',
    );
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var response = await http.post(fullUrl,
        body: jsonEncode({
          "grant_type": "refresh_token",
          'refresh_token':
              json.decode(localStorage.getString('refresh_token')!),
          "client_id": dotenv.env['client_id'],
          "client_secret": dotenv.env['client_secret'],
          "scope": ""
        }),
        headers: setHeaders());
    var responseToken = jsonDecode(response.body);
    if (responseToken['error'] == null) {
      // if( getIt.isRegistered<Token>()){
      //   getIt<Token>().updateData( responseToken['access_token'],  responseToken['refresh_token'], DateTime.now().add(Duration(seconds: responseToken['expires_in'])));
      // }else{
      //   getIt.registerSingleton(Token(accessToken: responseToken['access_token'],refreshToken:  responseToken['refresh_token'],validUntil:  DateTime.now().add(Duration(seconds: responseToken['expires_in']))));
      // }
      localStorage.setString('access_token', responseToken['access_token']);
      localStorage.setString('refresh_token', responseToken['refresh_token']);
      localStorage.setString(
          'valid_until',
          DateTime.now()
              .add(Duration(seconds: responseToken['expires_in']))
              .toString());
      return true;
    }
    return false;
  }

  Map<String, String> setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Access-Control-Allow-Origin": "*",
        'Authorization': 'Bearer $token'
      };
}

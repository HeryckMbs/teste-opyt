import 'dart:convert';

import 'package:financas_front_1/models/categoria.dart';
import 'package:financas_front_1/network/network.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoriaController {
  static Future<List<Categoria>> getAllCategorias(String tipo) async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String token = localStorage.getString('access_token') ?? '';
      if (token == '') {
        return [];
      }

      var fullUrl =
          Uri.http(dotenv.env['host']!, '/categorias', {"tipo": tipo});

      late Map<String, dynamic> data;
      late Response response;

      response = await http.get(fullUrl, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      data = jsonDecode(response.body);
      List<Categoria> categorias = [];
      for (var categoria in data['data']) {
        categorias.add(Categoria.fromJson(categoria));
      }
      return categorias;
    } on Exception catch (e) {
      print(e);
    }
    return [];
  }

}

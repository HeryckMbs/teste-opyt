import 'dart:convert';
import 'dart:ffi';

import 'package:financas_front_1/models/categoria.dart';
import 'package:financas_front_1/models/transacao.dart';
import 'package:financas_front_1/models/user.dart';
import 'package:financas_front_1/network/network.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransacaoController {
  static Future<List<Transacao>> getAllTransacao(
      String dtInicio, String dtFim, String categoria,String ordenacao) async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String token = localStorage.getString('access_token')!;
      User user = User.fromJson(jsonDecode(localStorage.getString('user')!));

      if (token == '') {
        return [];
      }
      var fullUrl = Uri.http(dotenv.env['host']!, '/transacao', {
        "user": user.id.toString(),
        "dtInicio": dtInicio,
        "dtFim": dtFim,
        "categoria": categoria.toString(),
        "ordenacao": ordenacao.toString()
      });

      late Map<String, dynamic> data;
      late Response response;

      response = await http.get(fullUrl, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      data = jsonDecode(response.body);
      List<Transacao> transacoes = [];
      for (var transacao in data['data']) {
        transacoes.add(Transacao.fromJson(transacao));
      }
      return transacoes;
    } on Exception catch (e) {
      print(e);
      return [];
    }
  }

  static Future<Map<dynamic, dynamic>> getSaldoReceitaDespesaAno(
      String ano) async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String token = localStorage.getString('access_token')!;
      User user = User.fromJson(jsonDecode(localStorage.getString('user')!));

      if (token == '') {
        return {};
      }
      var fullUrl =
          Uri.http(dotenv.env['host']!, '/transacao/find-saldo-anual', {
        "user": user.id.toString(),
        "ano": ano,
      });

      late Map<String, dynamic> data;
      late Response response;

      response = await http.get(fullUrl, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      data = jsonDecode(response.body);

      return data['data'];
    } on Exception catch (e) {
      print(e);
      return {};
    }
  }

  static Future<List<Map<String, dynamic>>> findTransacaoCategory(
      String ano) async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String token = localStorage.getString('access_token')!;
      User user = User.fromJson(jsonDecode(localStorage.getString('user')!));

      if (token == '') {}

      var fullUrl = Uri.http(
        dotenv.env['host']!,
        '/transacao/findTransacaoCategory',
        {
          "user": user.id.toString(),
          "ano": ano,
        },
      );

      late Map<String, dynamic> data;
      late Response response;

      response = await http.get(fullUrl, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      data = jsonDecode(response.body);
      List<Map<String, dynamic>> result = [];
      for (var transacao in data['data']) {
        result.add({
          'categoria': transacao['categoria'],
          'valor': double.parse(transacao['valor'] as String),
          'percentual': double.parse(transacao['percentual'] as String),
        });
      }
      return result;
    } on Exception catch (e) {
      print(e);
      return [];
    }
  }

  static Future<double> getAllSaldoTotal(String ano) async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String token = localStorage.getString('access_token')!;
      User user = User.fromJson(jsonDecode(localStorage.getString('user')!));

      if (token == '') {
        return 0.0;
      }

      var fullUrl = Uri.http(
        dotenv.env['host']!,
        '/transacao/saldo-total/${user.id}',
        {
          "ano": ano,
        },
      );

      late Map<String, dynamic> data;
      late Response response;

      response = await http.get(fullUrl, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      data = jsonDecode(response.body);

      return double.parse(data['data']['saldo'] ?? '0.0');
    } on Exception catch (e) {
      print(e);
    }
    return 0.0;
  }

  static Future<double> getAllSaldoReceita(String ano) async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String token = localStorage.getString('access_token')!;
      User user = User.fromJson(jsonDecode(localStorage.getString('user')!));

      if (token == '') {
        return 0.0;
      }

      var fullUrl = Uri.http(
        dotenv.env['host']!,
        '/transacao/saldo-receita/${user.id}',
        {
          "ano": ano,
        },
      );

      late Map<String, dynamic> data;
      late Response response;

      response = await http.get(fullUrl, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      data = jsonDecode(response.body);

      return double.parse(data['data']['totalReceitas'] ?? '0.0');
    } on Exception catch (e) {
      print(e);
    }
    return 0.0;
  }

  static Future<double> getAllSaldoDespesa(String ano) async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String token = localStorage.getString('access_token')!;
      User user = User.fromJson(jsonDecode(localStorage.getString('user')!));

      if (token == '') {
        return 0.0;
      }

      var fullUrl = Uri.http(
        dotenv.env['host']!,
        '/transacao/saldo-despesa/${user.id}',
        {
          "ano": ano,
        },
      );

      late Map<String, dynamic> data;
      late Response response;

      response = await http.get(fullUrl, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      data = jsonDecode(response.body);

      return double.parse(data['data']['totalDespesas'] ?? '0.0');
    } on Exception catch (e) {
      print(e);
    }
    return 0.0;
  }

  static Future<Map<String, dynamic>> createTransacao(
      String competencia,
      double valor,
      int idCategoria,
      String descricao,
      String tipoTransacao) async {
    var fullUrl = Uri.http(
      dotenv.env['host']!,
      '/transacao',
    );
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    late Map<String, dynamic> data;
    String token = localStorage.getString('access_token')!;

    try {
      User user = User.fromJson(jsonDecode(localStorage.getString('user')!));

      var response = await http.post(fullUrl,
          body: jsonEncode({
            'competencia': competencia,
            'valor': valor,
            'descricao': descricao,
            'tipo': tipoTransacao,
            'categoria': {'id': idCategoria},
            'user': {'id': user.id},
          }),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });
      data = jsonDecode(response.body);
    } on Exception catch (e) {
      print(e);
    }
    return data;
  }
}

import 'package:financas_front_1/controllers/CategoriaController.dart';
import 'package:financas_front_1/controllers/TransacaoController.dart';
import 'package:financas_front_1/models/categoria.dart';
import 'package:financas_front_1/models/transacao.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TransacaoRepository with ChangeNotifier, DiagnosticableTreeMixin {
  List<Categoria> _categorias = [];

  double _saldo = 0;
  double get saldo => _saldo;

  double _receita = 0;
  double get receita => _receita;

  double _despesa = 0;
  double get despesa => _despesa;

  List<Categoria> get categorias => _categorias;
  List<Map<String, String>> _categoriasMenuItem = [];

  List<Map<String, String>> get categoriasMenuItem => _categoriasMenuItem;

  List<Transacao> _transacoes = [];
  List<Transacao> get transacoes => _transacoes;
  List<Map<String, dynamic>> _transacoesCategory = [];
  List<Map<String, dynamic>> get transacoesCategory => _transacoesCategory;
  Map<dynamic,dynamic> _transacoesAno = {};
  Map<dynamic,dynamic> get transacoesAno => _transacoesAno;
  setCategorias(String tipo) async {
    _categorias = await CategoriaController.getAllCategorias(tipo);

    _categoriasMenuItem = _categorias
        .map((Categoria e) =>
            {"key": e.id.toString(), "value": e.nome.toString()})
        .toList();
    notifyListeners();
  }

  getSaldo(String ano) async {
    _saldo = await TransacaoController.getAllSaldoTotal(ano);
    notifyListeners();
  }

  getTransacoes(String dtInicio, String dtFim, String categoria,String ordenacao) async {
    _transacoes =
        await TransacaoController.getAllTransacao(dtInicio, dtFim, categoria,ordenacao);
    notifyListeners();
  }

  getTransacoesCategory(String ano) async {
    _transacoesCategory = await TransacaoController.findTransacaoCategory(ano);
    notifyListeners();
  }

  getTransacoesAno(String ano) async {
    _transacoesAno = await TransacaoController.getSaldoReceitaDespesaAno(ano);
    notifyListeners();
  }

  clearTransacoes() {
    _transacoes = [];
    notifyListeners();
  }

  getSaldoReceita(String ano)  async {
    _receita = await TransacaoController.getAllSaldoReceita(ano);
    notifyListeners();
  }


  getSaldoDespesa(String ano)  async {
    _despesa = await TransacaoController.getAllSaldoDespesa(ano);
    notifyListeners();
  }
}

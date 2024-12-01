import 'package:financas_front_1/models/categoria.dart';

class Transacao {
  int? id;
  double? valor;
  String? descricao;
  String? tipo; // Adicionado
  String? competencia; // Adicionado
  Categoria? categoria;
  String? createdAt;
  String? updatedAt;

  Transacao({
    this.id,
    this.valor,
    this.descricao,
    this.tipo, // Adicionado
    this.competencia, // Adicionado
    this.categoria,
    this.createdAt,
    this.updatedAt,
  });

  // Método para criar uma instância a partir de um JSON
  Transacao.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    valor = json['valor']?.toDouble();
    descricao = json['descricao'];
    tipo = json['tipo']; // Adicionado
    competencia = json['competencia']; // Adicionado
    categoria = json['categoria'] != null ? Categoria.fromJson(json['categoria']) : null;
    createdAt = json['created_at']; // Corrigido para o formato do JSON
    updatedAt = json['updated_at']; // Corrigido para o formato do JSON
  }

  // Método para converter a instância em JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['valor'] = valor;
    data['descricao'] = descricao;
    data['tipo'] = tipo; // Adicionado
    data['competencia'] = competencia; // Adicionado
    if (categoria != null) {
      data['categoria'] = categoria!.toJson();
    }
    data['created_at'] = createdAt; // Corrigido para o formato do JSON
    data['updated_at'] = updatedAt; // Corrigido para o formato do JSON
    return data;
  }
}

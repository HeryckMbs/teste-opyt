class User {
  int? id;
  String? email;
  String? name;
  String? createdAt;
  String? updatedAt;

  User({
    this.id,
    this.email,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  // Método para criar uma instância a partir de um JSON
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  // Método para converter a instância em JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

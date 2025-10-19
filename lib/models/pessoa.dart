import 'dart:convert';

class Pessoa {
  final String id;
  final String nome;
  final String cpf;
  final String telefone;

  Pessoa({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
  });

  // Fábrica para criar Pessoa a partir de um JSON (mapa)
  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      cpf: map['cpf'] ?? '',
      telefone: map['telefone'] ?? '',
    );
  }

  // Método para converter Pessoa para um JSON (mapa)
  Map<String, dynamic> toMap() {
    return {
      // 'id': id, // Geralmente não enviamos o ID ao criar/atualizar
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
    };
  }

  // Métodos helper para JSON string
  factory Pessoa.fromJson(String source) => Pessoa.fromMap(json.decode(source));
  String toJson() => json.encode(toMap());
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pessoa.dart';

class ApiService {
  static const String _baseUrl = 'https://68f43cd7b16eb6f468341e30.mockapi.io/a1mobile';

  // --- Autenticação (Simulada) ---

  Future<bool> register(String username, String email, String senha) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/usuario'), // Endpoint atualizado
      body: {
        'username': username,
        'email': email, // Campo novo
        'senha': senha // Campo atualizado
      },
    );
    return response.statusCode == 201;
  }

  Future<bool> login(String usuario, String senha) async {
    print('--- [LOG API Service] ---');
    print('Tentando fazer login...');
    print('Username recebido: "$usuario"');
    print('Senha recebida: "$senha"');

    // --- CORREÇÃO ---
    // Vamos construir a URL de forma segura para lidar com
    // caracteres especiais, como espaços.

    // 1. Parseia sua URL base
    final baseUrlParsed = Uri.parse(_baseUrl);

    // 2. Constrói a URL final de forma segura
    // Isso garante que "usuario 1" vire "usuario%201"
    final url = Uri.https(
      baseUrlParsed.host, // Ex: "68f43cd7b16eb6f468341e30.mockapi.io"
      '${baseUrlParsed.path}/usuario', // Ex: "/a1mobile/usuario"
      { // Parâmetros de consulta como um Mapa
        'usuario': usuario, // "usuario 1"
        'senha': senha,     // "senha 1"
      },
    );

    // Este log agora mostrará a URL 100% correta e codificada
    print('URL da Requisição (GET): $url');

    try {
      final response = await http.get(url);

      print('Resposta da API recebida.');
      print('Status Code: ${response.statusCode}');
      print('Corpo (Body): ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> users = json.decode(response.body);
        final bool usuarioEncontrado = users.isNotEmpty;

        print('Deserialização OK.');
        print('Usuário encontrado na lista? $usuarioEncontrado');
        print('--------------------------');

        return usuarioEncontrado;
      } else {
        print('Erro: A API retornou um status não-200. (Verifique o caminho/nome do recurso)');
        print('--------------------------');
        return false;
      }
    } catch (e) {
      print('!!! EXCEÇÃO CAPTURADA !!!');
      print('Erro ao tentar fazer a requisição HTTP: $e');
      print('Verifique sua conexão com a internet ou a URL base.');
      print('--------------------------');
      return false;
    }
  }

  // --- CRUD de Pessoas ---

  Future<List<Pessoa>> getPessoas() async {
    final response = await http.get(Uri.parse('$_baseUrl/pessoa')); // Endpoint atualizado
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Pessoa.fromMap(json)).toList();
    } else {
      throw Exception('Falha ao carregar pessoas');
    }
  }

  Future<Pessoa> createPessoa(String nome, String cpf, String telefone) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/pessoa'), // Endpoint atualizado
      body: {
        'nome': nome,
        'cpf': cpf,         // Campo atualizado
        'telefone': telefone // Campo atualizado
      },
    );
    if (response.statusCode == 201) {
      return Pessoa.fromJson(response.body);
    } else {
      throw Exception('Falha ao criar pessoa');
    }
  }

  Future<Pessoa> updatePessoa(String id, String nome, String cpf, String telefone) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/pessoa/$id'), // Endpoint atualizado
      body: {
        'nome': nome,
        'cpf': cpf,         // Campo atualizado
        'telefone': telefone // Campo atualizado
      },
    );
    if (response.statusCode == 200) {
      return Pessoa.fromJson(response.body);
    } else {
      throw Exception('Falha ao atualizar pessoa');
    }
  }

  Future<bool> deletePessoa(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/pessoa/$id')); // Endpoint atualizado
    return response.statusCode == 200;
  }
}
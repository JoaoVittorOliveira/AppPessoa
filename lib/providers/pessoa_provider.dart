import 'package:flutter/foundation.dart';
import '../models/pessoa.dart';
import '../services/api_service.dart';

enum PessoaState { Idle, Loading, Success, Error }

class PessoaProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Pessoa> _pessoas = [];
  List<Pessoa> get pessoas => _pessoas;

  PessoaState _state = PessoaState.Idle;
  PessoaState get state => _state;

  Future<void> fetchPessoas() async {
    _state = PessoaState.Loading;
    notifyListeners();
    try {
      _pessoas = await _apiService.getPessoas();
      _state = PessoaState.Success;
    } catch (e) {
      _state = PessoaState.Error;
    }
    notifyListeners();
  }

  Future<void> addPessoa(String nome, String cpf, String telefone) async {
    try {
      Pessoa novaPessoa = await _apiService.createPessoa(nome, cpf, telefone);
      _pessoas.add(novaPessoa);
      notifyListeners();
    } catch (e) {
      // Tratar erro
    }
  }

  Future<void> updatePessoa(Pessoa pessoa, String novoNome, String novoCpf, String novoTelefone) async {
    try {
      Pessoa pessoaAtualizada = await _apiService.updatePessoa(
          pessoa.id, novoNome, novoCpf, novoTelefone);
      final index = _pessoas.indexWhere((p) => p.id == pessoa.id);
      if (index != -1) {
        _pessoas[index] = pessoaAtualizada;
        notifyListeners();
      }
    } catch (e) {
      // Tratar erro
    }
  }

  Future<void> deletePessoa(String id) async {
    try {
      await _apiService.deletePessoa(id);
      _pessoas.removeWhere((p) => p.id == id); // Remove da lista local
      notifyListeners();
    } catch (e) {
      // Tratar erro
    }
  }
}
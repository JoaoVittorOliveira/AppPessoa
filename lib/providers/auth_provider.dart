import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _checkLoginStatus(); // Verifica se já estava logado ao iniciar o app
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    try {
      // 'password' aqui é a variável do app
      // 'senha' é o que a API espera
      // Nosso ApiService faz essa "tradução"
      final success = await _apiService.login(username, password);
      if (success) {
        _isLoggedIn = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    notifyListeners();
  }

  // Método de registro (não altera o estado de login, só registra)
  Future<bool> register(String username, String email, String password) {
    // Passa a senha do app (password) para o service, que chama de 'senha'
    return _apiService.register(username, email, password);
  }
}
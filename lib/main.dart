import 'package:app_pessoas/providers/auth_provider.dart';
import 'package:app_pessoas/providers/pessoa_provider.dart';
import 'package:app_pessoas/screens/home_screen.dart';
import 'package:app_pessoas/screens/login_screen.dart';
import 'package:app_pessoas/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider para gerenciar todos os estados da aplicação
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PessoaProvider()),
      ],
      child: MaterialApp(
        title: 'Gestão de Pessoas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        // Lógica principal: O que mostrar na home?
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            // Se estiver logado, vai para HomeScreen, senão, para LoginScreen
            return auth.isLoggedIn ? HomeScreen() : LoginScreen();
          },
        ),
        // Rotas nomeadas para navegação
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
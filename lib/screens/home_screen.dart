import 'package:app_pessoas/models/pessoa.dart';
import 'package:app_pessoas/providers/auth_provider.dart';
import 'package:app_pessoas/providers/pessoa_provider.dart';
import 'package:app_pessoas/screens/pessoa_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Precisamos criar esta tela de formulário
// import 'pessoa_form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Carrega as pessoas assim que a tela é iniciada
    // listen: false dentro do initState é obrigatório
    Provider.of<PessoaProvider>(context, listen: false).fetchPessoas();
  }

  void _logout() {
    Provider.of<AuthProvider>(context, listen: false).logout();
    // O Consumer no main.dart cuidará da navegação para o login
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir esta pessoa?'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          TextButton(
            child: Text('Excluir'),
            onPressed: () {
              Provider.of<PessoaProvider>(context, listen: false)
                  .deletePessoa(id);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  // Função para navegar para o formulário (criar ou editar)
  void _navigateToForm({Pessoa? pessoa}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        // Navega para a PessoaFormScreen
        // Passa a 'pessoa' se for edição (pessoa != null)
        // Passa 'null' se for criação (pessoa == null)
        builder: (ctx) => PessoaFormScreen(pessoa: pessoa),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pessoas'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Consumer<PessoaProvider>(
        builder: (context, provider, child) {
          if (provider.state == PessoaState.Loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.state == PessoaState.Error) {
            return Center(child: Text('Falha ao carregar dados.'));
          }
          if (provider.pessoas.isEmpty) {
            return Center(child: Text('Nenhuma pessoa cadastrada.'));
          }

          // Se temos dados, mostramos a lista
          return ListView.builder(
            itemCount: provider.pessoas.length,
            itemBuilder: (context, index) {
              final pessoa = provider.pessoas[index];
              return ListTile(
                leading: CircleAvatar(
                  // Utilizando a inicial
                  child: Text(pessoa.nome.isNotEmpty ? pessoa.nome[0].toUpperCase() : '?'),
                ),
                title: Text(pessoa.nome),
                subtitle: Text(pessoa.cpf),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _navigateToForm(pessoa: pessoa), // Editar
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(pessoa.id), // Deletar
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navigateToForm(), // Criar
      ),
    );
  }
}
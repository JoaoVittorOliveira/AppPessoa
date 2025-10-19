import 'package:app_pessoas/models/pessoa.dart';
import 'package:app_pessoas/providers/pessoa_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PessoaFormScreen extends StatefulWidget {
  // Esta tela pode receber uma Pessoa (para edição)
  // Se 'pessoa' for nula, significa que é um novo cadastro
  final Pessoa? pessoa;

  PessoaFormScreen({this.pessoa});

  @override
  _PessoaFormScreenState createState() => _PessoaFormScreenState();
}

class _PessoaFormScreenState extends State<PessoaFormScreen> {
  // Controladores para os campos de texto
  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();

  bool _isLoading = false;
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();

    // Verifica se estamos em modo de edição
    _isEditMode = widget.pessoa != null;

    if (_isEditMode) {
      // Se for edição, preenche os campos com os dados existentes
      _nomeController.text = widget.pessoa!.nome;
      _cpfController.text = widget.pessoa!.cpf;
      _telefoneController.text = widget.pessoa!.telefone;
    }
  }

  @override
  void dispose() {
    // Limpa os controladores quando a tela for descartada
    _nomeController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    // Pega os valores dos controladores
    final nome = _nomeController.text;
    final cpf = _cpfController.text;
    final telefone = _telefoneController.text;

    // Validação simples (pode ser melhorada)
    if (nome.isEmpty || cpf.isEmpty || telefone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Pega o provider (listen: false pois estamos em um método)
    final provider = Provider.of<PessoaProvider>(context, listen: false);

    try {
      if (_isEditMode) {
        // --- MODO EDIÇÃO ---
        // Passamos a pessoa original (com ID) e os novos dados
        await provider.updatePessoa(
          widget.pessoa!,
          nome,
          cpf,
          telefone,
        );
      } else {
        // --- MODO CRIAÇÃO ---
        await provider.addPessoa(nome, cpf, telefone);
      }

      // Se tudo deu certo, volta para a tela anterior (HomeScreen)
      if (mounted) { // Verifica se o widget ainda está na tela
        Navigator.of(context).pop();
      }

    } catch (e) {
      // Em caso de erro
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha ao salvar pessoa. $e')),
        );
      }
    } finally {
      // Garante que o loading pare, mesmo se der erro
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título dinâmico
        title: Text(_isEditMode ? 'Editar Pessoa' : 'Nova Pessoa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _cpfController,
              decoration: InputDecoration(labelText: 'CPF'),
              keyboardType: TextInputType.number, // Teclado numérico
            ),
            SizedBox(height: 10),
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
              keyboardType: TextInputType.phone, // Teclado de telefone
            ),
            SizedBox(height: 30),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _saveForm,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
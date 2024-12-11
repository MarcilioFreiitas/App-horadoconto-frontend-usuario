import 'package:flutter/material.dart';
import 'package:hora_do_conto/views/profile/components/Custom_AppBar.dart';
import 'package:hora_do_conto/widgets/config.dart';
import 'package:hora_do_conto/widgets/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EditarPerfilScreen extends StatefulWidget {
  final Map<String, String?> userInfo;
  final VoidCallback onSave;

  EditarPerfilScreen({required this.userInfo, required this.onSave});

  @override
  _EditarPerfilScreenState createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _sobreNomeController;
  late TextEditingController _cpfController;
  late TextEditingController _emailController;
  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.userInfo['nome']);
    _sobreNomeController =
        TextEditingController(text: widget.userInfo['sobreNome']);
    _cpfController = TextEditingController(text: widget.userInfo['cpf']);
    _emailController = TextEditingController(text: widget.userInfo['email']);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _sobreNomeController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _salvarAlteracoes() async {
    if (_formKey.currentState!.validate()) {
      // Busque os valores de senha e role
      String? senha = await storage.read(key: 'user_senha');
      String? role = await storage.read(key: 'user_role');

      final response = await http.patch(
        Uri.parse(
            '${Config.baseUrl}/usuarios/alterar/${widget.userInfo['id']}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String?>{
          'nome': _nomeController.text,
          'sobreNome': _sobreNomeController.text,
          'cpf': _cpfController.text,
          'email': _emailController.text,
          'senha': senha,
          'role': role,
        }),
      );

      if (response.statusCode == 200) {
        // Atualize os dados no armazenamento seguro
        await storage.write(key: 'user_nome', value: _nomeController.text);
        await storage.write(
            key: 'user_sobreNome', value: _sobreNomeController.text);
        await storage.write(key: 'user_cpf', value: _cpfController.text);
        await storage.write(key: 'user_email', value: _emailController.text);

        // Chame o callback onSave para atualizar a tela de perfil
        widget.onSave();

        // Mostre uma mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados atualizados com sucesso!')),
        );
        Navigator.pop(context);
      } else {
        // Mostre uma mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar dados. Tente novamente.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(context), // Tema do aplicativo
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F9), // Cor de fundo
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: CustomAppBar(), // Usando o CustomAppBar sem parâmetros
        ),
        body: SingleChildScrollView(
          // Adicionando scroll para resolver overflow
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8.0), // Adicionando espaço no topo
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu nome';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16), // Espaço extra entre os campos
                    TextFormField(
                      controller: _sobreNomeController,
                      decoration: InputDecoration(labelText: 'Sobrenome'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu sobrenome';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16), // Espaço extra entre os campos
                    TextFormField(
                      controller: _cpfController,
                      decoration: InputDecoration(labelText: 'CPF'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu CPF';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16), // Espaço extra entre os campos
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                        height: 24.0), // Aumentando o espaço antes do botão
                    ElevatedButton(
                      onPressed: _salvarAlteracoes,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black, // Cor preta
                      ),
                      child: Text('Salvar Alterações'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

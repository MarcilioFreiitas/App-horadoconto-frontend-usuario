import 'package:flutter/material.dart';
import 'package:hora_do_conto/widgets/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final String token;

  ResetPasswordPage({required this.token});

  @override
  Widget build(BuildContext context) {
    print("Token recebido na página de redefinição: $token");
    return Scaffold(
      appBar: AppBar(
        title: Text("Redefinir Senha"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Nova senha"),
              obscureText: true,
            ),
            SizedBox(height: 20), // Espaçamento entre os campos de input
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: "Confirmar nova senha"),
              obscureText: true,
            ),
            SizedBox(
                height:
                    20), // Espaçamento entre o último campo de input e o botão
            ElevatedButton(
              onPressed: () {
                if (_passwordController.text ==
                    _confirmPasswordController.text) {
                  _resetPassword(context, _passwordController.text);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('As senhas não correspondem.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(primary: Colors.black),
              child: Text("Redefinir Senha"),
            ),
          ],
        ),
      ),
    );
  }

  void _resetPassword(BuildContext context, String password) async {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/password/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'password': password}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Senha redefinida com sucesso!')),
      );
      // Redirecionar para a tela de login
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao redefinir a senha. Tente novamente.')),
      );
    }
  }
}

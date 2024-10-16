import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();
  final String token;

  ResetPasswordPage({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Redefinir Senha")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Nova Senha"),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                _resetPassword(context, _passwordController.text);
              },
              child: Text("Redefinir Senha"),
            ),
          ],
        ),
      ),
    );
  }

  void _resetPassword(BuildContext context, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.0.101:8080/password/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token, 'password': password}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Senha redefinida com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao redefinir a senha. Tente novamente.')),
      );
    }
  }
}

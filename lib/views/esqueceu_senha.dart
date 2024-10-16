import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Esqueceu a Senha")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            ElevatedButton(
              onPressed: () {
                // Chamar API para solicitar redefinição de senha
                _requestPasswordReset(context, _emailController.text);
              },
              child: Text("Enviar"),
            ),
          ],
        ),
      ),
    );
  }

  void _requestPasswordReset(BuildContext context, String email) async {
    // Mostrar o diálogo de carregamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Enviando email..."),
            ],
          ),
        );
      },
    );

    final response = await http.post(
      Uri.parse('http://10.0.0.101:8080/password/reset'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'email': email},
    );

    // Fechar o diálogo de carregamento
    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email de redefinição de senha enviado!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro ao enviar email de redefinição de senha.')),
      );
    }
  }
}

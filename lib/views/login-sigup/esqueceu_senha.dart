import 'package:flutter/material.dart';
import 'package:hora_do_conto/widgets/config.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Esqueceu a Senha"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Por favor, insira seu email para solicitar a redefinição de senha.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Chamar API para solicitar redefinição de senha
                _requestPasswordReset(context, _emailController.text);
              },
              style: ElevatedButton.styleFrom(primary: Colors.black),
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
      Uri.parse('${Config.baseUrl}/password/reset'),
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

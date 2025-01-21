import 'package:flutter/material.dart';
import 'package:hora_do_conto/views/login-sigup/VerifyCodePage.dart';
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
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Icon(
                  Icons.lock_open,
                  size: 100,
                  color: Colors.black,
                ),
                SizedBox(height: 30),
                Text(
                  "Por favor, insira seu email para solicitar a redefinição de senha.",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _requestPasswordReset(context, _emailController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text("Enviar"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _requestPasswordReset(BuildContext context, String email) async {
    // Mostrar diálogo de carregamento
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

    Navigator.of(context).pop();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Código enviado para o seu email!')),
      );
      // Navegar para a tela de verificação do código
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyCodePage(email: email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar o código de redefinição de senha.'),
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:hora_do_conto/widgets/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResetPasswordPage extends StatefulWidget {
  final String token; // Recebe o token validado da tela anterior

  ResetPasswordPage({required this.token});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Salvar a nova senha no backend
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/password/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'token': widget.token, // Enviar o token validado
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 200 &&
        response.body.contains('Senha redefinida')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Senha redefinida com sucesso!')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao redefinir a senha. Tente novamente.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    bool _isKeyboardVisible = bottomInset > 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Redefinir Senha"),
        backgroundColor: const Color.fromARGB(255, 12, 7, 20),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                if (!_isKeyboardVisible) ...[
                  SizedBox(height: 30),
                  Icon(
                    Icons.lock_reset,
                    size: 100,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  SizedBox(height: 30),
                ],
                Form(
                  key: _formKey,
                  child: FocusScope(
                    node: FocusScopeNode(),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Nova Senha",
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira a nova senha';
                            } else if (value.length < 6) {
                              return 'A senha deve ter pelo menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: "Confirmar Nova Senha",
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'As senhas não correspondem';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _resetPassword,
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromARGB(255, 11, 8, 17),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              textStyle: TextStyle(fontSize: 18),
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : Text("Redefinir Senha"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

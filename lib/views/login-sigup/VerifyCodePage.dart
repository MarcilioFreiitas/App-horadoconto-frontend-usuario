import 'package:flutter/material.dart';
import 'package:hora_do_conto/views/login-sigup/redefinir_senha.dart';
import 'package:hora_do_conto/widgets/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// Importar a nova tela

class VerifyCodePage extends StatefulWidget {
  final String email;

  VerifyCodePage({required this.email});

  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _codeController = TextEditingController();

  Future<void> _validateCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Validar o código no backend
    final validateResponse = await http.post(
      Uri.parse('${Config.baseUrl}/password/validate'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'email': widget.email, 'codigo': _codeController.text},
    );

    if (validateResponse.statusCode == 200 &&
        validateResponse.body == 'Código válido') {
      // Navegar para a tela de redefinição de senha com o token
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordPage(token: _codeController.text),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Código inválido ou expirado.')),
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
        title: Text("Validar Código"),
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
                    Icons.security,
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
                          controller: _codeController,
                          decoration: InputDecoration(
                            labelText: "Código de 4 dígitos",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o código';
                            } else if (value.length != 4) {
                              return 'O código deve ter 4 dígitos';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _validateCode,
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
                                : Text("Validar Código"),
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

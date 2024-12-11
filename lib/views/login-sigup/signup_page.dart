import 'package:flutter/material.dart';
import '../../service/auth_service_sigunp.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final NameController = TextEditingController();
  final LastNameController = TextEditingController();
  final emailController = TextEditingController();
  final cpfController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: NameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: LastNameController,
                decoration: InputDecoration(
                  labelText: 'Sobre nome',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira seu sobrenome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Por favor, insira um e-mail válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty || value.length < 8) {
                    return 'A senha deve ter pelo menos 8 caracteres';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: cpfController,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                ),
                validator: (value) {
                  if (value!.isEmpty || value.length != 11) {
                    return 'Por favor, insira um CPF válido';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                child: Text('Cadastrar'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                      _errorMessage = '';
                    });
                    try {
                      signup(
                          NameController.text,
                          LastNameController.text,
                          emailController.text,
                          passwordController.text,
                          cpfController.text);
                      setState(() {
                        _isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Usuário cadastrado com sucesso!')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                        _errorMessage = e.toString();
                      });
                    }
                  }
                },
              ),
              if (_isLoading) CircularProgressIndicator(),
              if (_errorMessage != '')
                Text('Erro ao cadastrar usuário: $_errorMessage'),
            ],
          ),
        ),
      ),
    );
  }
}

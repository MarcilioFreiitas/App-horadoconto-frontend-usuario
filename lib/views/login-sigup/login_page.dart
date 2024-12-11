import 'package:flutter/material.dart';
import 'package:hora_do_conto/service/auth_service_login.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                String email = emailController.text;
                String password = passwordController.text;
                login(email, password, context);
              },
              child: Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}

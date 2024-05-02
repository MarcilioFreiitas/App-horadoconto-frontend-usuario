import 'package:flutter/material.dart';
import 'package:hora_do_conto/views/tela_inicial.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'livro.dart';

void login(String email, String password, BuildContext context) async {
  final response = await http.post(
    Uri.parse('http://10.0.0.106:8080/auth/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'email': email, 'senha': password}),
  );

  try {
    if (response.statusCode == 200) {
      print('Login bem-sucedido');
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      String token = responseBody['token'];
      print('Token: $token');

      final storage = new FlutterSecureStorage();
      await storage.write(key: 'token', value: token);

      // Buscar a lista de livros após o login bem-sucedido
      List<Livro> livros = await getLivros(token);

      // Navegar para a TelaInicial com a lista de livros
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaInicial(livros: livros)),
      );
    } else if (response.statusCode == 401) {
      // Tratamento de erro para credenciais inválidas
      showErrorMessage(
          context, 'Credenciais inválidas. Por favor, tente novamente.');
    } else {
      // Tratamento de erro para outros códigos de status HTTP
      showErrorMessage(
          context, 'Credenciais inválidas. Por favor, tente novamente.');
    }
  } catch (e) {
    print('Erro: $e');
    showErrorMessage(
        context, 'Credenciais inválidas. Por favor, tente novamente.');
  }
}

void showErrorMessage(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Erro'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Fechar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<List<Livro>> getLivros(String token) async {
  final response = await http.get(
    Uri.parse('http://10.0.0.106:8080/livros/listar'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token,
    },
  );

  if (response.statusCode == 200) {
    List<dynamic> responseBody = jsonDecode(response.body);
    List<Livro> livros =
        responseBody.map((map) => Livro.fromJson(map)).toList();
    return livros;
  } else {
    throw Exception('Falha ao buscar livros');
  }
}

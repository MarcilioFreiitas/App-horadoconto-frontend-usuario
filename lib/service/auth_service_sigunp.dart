import 'dart:convert';
import 'package:hora_do_conto/widgets/config.dart';
import 'package:http/http.dart' as http;

void signup(String name, String lastName, String email, String password,
    String cpf) async {
  try {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nome': name,
        'sobreNome': lastName,
        'cpf': cpf,
        'email': email,
        'senha': password,
        'role': "USER"
      }),
    );

    if (response.statusCode == 200) {
      print('Usuário cadastrado com sucesso');
    } else {
      throw Exception('Falha ao cadastrar usuário');
    }
  } catch (e) {
    print('Ocorreu um erro: $e');
  }
}

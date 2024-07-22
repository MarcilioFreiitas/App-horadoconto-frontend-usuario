import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PerfilScreen extends StatelessWidget {
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<Map<String, String?>> _getUserInfo() async {
    String? id = await storage.read(key: 'user_id');
    String? nome = await storage.read(key: 'user_nome');
    String? sobreNome = await storage.read(key: 'user_sobreNome');
    String? cpf = await storage.read(key: 'user_cpf');
    String? email = await storage.read(key: 'user_email');
    String? role = await storage.read(key: 'user_role');

    return {
      'id': id,
      'nome': nome,
      'sobreNome': sobreNome,
      'cpf': cpf,
      'email': email,
      'role': role,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: _getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar informações do usuário'));
          } else {
            final userInfo = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${userInfo['nome'] ?? 'N/A'}'),
                  Text('Sobrenome: ${userInfo['sobreNome'] ?? 'N/A'}'),
                  Text('CPF: ${userInfo['cpf'] ?? 'N/A'}'),
                  Text('Email: ${userInfo['email'] ?? 'N/A'}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

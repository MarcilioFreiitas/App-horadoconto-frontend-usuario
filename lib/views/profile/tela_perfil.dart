import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hora_do_conto/views/editar_perfil.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  late Future<Map<String, String?>> _userInfo;

  @override
  void initState() {
    super.initState();
    _userInfo = _getUserInfo();
  }

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

  void _refreshUserInfo() {
    setState(() {
      _userInfo = _getUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Map<String, String?>>(
        future: _userInfo,
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
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      '[Insira aqui a URL da imagem do usuário]',
                    ),
                    radius: 50.0,
                  ),
                  SizedBox(height: 16.0),
                  Text('Nome: ${userInfo['nome'] ?? 'N/A'}'),
                  Text('Sobrenome: ${userInfo['sobreNome'] ?? 'N/A'}'),
                  Text('CPF: ${userInfo['cpf'] ?? 'N/A'}'),
                  Text('Email: ${userInfo['email'] ?? 'N/A'}'),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditarPerfilScreen(
                            userInfo: userInfo,
                            onSave: _refreshUserInfo,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black, // Cor preta
                    ),
                    child: Text('Alterar Dados'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

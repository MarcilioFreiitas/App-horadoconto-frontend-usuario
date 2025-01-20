import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hora_do_conto/views/about/about.dart';
import 'package:hora_do_conto/views/login-sigup/login.dart';
import 'package:hora_do_conto/views/profile/components/editar_perfil.dart';
import 'package:hora_do_conto/views/my_borrowings/my_borrowings.dart';
import 'package:hora_do_conto/views/notifications/notifications_screen.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  late Future<Map<String, String?>> _userInfo;

  @override
  void initState() {
    super.initState();
    _userInfo = _getUserInfo();
  }

  // Função que pega as informações do usuário do Flutter Secure Storage
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

  // Função para atualizar as informações do usuário
  void _refreshUserInfo() {
    setState(() {
      _userInfo = _getUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: _userInfo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
              child: Text('Erro ao carregar informações do usuário'));
        } else {
          final userInfo = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const ProfilePic(),
                const SizedBox(height: 20),
                Text(
                  'Olá, ${userInfo['nome'] ?? 'usuário'}!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 20),
                ProfileMenu(
                  text: "Minha Conta",
                  icon: "assets/icons/User Icon.svg",
                  press: () {
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
                ),
                ProfileMenu(
                  text: "Notificações",
                  icon: "assets/icons/Bell.svg",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationsScreen(),
                      ),
                    );
                  },
                ),
                ProfileMenu(
                  text: "Meus Empréstimos",
                  icon: "assets/icons/Clipboard.svg",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyBorrowingsScreen(),
                      ),
                    );
                  },
                ),
                ProfileMenu(
                  text: "Sobre",
                  icon: "assets/icons/Question mark.svg",
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutScreen(),
                      ),
                    );
                  },
                ),
                ProfileMenu(
                  text: "Sair",
                  icon: "assets/icons/Log out.svg",
                  press: () async {
                    // Limpar os dados de sessão
                    await storage.delete(key: 'token');
                    await storage.delete(key: 'user_id');
                    await storage.delete(key: 'user_nome');
                    await storage.delete(key: 'user_sobreNome');
                    await storage.delete(key: 'user_cpf');
                    await storage.delete(key: 'user_email');
                    await storage.delete(key: 'user_role');

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LogIn()),
                    );
                  },
                ),
                const SizedBox(height: 24.0),
              ],
            ),
          );
        }
      },
    );
  }
}

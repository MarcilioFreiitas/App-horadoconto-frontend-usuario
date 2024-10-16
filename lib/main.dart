import 'package:flutter/material.dart';
import 'package:hora_do_conto/views/home.dart';
import 'package:hora_do_conto/views/redefinir_senha.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';

import 'views/home_page.dart';
import 'views/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  void initUniLinks() async {
    _sub = linkStream.listen((String? link) {
      if (link != null) {
        final uri = Uri.parse(link);
        final token = uri.queryParameters['token'];
        if (token != null) {
          Navigator.pushNamed(context, '/redefinir_senha', arguments: token);
        }
      }
    }, onError: (err) {
      print(err);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App Flutter',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/redefinir_senha') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return ResetPasswordPage(token: args);
            },
          );
        }
        return null;
      },
      routes: {
        '/': (context) => Home(),
        '/login': (context) => LoginPage(),
        // Adicione outras rotas conforme necessário
      },
    );
  }
}

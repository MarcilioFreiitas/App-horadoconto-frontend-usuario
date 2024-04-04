import 'package:flutter/material.dart';
import 'package:hora_do_conto/views/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Aplicativo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(), // Defina a HomePage como a página inicial aqui
    );
  }
}

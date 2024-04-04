import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hora_do_conto/views/login.dart';

import '../service/livro.dart';
import 'login_page.dart';

class TelaInicial extends StatefulWidget {
  final List<Livro> livros;
  TelaInicial({required this.livros});

  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  int _indiceAtual = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _telas = [
      ListView.builder(
        itemCount: widget.livros.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.livros[index].titulo),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Autor: ' + widget.livros[index].autor),
                Text('Gênero: ' + widget.livros[index].genero),
                Text('Sinopse: ' + widget.livros[index].sinopse),
                Text('ISBN: ' + widget.livros[index].isbn),
                Text('Imagem da Capa: ' + widget.livros[index].imagem_capa),
                Text(
                    'Disponibilidade: ' + widget.livros[index].disponibilidade),
              ],
            ),
          );
        },
      ),
      Center(child: Text('Bem-vindo à Buscar!')),
      Center(child: Text('Bem-vindo ao Perfil!')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Aplicativo'),
      ),
      body: _telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        onTap: (index) {
          setState(() {
            _indiceAtual = index;
          });
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () async {
                // Limpar os dados de sessão
                final storage = new FlutterSecureStorage();
                await storage.delete(key: 'token');

                // Navegar para a tela de login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LogIn()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

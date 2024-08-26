import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hora_do_conto/views/detalhes_emprestimo.dart';
import 'package:hora_do_conto/views/gerenciar_emprestimo.dart';
import 'package:hora_do_conto/views/livro_search.dart';
import 'package:hora_do_conto/views/login.dart';
import 'package:hora_do_conto/views/tela_perfil.dart';
import '../models/livro.dart';
import 'dart:convert';

class TelaInicial extends StatefulWidget {
  final List<Livro> livros;
  TelaInicial({required this.livros});

  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  int _indiceAtual = 0;
  String servidor =
      'http://10.0.0.107:8080'; // Adicione a URL base do seu servidor aqui
  List<Livro> livrosExibidos = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    livrosExibidos = List<Livro>.from(widget.livros.take(15));
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  _getMoreData() {
    int len = livrosExibidos.length;
    for (int i = len; i < len + 15; i++) {
      if (i == widget.livros.length) {
        break;
      }
      livrosExibidos.add(widget.livros[i]);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _telas = [
      ListView.builder(
        controller: _scrollController,
        itemCount: widget.livros.length,
        itemBuilder: (context, index) {
          String urlImagem = servidor + widget.livros[index].imagem_capa;
          return Stack(
            children: <Widget>[
              Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          urlImagem,
                          width: 120,
                          height: 200,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'Autor: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(widget.livros[index].autor),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'Titulo: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Expanded(
                                child: Text(widget.livros[index].titulo),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(utf8.decode(widget
                                    .livros[index].sinopse.runes
                                    .toList())),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Row(
                  children: <Widget>[
                    Text(
                      widget.livros[index].disponibilidade == 'true'
                          ? 'Disponível'
                          : 'Indisponível',
                      style: TextStyle(
                        color: widget.livros[index].disponibilidade == 'true'
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    SizedBox(width: 23),
                    Visibility(
                      visible: widget.livros[index].disponibilidade == 'true',
                      child: Container(
                        height: 30,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalhesEmprestimo(
                                  livroId: widget.livros[index].id.toString(),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Solicitar Empréstimo',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      Center(child: Text('Bem-vindo ao Perfil!')),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text('Hora do conto'),
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                // Implemente a lógica de busca aqui
                String? busca = await showSearch(
                  context: context,
                  delegate: LivroSearch(widget.livros),
                );
                print('Busca: $busca');
              },
            ),
          ],
        ),
        body: _telas[_indiceAtual],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceAtual,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined), label: 'Categoria'),
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
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/logo1.png'), // Caminho da imagem
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ListTile(
                title: Text('Meu perfil'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PerfilScreen()),
                  );
                },
              ),
              ListTile(
                title: Text('Gerenciar empréstimos'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmprestimosComponent()),
                  );
                },
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
        ));
  }
}

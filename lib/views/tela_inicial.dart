import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hora_do_conto/views/detalhes_emprestimo.dart';
import 'package:hora_do_conto/views/gerenciar_emprestimo.dart';
import 'package:hora_do_conto/views/home/components/livro_search.dart';
import 'package:hora_do_conto/views/login-sigup/login.dart';
import 'package:hora_do_conto/views/profile/tela_perfil.dart';
import 'package:hora_do_conto/widgets/config.dart';
import '../models/livro.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TelaInicial extends StatefulWidget {
  final List<Livro> livros;
  TelaInicial({required this.livros});

  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  String servidor =
      '${Config.baseUrl}'; // Adicione a URL base do seu servidor aqui
  List<Livro> livrosExibidos = [];
  ScrollController _scrollController = ScrollController();
  bool isFiltered = false;

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

  Future<void> _getMoreData() async {
    int len = livrosExibidos.length;
    for (int i = len; i < len + 15; i++) {
      if (i == widget.livros.length) {
        break;
      }
      livrosExibidos.add(widget.livros[i]);
    }
    setState(() {});
  }

  Future<void> _refreshLivros() async {
    try {
      final response = await http.get(Uri.parse('$servidor/livros/listar'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          livrosExibidos =
              List<Livro>.from(data.map((item) => Livro.fromJson(item)));
        });
      } else {
        print('Erro na resposta: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro durante a requisição: $e');
    }
  }

  void _filterLivros(String query) {
    final filtered = widget.livros.where((livro) {
      final titulo = livro.titulo.toLowerCase();
      final input = query.toLowerCase();
      return titulo.contains(input);
    }).toList();

    setState(() {
      livrosExibidos = filtered;
      isFiltered = true;
    });
  }

  void _resetLivros() {
    setState(() {
      livrosExibidos = List<Livro>.from(widget.livros.take(15));
      isFiltered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hora do conto'),
        backgroundColor: Colors.black,
        leading: isFiltered
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: _resetLivros,
              )
            : null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              // Implemente a lógica de busca aqui
              String? busca = await showSearch(
                context: context,
                delegate: LivroSearch(widget.livros),
              );
              if (busca != null) {
                _filterLivros(busca);
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshLivros,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: livrosExibidos.length,
          itemBuilder: (context, index) {
            String urlImagem = servidor + livrosExibidos[index].imagem_capa;
            return GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalhesEmprestimo(
                      livroId: livrosExibidos[index].id.toString(),
                    ),
                  ),
                );
                _resetLivros(); // Redefine a lista de livros ao voltar
              },
              child: Stack(
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(livrosExibidos[index].autor),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Titulo: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: Text(livrosExibidos[index].titulo),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(utf8.decode(
                                        livrosExibidos[index]
                                            .sinopse
                                            .runes
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
                          livrosExibidos[index].disponibilidade == 'true'
                              ? 'Disponível'
                              : 'Indisponível',
                          style: TextStyle(
                            color:
                                livrosExibidos[index].disponibilidade == 'true'
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ),
                        SizedBox(width: 23),
                        Visibility(
                          visible:
                              livrosExibidos[index].disponibilidade == 'true',
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
                                      livroId:
                                          livrosExibidos[index].id.toString(),
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
              ),
            );
          },
        ),
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
      ),
    );
  }
}

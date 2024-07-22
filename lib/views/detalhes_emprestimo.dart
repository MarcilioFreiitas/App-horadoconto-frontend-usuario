import 'package:flutter/material.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> criarEmprestimo(String usuarioId, String livroId,
    DateTime dataRetirada, DateTime dataDevolucao) async {
  var url =
      'http://10.0.0.107:8080/emprestimo/criarEmpresitmo'; // Substitua pela URL da sua API

  var response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'usuario_id': usuarioId,
      'livro_id': livroId,
      'dataRetirada': dataRetirada.toIso8601String(),
      'dataDevolucao': dataDevolucao.toIso8601String(),
      'statusEmprestimo': 'PENDENTE',
    }),
  );

  if (response.statusCode == 200) {
    // Se o servidor retornar um código de resposta OK, parseie o JSON.
    print('Empréstimo solicitado com sucesso');
  } else {
    // Se o servidor retornar uma resposta não-OK, lance uma exceção.
    throw Exception('Falha ao solicitar empréstimo');
  }
}

class DetalhesEmprestimo extends StatefulWidget {
  final String livroId;
  DetalhesEmprestimo({required this.livroId});

  @override
  _DetalhesEmprestimoState createState() => _DetalhesEmprestimoState();
}

class _DetalhesEmprestimoState extends State<DetalhesEmprestimo> {
  Livro? livro;
  DateTime? dataDevolucao;

  Future<void> fetchLivro() async {
    // Substitua 'http://seu-servidor/livros/${widget.livroId}' pela URL da sua API
    final response = await http.get(
        Uri.parse('http://10.0.0.107:8080/livros/listar/${widget.livroId}'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(
          'Dados do livro: $data'); // Adicione este print para verificar os dados
      setState(() {
        livro = Livro.fromJson(data);
      });
    } else {
      print('Erro ao buscar livro: ${response.statusCode}');
      // Tratar erros na requisição
    }
  }

  @override
  void initState() {
    super.initState();
    fetchLivro();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Empréstimo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (livro != null) ...[
              Text('Título: ${livro!.titulo}'),
              Text('Autor: ${livro!.autor}'),
              Text('Ano: ${livro!.genero}'),
              Text('Editora: ${livro!.disponibilidade}'),
              Text('ISBN: ${livro!.isbn}'),
              SizedBox(height: 20),
            ] else ...[
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Carregando informações do livro...'),
            ],
            Text(
              'Data de Devolução:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final DateTime? dataSelecionada = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (dataSelecionada != null) {
                  setState(() {
                    dataDevolucao = dataSelecionada;
                  });
                }
              },
              child: Text('Selecionar Data'),
            ),
            SizedBox(height: 20),
            if (dataDevolucao != null)
              Text('Data Selecionada: ${dataDevolucao?.toLocal()}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: dataDevolucao != null
                  ? () async {
                      try {
                        // Substitua 'usuarioId' pelo ID do usuário logado
                        await criarEmprestimo('usuarioId', widget.livroId,
                            DateTime.now(), dataDevolucao!);
                        // Exibir mensagem de sucesso (opcional)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Empréstimo solicitado com sucesso!'),
                          ),
                        );
                      } catch (error) {
                        // Exibir mensagem de erro
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Erro ao solicitar empréstimo: $error'),
                          ),
                        );
                      }
                    }
                  : null,
              child: Text('Solicitar Empréstimo'),
            ),
          ],
        ),
      ),
    );
  }
}

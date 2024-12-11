import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/widgets/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> criarEmprestimo(String usuarioId, String livroId,
    DateTime dataRetirada, DateTime dataDevolucao, BuildContext context) async {
  // Verificar se a data de devolução não ultrapassa um mês a partir da data de retirada
  if (dataDevolucao.isAfter(dataRetirada.add(Duration(days: 30)))) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'A data de devolução não pode ultrapassar um mês a partir da data de empréstimo.'),
      ),
    );
    return;
  }

  var url =
      '${Config.baseUrl}/emprestimo/criarEmprestimo'; // Substitua pela URL da sua API

  var response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'usuario': {'id': usuarioId},
      'livro': {'id': livroId},
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
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> fetchLivro() async {
    final response = await http
        .get(Uri.parse('${Config.baseUrl}/livros/buscar/${widget.livroId}'));
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
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (livro != null) ...[
                Expanded(
                  flex: 1,
                  child: Image.network(
                    '${Config.baseUrl}${livro!.imagem_capa}', // Use a propriedade 'imagem_capa' do seu modelo 'Livro'
                    width: 300, // Ajuste a largura da imagem conforme desejado
                    height: 300, // Ajuste a altura da imagem conforme desejado
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return CircularProgressIndicator();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Erro ao carregar imagem');
                    },
                  ),
                ),
                SizedBox(width: 10), // Espaço entre a imagem e os atributos
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 80),
                      Text('Título: ${livro!.titulo}'),
                      SizedBox(height: 5),
                      Text('Autor: ${livro!.autor}'),
                      SizedBox(height: 5),
                      Text('Gênero: ${livro!.genero}'),
                      SizedBox(height: 5),
                      Text('Disponibilidade: ${livro!.disponibilidade}'),
                      SizedBox(height: 5),
                      Text('ISBN: ${livro!.isbn}'),
                      SizedBox(height: 5),
                      Text('Sinopse: ${livro!.sinopse}'),
                      SizedBox(height: 20),
                      Text(
                        'Data de Devolução:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          final DateTime? dataSelecionada =
                              await showDatePicker(
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
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // Cor preta
                        ),
                        child: Text('Selecionar Data'),
                      ),
                      SizedBox(height: 10),
                      if (dataDevolucao != null)
                        Text('Data Selecionada: ${dataDevolucao?.toLocal()}'),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: dataDevolucao != null
                            ? () async {
                                try {
                                  // Substitua 'usuarioId' pelo ID do usuário logado
                                  String? usuarioId =
                                      await _storage.read(key: 'user_id');
                                  if (usuarioId == null) {
                                    throw Exception(
                                        'ID do usuário não encontrado');
                                  }
                                  await criarEmprestimo(
                                      usuarioId,
                                      widget.livroId,
                                      DateTime.now(),
                                      dataDevolucao!,
                                      context);
                                  // Exibir mensagem de sucesso (opcional)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Empréstimo solicitado com sucesso!'),
                                    ),
                                  );
                                } catch (error) {
                                  // Exibir mensagem de erro
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Erro ao solicitar empréstimo: $error'),
                                    ),
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // Cor preta
                        ),
                        child: Text('Solicitar Empréstimo'),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Carregando informações do livro...'),
              ],
            ],
          ),
        ));
  }
}

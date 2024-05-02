import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> criarEmprestimo(String usuarioId, String livroId,
    DateTime dataRetirada, DateTime dataDevolucao) async {
  var url =
      'http://seu-servidor.com/api/emprestimos'; // Substitua pela URL da sua API

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
  DateTime? dataDevolucao;

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
              onPressed: () {
                // Substitua 'usuarioId' e 'livroId' pelos IDs apropriados
                criarEmprestimo(
                    'usuarioId', 'livroId', DateTime.now(), dataDevolucao!);
              },
              child: Text('Solicitar Empréstimo'),
            ),
          ],
        ),
      ),
    );
  }
}

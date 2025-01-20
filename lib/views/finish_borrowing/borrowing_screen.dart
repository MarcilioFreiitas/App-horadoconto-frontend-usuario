import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/views/finish_borrowing/components/detalhes_emprestimo.dart';
import 'package:hora_do_conto/views/finish_borrowing/components/top_Rounded_Container.dart';
import 'package:hora_do_conto/views/finish_borrowing/components/Custom_AppBar.dart';
import 'package:hora_do_conto/widgets/Config.dart';
import 'package:hora_do_conto/widgets/size_config.dart';
import 'package:hora_do_conto/widgets/theme.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Borrowing extends StatefulWidget {
  final Livro book;
  final List<Livro> livros;

  const Borrowing({super.key, required this.book, required this.livros});

  Future<void> criarEmprestimo(
      String usuarioId,
      String livroId,
      DateTime dataRetirada,
      DateTime dataDevolucao,
      BuildContext context) async {
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

  @override
  State<Borrowing> createState() => _BorrowingState();
}

class _BorrowingState extends State<Borrowing> {
  DateTime? dataDevolucao;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme(context),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F9),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: CustomAppBar(livros: widget.livros),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lista de itens
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagem do livro
                  Container(
                    height: getProportionateScreenWidth(125),
                    width: getProportionateScreenWidth(88),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '${Config.baseUrl}${widget.book.imagem_capa}', // Substitua `imagemCapa` pelo campo correto
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Detalhes do livro
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.book.titulo,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                          maxLines: 2, // Limita o texto a 2 linhas
                          overflow: TextOverflow
                              .ellipsis, // Adiciona reticências em textos longos
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "x1", // Quantidade de livros
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: getProportionateScreenWidth(16),
                                    color: Colors.grey,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Detalhes adicionais do livro (autor, sinopse, etc.) com top rounded container
              TopRoundedContainer(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth *
                        0.06, // Menor que antes para garantir o espaçamento adequado
                    right: SizeConfig.screenWidth *
                        0.06, // Menor que antes para garantir o espaçamento adequado
                    bottom: getProportionateScreenHeight(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Garantindo que o texto fique à esquerda
                    children: [
                      // Informações do livro
                      RichText(
                        text: TextSpan(
                          text: "Autor: ", // Rótulo em negrito
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.bold, // Negrito
                                    color: Colors.black54,
                                  ),
                          children: [
                            TextSpan(
                              text: widget
                                  .book.autor, // Nome do autor sem negrito
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight:
                                        FontWeight.normal, // Sem negrito
                                    color: Colors.black54,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: "Gênero: ", // Rótulo em negrito
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.bold, // Negrito
                                    color: Colors.black54,
                                  ),
                          children: [
                            TextSpan(
                              text: Livro.generoMap[widget.book.genero] ??
                                  widget.book
                                      .genero, // Usa o nome amigável do gênero, caso exista, senão exibe o valor original
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight:
                                        FontWeight.normal, // Sem negrito
                                    color: Colors.black54,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: "ISBN: ", // Rótulo em negrito
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.bold, // Negrito
                                    color: Colors.black54,
                                  ),
                          children: [
                            TextSpan(
                              text: widget.book.isbn, // ISBN sem negrito
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight:
                                        FontWeight.normal, // Sem negrito
                                    color: Colors.black54,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          text: "Sinopse: ", // Rótulo em negrito
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight: FontWeight.bold, // Negrito
                                    color: Colors.black54,
                                  ),
                          children: [
                            TextSpan(
                              text: widget.book.sinopse, // Sinopse sem negrito
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: getProportionateScreenWidth(16),
                                    fontWeight:
                                        FontWeight.normal, // Sem negrito
                                    color: Colors.black54,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Botão para selecionar a data
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
                      const SizedBox(height: 10),

                      // Exibe a data selecionada, se houver
                      if (dataDevolucao != null)
                        Text('Data Selecionada: ${dataDevolucao?.toLocal()}'),

                      const SizedBox(height: 15),

                      // Mensagem de prazo de devolução
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.black),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                "A data de devolução não pode ultrapassar um mês a partir da data de empréstimo!",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: getProportionateScreenWidth(14),
                                      color: Colors.black54,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(), // Isso empurra o conteúdo para o final da tela
              // Total e botão
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Deseja confirmar\no empréstimo deste livro?",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: getProportionateScreenWidth(16),
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                  ),
                  ElevatedButton(
                    onPressed: dataDevolucao != null
                        ? () async {
                            try {
                              // Substitua 'usuarioId' pelo ID do usuário logado
                              String? usuarioId =
                                  await _storage.read(key: 'user_id');
                              if (usuarioId == null) {
                                throw Exception('ID do usuário não encontrado');
                              }
                              await criarEmprestimo(
                                usuarioId,
                                widget.book.id.toString(),
                                DateTime.now(),
                                dataDevolucao!,
                                context,
                              );
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
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Finalizar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

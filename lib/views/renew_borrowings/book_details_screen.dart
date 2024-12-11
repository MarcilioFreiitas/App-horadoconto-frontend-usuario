import 'package:flutter/material.dart';
import 'package:hora_do_conto/views/renew_borrowings/components/top_Rounded_Container.dart';
import 'package:hora_do_conto/widgets/config.dart';
import 'package:hora_do_conto/views/renew_borrowings/components/Custom_app_bar.dart';
import 'package:hora_do_conto/widgets/size_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> emprestimo;

  BookDetailsScreen(this.emprestimo);

  Future<void> _renovarEmprestimo(
      BuildContext context, int emprestimoId) async {
    DateTime selectedDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      try {
        final response = await http.put(
          Uri.parse(
              '${Config.baseUrl}/emprestimo/renovarEmprestimo/$emprestimoId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'dataDevolucao': picked.toIso8601String()}),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Empréstimo renovado com sucesso!')),
          );
        } else {
          _showErrorDialog(context, 'Erro ao renovar empréstimo',
              'Não foi possível renovar o empréstimo. Tente novamente mais tarde.');
        }
      } catch (e) {
        _showErrorDialog(context, 'Erro na chamada à API',
            'Verifique sua conexão com a internet e tente novamente.');
      }
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget buildBookImage(String imageUrl) {
    return Center(
      // Centraliza a imagem
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16), // Bordas arredondadas
        child: Image.network(
          '${Config.baseUrl}$imageUrl',
          fit: BoxFit.contain, // Ajusta a imagem sem distorcer
          width: getProportionateScreenWidth(200), // Ajusta o tamanho da imagem
          height:
              getProportionateScreenHeight(300), // Ajusta o tamanho da imagem
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, color: Colors.red);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmprestado = emprestimo['statusEmprestimo'] == 'EMPRESTADO';
    final bool isPendente = emprestimo['statusEmprestimo'] == 'PENDENTE';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80), // Altura do AppBar
        child: CustomAppBar(titulo: emprestimo['tituloLivro']),
      ),
      body: SingleChildScrollView(
        // Permite rolagem vertical
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Usando a função buildBookImage para exibir a imagem
            buildBookImage(emprestimo['imagem']),
            SizedBox(height: 16),
            // Conteúdo dentro do TopRoundedContainer
            TopRoundedContainer(
              color: Colors.white, // Cor de fundo do container
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Título: ${emprestimo['tituloLivro']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Devolução: ${emprestimo['dataDevolucao']}'),
                    SizedBox(height: 8),
                    Text('Status: ${emprestimo['statusEmprestimo']}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: isEmprestado
                          ? () => _renovarEmprestimo(context, emprestimo['id'])
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Só é possível renovar se o status for "Emprestado".'),
                                ),
                              );
                            },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          isEmprestado ? Colors.black : Colors.grey,
                        ),
                      ),
                      child: Text('Renovar Empréstimo'),
                    ),
                    if (isEmprestado) SizedBox(height: 16),
                    if (isEmprestado)
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
                                "Dirija-se à biblioteca do IFPE Campus Palmares para retirar o livro e receber orientações",
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
                    if (isPendente) SizedBox(height: 16),
                    if (isPendente)
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
                                "Você receberá um e-mail notificando quando seu empréstimo for aprovado!",
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
          ],
        ),
      ),
    );
  }
}

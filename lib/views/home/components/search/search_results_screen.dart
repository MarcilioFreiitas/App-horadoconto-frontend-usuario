import 'package:flutter/material.dart';
import 'package:hora_do_conto/models/livro.dart'; // Importe o modelo de Livro
import 'package:hora_do_conto/views/details/details_screen.dart';
import 'package:hora_do_conto/views/home/components/search/components/Custom_AppBar.dart';
import 'package:hora_do_conto/widgets/config.dart'; // Configuração para a URL base
import 'package:hora_do_conto/widgets/theme.dart'; // Importação do tema, caso necessário

class SearchResultsScreen extends StatelessWidget {
  final String searchQuery;
  final List<Livro> livros;

  const SearchResultsScreen({
    super.key,
    required this.searchQuery,
    required this.livros,
  });

  @override
  Widget build(BuildContext context) {
    // Filtrando os livros com base na pesquisa
    List<Livro> filteredBooks = livros.where((livro) {
      return livro.titulo.toLowerCase().contains(searchQuery.toLowerCase()) ||
          livro.autor.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Theme(
      data: AppTheme.lightTheme(context), // Define o tema que você está usando
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: CustomAppBar(),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 20.0), // Adiciona espaço após o AppBar
          child: filteredBooks.isEmpty
              ? const Center(
                  child: Text('Nenhum livro encontrado'),
                )
              : ListView.builder(
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    final livro = filteredBooks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          // Navegação para a tela de detalhes
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(
                                  book: livro, livros: filteredBooks),
                            ),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Imagem do livro
                            Container(
                              height: 125,
                              width: 88,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  '${Config.baseUrl}${livro.imagem_capa}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Detalhes do livro
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 140,
                                  child: Text(
                                    livro.titulo,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Autor: ${livro.autor}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Gênero: ${livro.genero ?? 'Desconhecido'}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'ISBN: ${livro.isbn ?? 'Indisponível'}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

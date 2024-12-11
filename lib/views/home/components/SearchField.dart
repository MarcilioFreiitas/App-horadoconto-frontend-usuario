import 'package:flutter/material.dart';
import 'package:hora_do_conto/views/home/components/search/search_results_screen.dart';
import 'package:hora_do_conto/models/livro.dart'; // Importando o modelo Livro

class SearchField extends StatelessWidget {
  final List<Livro>
      livros; // Adicionando o parâmetro para receber a lista de livros

  const SearchField({
    super.key,
    required this.livros, // Requer a lista de livros
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController =
        TextEditingController(); // Controlador para o TextField

    return Container(
      width: MediaQuery.of(context).size.width * 0.6, // Largura adaptável
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1), // Altere para a cor desejada
        borderRadius: BorderRadius.circular(15),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 20), // Ajuste o padding conforme necessário
          child: TextField(
            controller: searchController, // Vinculando o controlador
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: "Procurar livros",
              prefixIcon: const Icon(Icons.search),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
            ),
            onSubmitted: (value) {
              // Ao pressionar Enter ou Search no teclado, envia a pesquisa
              if (value.isNotEmpty) {
                // Navega para a página de resultados com o valor de pesquisa
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResultsScreen(
                      searchQuery: value,
                      livros:
                          livros, // Passando a lista de livros para a tela de resultados
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

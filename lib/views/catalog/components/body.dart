import 'package:flutter/material.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/views/catalog/components/Book_Section.dart';
import 'package:hora_do_conto/views/catalog/components/Custom_AppBar.dart';
import 'package:hora_do_conto/widgets/size_config.dart';
import 'package:hora_do_conto/views/home/components/home_header.dart';

class Body extends StatelessWidget {
  final List<Livro> livros;

  const Body({Key? key, required this.livros}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Agrupar livros por gênero
    Map<String, List<Livro>> livrosPorGenero = {};
    for (var livro in livros) {
      if (!livrosPorGenero.containsKey(livro.genero)) {
        livrosPorGenero[livro.genero] = [];
      }
      livrosPorGenero[livro.genero]!.add(livro);
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F9),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(AppBar().preferredSize.height),
          child: CustomAppBar(livros: livros),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenWidth(25)),
              HomeHeader(
                livros: livros,
              ),
              SizedBox(height: getProportionateScreenWidth(25)),
              // Itera sobre os gêneros e cria uma seção para cada um
              ...livrosPorGenero.entries.map((entry) {
                print(
                    'Gênero: ${entry.key}'); // Exibe o valor original do gênero
                print('Livros desse gênero: ${entry.value.length}');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CatalogBookSection(
                      text: Livro.generoMap[entry.key] ??
                          "Desconhecido", // Gênero do livro
                      books: entry.value, // Livros desse gênero
                    ),
                    SizedBox(
                        height: getProportionateScreenWidth(
                            25)), // Espaço entre seções
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

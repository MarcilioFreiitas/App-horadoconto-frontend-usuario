import 'package:flutter/material.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/views/catalog/Catalog_Screen.dart';
import 'package:hora_do_conto/views/details/details_screen.dart';
import 'package:hora_do_conto/views/home/components/book_card.dart';
import 'package:hora_do_conto/views/home/components/section_title.dart';
import 'package:hora_do_conto/widgets/size_config.dart';

class BookSection extends StatelessWidget {
  const BookSection({
    Key? key,
    required this.text,
    required this.books, // Corrigido para usar a lista correta de livros
  }) : super(key: key);

  final String text;
  final List<Livro> books; // Usando a lista de livros correta

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          text: text,
          press: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CatalogScreen(livros: books),
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                books.take(10).length, // Pegando apenas os primeiros 10 livros
                (index) => BookCard(
                  book: books[index],
                  press: () {
                    // Navegação para a tela de perfil ou detalhes do livro
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                          book: books[index],
                          livros: books,
                        ), // Ajuste conforme necessário
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        ),
      ],
    );
  }
}

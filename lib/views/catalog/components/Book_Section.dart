import 'package:flutter/material.dart';
import 'package:hora_do_conto/models/livro.dart';
import 'package:hora_do_conto/views/home/components/book_card.dart';
import 'package:hora_do_conto/views/profile/tela_perfil.dart';
import 'package:hora_do_conto/widgets/size_config.dart';

class CatalogBookSection extends StatelessWidget {
  const CatalogBookSection({
    Key? key,
    required this.text,
    required this.books,
  }) : super(key: key);

  final String text;
  final List<Livro> books;

  @override
  Widget build(BuildContext context) {
    print('Texto do Gênero na seção: $text'); // Verifica o valor do texto

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Aqui exibimos o nome do gênero
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            text, // Gênero do livro
            style: TextStyle(
              fontSize: getProportionateScreenWidth(18),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                books.length,
                (index) => BookCard(
                  book: books[index],
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PerfilScreen(), // Navegação conforme necessário
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
